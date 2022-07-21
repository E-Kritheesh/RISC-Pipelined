library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID is
	port(IF_ID_EN,RST: in std_logic;
		  IR_in, PC_in,PCn_in: in std_logic_vector(15 downto 0);
		  IR_out,PC_out,PCn_out: out std_logic_vector(15 downto 0));
end entity;

architecture IF_ID_arch of IF_ID is
	signal IR,PC,PCn: std_logic_vector(15 downto 0):=("0000000000000000");
begin
	process(IF_ID_EN,RST,IR_in,PC_in,PCn_in)
	begin
		if RST='0' then
			if IF_ID_EN='1' then 
				IR <= IR_in;
				PC <= PC_in;
				PCn <= PCn_in;
			end if;
		else 
			IR <= "0000000000000000";
			PC <= "0000000000000000";
			PCn <= "0000000000000000";
		end if;
	end process;
	IR_out <= IR;
	PC_out <= PC;
	PCn_out <= PCn;
end architecture;
	
	