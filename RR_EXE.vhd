library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RR_EXE is
	port(RR_EXE_EN,RST: in std_logic;
		  SE10_in,SE7_in,LS7_in,D1_in,D2_in,PC_in,PCn_in: in std_logic_vector(15 downto 0);
		  OP_in: in std_logic_vector(3 downto 0);
		  flag_in: in std_logic_vector(1 downto 0);
		  D113_in: in std_logic_vector(8 downto 0);
		  SE10_out,SE7_out,LS7_out,D1_out,D2_out,PC_out,PCn_out: out std_logic_vector(15 downto 0);
		  OP_out: out std_logic_vector(3 downto 0);
		  flag_out: out std_logic_vector(1 downto 0);
		  D113_out: out std_logic_vector(8 downto 0));
end entity;

architecture RR_EXE_arch of RR_EXE is
	signal SE10,SE7,LS7,D1,D2,PC,PCn: std_logic_vector(15 downto 0):=("0000000000000000");
	signal OP: std_logic_vector(3 downto 0):=("0000");
	signal flag: std_logic_vector(1 downto 0):=("00");
	signal D113: std_logic_vector(8 downto 0):=("000000000");
begin
	process(RR_EXE_EN,RST,SE10_in,SE7_in,LS7_in,D1_in,D2_in,PC_in,PCn_in,OP_in,flag_in,D113_in)
	begin
		if RST='0' then
			if RR_EXE_EN='1' then 
				SE10 <= SE10_in;
				SE7 <= SE7_in;
				LS7 <= LS7_in;
				D1 <= D1_in;
				D2 <= D2_in;
				PC <= PC_in;
				PCn <= PCn_in;
				OP <= OP_in;
				flag <= flag_in;
				D113 <= D113_in;
			end if;
		else 
			SE10 <= "0000000000000000";
			SE7 <= "0000000000000000";
			LS7 <= "0000000000000000";
			D1 <= "0000000000000000";
			D2 <= "0000000000000000";
			PC <= "0000000000000000";
			PCn <= "0000000000000000";
			OP <= "0000";
			flag <= "00";
			D113 <= "000000000";
		end if;
	end process;
	SE10_out <= SE10;
	SE7_out <= SE7;
	LS7_out <= LS7;
	D1_out <= D1;
	D2_out <= D2;
	PC_out <= PC;
	PCn_out <= PCn;
	OP_out <= OP;
	flag_out <= flag;
	D113_out <= D113;
end architecture;