--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;
	
	--PC
	signal PCans: std_logic_vector (31 downto 0);
	signal nextInstruct: std_logic_vector (31 downto 0);
	
	--PCadder
	signal pcadd: std_logic_vector (31 downto 0);
	signal carryout: std_logic;

	--instructionMem
	signal instruction: std_logic_vector (31 downto 0);

	-- Registers
	signal writingData: std_logic_vector(31 downto 0);
	signal writingCMD: std_logic;
	signal readDataOut1: std_logic_vector(31 downto 0);
	signal readDataOut2: std_logic_vector(31 downto 0);

	-- Control
	signal branchOut: std_logic_vector(1 downto 0);
	signal memoryRead: std_logic;
	signal memorytoReg:std_logic;
	signal ALUcontrol: std_logic_vector (4 downto 0);
	signal memoryWrite: std_logic;
	signal alusource: std_logic;
	signal registerWrite: std_logic;
	signal immediate: std_logic_vector (1 downto 0);

	-- ALU Mux
	signal immediateGen: std_logic_vector(31 downto 0);
	signal muxResult1: std_logic_vector(31 downto 0);

	-- ALU
	signal Zero1: std_logic;
	signal ALUResult1: std_logic_vector(31 downto 0);

	-- Offset Adder/Sub
	signal carryout2: std_logic;
	signal offsetAddress: std_logic_vector(31 downto 0);
	
	-- PC/ImmGen Adder
	signal carryout3: std_logic;
	signal adding: std_logic_vector(31 downto 0);

	-- BranchMux
	signal branchSelect: std_logic;
	
	-- Data Memory
	signal ramResult:std_logic_vector(31 downto 0);

	-- Data Mem Mux
	
begin
	-- Add your code here

	pc: ProgramCounter port map(reset, clock, nextInstruct, PCans);
	pcadder: adder_subtracter port map(PCans, X"00000004", '0', pcadd, carryout); 
	instructionMem : InstructionRAM port map (reset, clock, PCans(31 downto 2), instruction); 
	regFile: Registers port map(instruction(19 downto 15),instruction(24 downto 20),Instruction(11 downto 7), writingData, registerWrite, readDataOut1, readDataOut2);
	controller: Control port map(clock,instruction(6 downto 0),instruction(14 downto 12),instruction(31 downto 25), branchOut, memoryread,memorytoReg, ALUcontrol, memorywrite, alusource, registerWrite,immediate);
	alumux: BusMux2to1 port map(alusource, readDataout2, immediateGen,muxResult1);
	arithmeticLogicUnit: ALU port map(readDataOut1, muxResult1, ALUcontrol,Zero1 ,ALUResult1);
	offset: adder_subtracter port map( ALUResult1, x"10000000", '1', offsetAddress, carryout2);
	PCImmGenAdder: adder_subtracter port map(PCans, immediateGen , '0', adding, carryout3); 
	branchmux: BusMux2to1 port map(branchSelect, pcadd, adding, nextInstruct);
	dmem: RAM port map (reset, clock, memoryread ,memorywrite, offsetAddress(31 downto 2), readDataOut2, ramResult);
	dmemmux: BusMux2to1 port map(memorytoReg, ALUResult1, ramResult, writingData);

	immediateGen(31 downto 12) <=   (Others=>instruction(31)) when immediate = "00" else								--I type
				   	(Others=>instruction(31)) when immediate = "01" else								--S type
				   	(Others=>instruction(31)) when immediate = "10" else								--B type
				   	Instruction(31 downto 12);

	immediateGen(11 Downto 0) <= 	instruction(31 downto 20) when immediate = "00" else								--I type
				  	instruction(31 downto 25) & Instruction(11 downto 7) when immediate = "01" else					--S type
				  	instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0' when immediate = "10" else		--B type
				  	(OTHERS=>'0');
	

	branchSelect <= '1' when (branchOut = "01" AND Zero1 = '1') OR (branchOut = "10" AND Zero1 = '0') else						--beq/bne
			'0';

	 
end holistic;
