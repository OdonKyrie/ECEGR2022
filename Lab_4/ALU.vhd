--------------------------------------------------------------------------------
--
-- LAB #4-----------------------------------------------------------------------
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	SIGNAL i1: std_logic_vector(31 downto 0);
	SIGNAL i2: std_logic_vector(31 downto 0);
	SIGNAL i3: std_logic_vector(31 downto 0);
	SIGNAL i4: std_logic_vector(31 downto 0);
	SIGNAL i5: std_logic_vector(31 downto 0);
	SIGNAL i6: std_logic_vector(31 downto 0);
	SIGNAL i7: std_logic_vector(31 downto 0);

begin
	-- Add ALU VHDL implementation here
	great: adder_subtracter port map(DataIn1,DataIn2,'0', i1, Zero);	
	greati: adder_subtracter port map(DataIn1,DataIn2,'0', i2, Zero);
	minu: adder_subtracter port map(DataIn1,DataIn2,'1', i3, Zero);	
	sllc_md: shift_register port map(DataIn1, '0', DataIn2(4 downto 0), i4);	
	sllic_md: shift_register port map(DataIn1, '0', DataIn2(4 downto 0), i5);	
	srlc_md: shift_register port map(DataIn1, '1', DataIn2(4 downto 0), i6);	
	slrinc_md: shift_register port map(DataIn1, '1', DataIn2(4 downto 0), i7);	
	
		
	
	with ALUCtrl select 
	ALUResult <=    	i1 when "00000",
				i2 when "00001",
				i3 when "00010",
				DataIn1 or DataIn2 when "00011",
				DataIn1 or DataIn2 when "00100", --select statments 
				DataIn1 and DataIn2 when "00101",
				DataIn1 and DataIn2 when "00110",
				i4 when "00111",
				i5 when "01000",
				i6 when "01001",
				i7 when "01010",
				X"00000000" when others;
				
end architecture ALU_Arch;



