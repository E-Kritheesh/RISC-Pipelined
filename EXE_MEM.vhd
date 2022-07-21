library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXE_MEM is
	port(EXE_MEM_EN,RST: in std_logic;
		  LS7_in,ALUout_in,D2_in,PCn_in: in std_logic_vector(15 downto 0);
		  OP_in: in std_logic_vector(3 downto 0);
		  D113_in: in std_logic_vector(8 downto 0);
		  LS7_out,ALUout_out,D2_out,PCn_out: out std_logic_vector(15 downto 0);
		  OP_out: out std_logic_vector(3 downto 0);
		  D113_out: out std_logic_vector(8 downto 0));
end entity;

architecture EXE_MEM_Arch of EXE_MEM is
	
	signal LS7,ALUout,D2,PCn: std_logic_vector(15 downto 0):=("0000000000000000");
	signal OP: std_logic_vector(3 downto 0):=("0000");
	signal D113: std_logic_vector(8 downto 0):=("000000000");
	
begin
	process(EXE_MEM_EN,RST,LS7_in,ALUout_in,D2_in,PCn_in,OP_in,D113_in)
	begin
		if RST='0' then
			if EXE_MEM_EN='1' then 
				LS7 <= LS7_in;
				ALUout <= ALUout_in;
				D2 <= D2_in;
				PCn <= PCn_in;
				OP <= OP_in;
				D113 <= D113_in;
			end if;
		else 
			LS7 <= "0000000000000000";
			ALUout <= "0000000000000000";
			D2 <= "0000000000000000";
			PCn <= "0000000000000000";
			OP <= "0000";
			D113 <= "000000000";
		end if;
	end process;
	LS7_out <= LS7;
	ALUout_out <= ALUout;
	D2_out <= D2;
	PCn_out <= PCn;
	OP_out <= OP;
	D113_out <= D113;
end architecture;