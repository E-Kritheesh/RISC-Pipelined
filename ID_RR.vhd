library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_RR is
	port(ID_RR_EN,RST: in std_logic;
		  PC_in,SE10_in,SE7_in,LS7_in,PCn_in: in std_logic_vector(15 downto 0);
		  OP_in: in std_logic_vector(3 downto 0);
		  D119_in,D86_in: in std_logic_vector(2 downto 0);
		  D70_in: in std_logic_vector(7 downto 0);
		  PC_out,SE10_out,SE7_out,LS7_out,PCn_out: out std_logic_vector(15 downto 0);
		  OP_out: out std_logic_vector(3 downto 0);
		  D119_out,D86_out: out std_logic_vector(2 downto 0);
		  D70_out: out std_logic_vector(7 downto 0));
end entity;

architecture ID_RR_arch of ID_RR is
	signal PC,SE10,SE7,LS7,PCn: std_logic_vector(15 downto 0):=("0000000000000000");
	signal OP: std_logic_vector(3 downto 0):=("0000");
	signal D119,D86: std_logic_vector(2 downto 0):=("000");
	signal D70: std_logic_vector(7 downto 0):=("00000000");
begin
	process(ID_RR_EN,RST,PC_in,SE10_in,SE7_in,LS7_in,PCn_in,OP_in,D119_in,D86_in,D70_in)
	begin
		if RST='0' then
			if ID_RR_EN='1' then 
				PC <= PC_in;
				SE10 <= SE10_in;
				SE7 <= SE7_in;
				LS7 <= LS7_in;
				PCn <= PCn_in;
				OP <= OP_in;
				D119 <= D119_in;
				D86  <= D86_in;
				D70  <= D70_in;
			end if;
		else 
			PC <= "0000000000000000";
			SE10 <= "0000000000000000";
			SE7 <= "0000000000000000";
			LS7 <= "0000000000000000";
			PCn <= "0000000000000000";
			OP <= "0000";
			D119 <= "000";
			D86 <= "000";
			D70 <= "00000000";
		end if;
	end process;
	PC_out <= PC;
	SE10_out <= SE10;
	SE7_out <= SE7;
	LS7_out <= LS7;
	PCn_out <= PCn;
	OP_out <= OP;
	D119_out <= D119;
	D86_out <= D86;
	D70_out <= D70;
end architecture;