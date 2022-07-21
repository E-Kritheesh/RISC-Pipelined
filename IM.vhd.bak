LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity instruction_memory IS
	generic(mem_a_width	: integer := 16;
			  data_width	: integer := 16);
	port(
		  mem_a			: in  std_logic_vector(mem_a_width - 1 DOWNTO 0);
		  dout			: OUT std_logic_vector(data_width - 1 DOWNTO 0));
end instruction_memory;

architecture struct of instruction_memory is
   type memory IS ARRAY(0 TO 1023) OF std_logic_vector(data_width - 1 DOWNTO 0);
	signal memory_block : memory := (others=>(others=>'1'));

begin
    dout <= memory_block(to_integer(unsigned(mem_a(9 downto 0))));			
END struct;