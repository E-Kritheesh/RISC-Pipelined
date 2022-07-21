library ieee;
use ieee.std_logic_1164.all;

entity ID_stage is
	port(ID_EN: in std_logic;
		  IR, PC_in, PCn_in: in std_logic_vector(15 downto 0);
		  LS7, SE7, SE10, PC_out, PCn_out: out std_logic_vector(15 downto 0);
		  D70: out std_logic_vector(7 downto 0);
		  D86, D119: out std_logic_vector(2 downto 0);
		  OP: out std_logic_vector(3 downto 0));
end entity;

architecture ID_arch of ID_stage is
begin
	process(IR, PC_in, PCn_in, ID_EN)
	begin
		if ID_EN='1' then
			LS7(15 downto 7) <= IR(8 downto 0);
			LS7(6 downto 0) <= "0000000";
			SE7(15) <= IR(8);
			SE7(14 downto 8) <= "0000000";
			SE7(7 downto 0) <= IR(7 downto 0);
			SE10(15) <= IR(5);
			SE10(14 downto 5) <= "0000000000";
			SE10(4 downto 0) <= IR(4 downto 0);
			PCn_out <= PCn_in;
			D70 <= IR(7 downto 0);
			D86 <= IR(8 downto 6);
			D119 <= IR(11 downto 9);
			OP <= IR(15 downto 12);
			PC_out <= PC_in;
		else
			null;
		end if;
	end process;
end architecture;