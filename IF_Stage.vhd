library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity IF_Stage is
	port(IF_EN: in std_logic;
		  sig_IF_mux: in std_logic_vector(1 downto 0);
		  PCn_in, PC_EX_in, PC_BP_in: in std_logic_vector(15 downto 0);
		  IR_out,PC_out,PCn_out: out std_logic_vector(15 downto 0));
end entity;

architecture IF_Arch of IF_Stage is

	signal PC: std_logic_vector(15 downto 0):=("0000000000000000");
	
	component instruction_memory is
		generic(mem_a_width	: integer := 16;
				  data_width	: integer := 16);
		port(mem_a: in std_logic_vector(mem_a_width - 1 DOWNTO 0);
			  dout: OUT std_logic_vector(data_width - 1 DOWNTO 0));
	end component;
	
begin
	
	IM: instruction_memory
		port map(mem_a => PC, dout => IR_out);
		
	process(sig_IF_mux,PC,IF_EN)
		variable dummy1, dummy2: std_logic_vector(15 downto 0);
	begin
		if IF_EN='1' then
			dummy1 := std_logic_vector(unsigned(PC) + 1);

			if sig_IF_mux = "00" then
				dummy2 := PCn_in;
			elsif sig_IF_mux = "01" then
				dummy2 := PC_EX_in;
			elsif sig_IF_mux = "10" then
				dummy2 := PC_BP_in;
			else
				null;
			end if;

			PCn_out <= dummy1;
			PC <= dummy2;
			PC_out <= PC;
		else
			null;
		end if;
	end process;
end architecture;
			