library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity MEM_Stage is
	port(MEM_EN,clk: in std_logic;
		  LS7_in,ALUout_in,D2_in, PCn_in: in std_logic_vector(15 downto 0);
		  OP_in: in std_logic_vector(3 downto 0);
		  D113_in: in std_logic_vector(8 downto 0);
		  LS7_out,ALUout_out,DR_out, PCn_out: out std_logic_vector(15 downto 0);
		  OP_out: out std_logic_vector(3 downto 0);
		  D113_out: out std_logic_vector(8 downto 0));
end entity;

architecture MEM_Stage_Arch of MEM_Stage is

	signal WR_EN: std_logic;

	component data_memory is
		generic(mem_a_width	: integer := 16;
				  data_width	: integer := 16);
		port(clock			: in  std_logic;
			  din				: in  std_logic_vector(data_width - 1 DOWNTO 0);
			  mem_a			: in  std_logic_vector(mem_a_width - 1 DOWNTO 0);
			  wr_en			: in  std_logic;
			  dout			: OUT std_logic_vector(data_width - 1 DOWNTO 0));
	end component;
begin
	
	DM: data_memory port map(clock => clk, din => D2_in, mem_a => ALUout_in, wr_en => WR_EN, dout => DR_out );
	process(MEM_EN,LS7_in,ALUout_in,D2_in,OP_in,D113_in)
	begin 
		if (OP_in = "0101" or OP_in = "1101") then
			WR_EN <= '1';
		else
			WR_EN <= '0';
		end if;
		
		if MEM_EN = '1' then
			LS7_out <= LS7_in;
			ALUout_out <= ALUout_in;
			D113_out <= D113_in;
			OP_out <= OP_in;
			PCn_out <= PCn_in;
		else
			null;
		end if;
	end process;
end architecture;
			