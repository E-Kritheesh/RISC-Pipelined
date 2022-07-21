library ieee;
use ieee.std_logic_1164.all;
use work.all;
use ieee.numeric_std.all;

entity forwarding_unit is
	port(clock: in std_logic;
		  IR: in std_logic_vector(15 downto 0);
		  EXEMEM_out: in std_logic_vector(15 downto 0);
		  MEMWB_out: in std_logic_vector(15 downto 0);
		  IF_EN, ID_EN, RR_EN: out std_logic;
		  selA: out std_logic_vector(1 downto 0):="00";
		  selB: out std_logic_vector(1 downto 0):="00";
		  FU_out: out std_logic_vector(15 downto 0));
end entity;

architecture forwarding_unit_arch of forwarding_unit is
	
	signal ir1: std_logic_vector(15 downto 0) := (others=>'0');
	signal ir2: std_logic_vector(15 downto 0) := (others=>'0');
	signal ir3: std_logic_vector(15 downto 0) := (others=>'0');
	
begin
   process(clock,IR)
	begin
		if rising_edge(clock) then
			ir1<=ir2;
			ir2<=ir3;
			ir3<=IR;
		end if;
	end process;
	
	process(ir3, ir2, ir3, EXEMEM_out, MEMWB_out)
	begin
	  if (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir2(15 downto 12)="0010" or ir2(15 downto 12)="0001" or ir2(15 downto 12)="1000" or ir2(15 downto 12)="0101") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(5 downto 3)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(5 downto 3)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir2(15 downto 12)="1011" or ir2(15 downto 12)="1101" or ir2(15 downto 12)="1100" or ir2(15 downto 12)="0000") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(5 downto 3)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir2(15 downto 12)="0111") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(5 downto 3)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir2(15 downto 12)="1010") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(5 downto 3)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;	  
	  elsif (ir1(15 downto 12)="0000") and (ir2(15 downto 12)="0010" or ir2(15 downto 12)="0001" or ir2(15 downto 12)="1000" or ir2(15 downto 12)="0101") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(8 downto 6)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(8 downto 6)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir2(15 downto 12)="1011" or ir2(15 downto 12)="1101" or ir2(15 downto 12)="1100" or ir2(15 downto 12)="0000") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(8 downto 6)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir2(15 downto 12)="0111") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(8 downto 6)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir2(15 downto 12)="1010") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(8 downto 6)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir2(15 downto 12)="0010" or ir2(15 downto 12)="0001" or ir2(15 downto 12)="1000" or ir2(15 downto 12)="0101") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(11 downto 9)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(11 downto 9)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir2(15 downto 12)="1011" or ir2(15 downto 12)="1101" or ir2(15 downto 12)="1100" or ir2(15 downto 12)="0000") then
	     IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(11 downto 9)=ir2(11 downto 9) then
		    FU_out<=EXEMEM_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir2(15 downto 12)="0111") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(11 downto 9)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir2(15 downto 12)="1010") then
        IF_EN <= '1';
		  ID_EN <= '1';
		  RR_EN <= '1';
		  if ir1(11 downto 9)=ir2(8 downto 6) then
		    FU_out<=EXEMEM_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir2(15 downto 12)="0010" or ir2(15 downto 12)="0001" or ir2(15 downto 12)="1000" or ir2(15 downto 12)="0101") then
	     if ir1(11 downto 9)=ir2(11 downto 9) then
		    IF_EN<='0';
			 ID_EN<='0';
			 RR_EN<='0';
--			 wait until (clock'event and clock='1');
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(11 downto 9)=ir2(8 downto 6) then
		    IF_EN<='0';
			 ID_EN<='0';
			 RR_EN<='0';
--			 wait until (clock'event and clock='1');
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 IF_EN <= '1';
		    ID_EN <= '1';
			 RR_EN <= '1';
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir2(15 downto 12)="1011" or ir2(15 downto 12)="1101" or ir2(15 downto 12)="1100" or ir2(15 downto 12)="0000") then
	     if ir1(11 downto 9)=ir2(11 downto 9) then
		    IF_EN<='0';
			 ID_EN<='0';
			 RR_EN<='0';
--			 wait until (clock'event and clock='1');
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
        else
			 IF_EN <= '1';
          ID_EN <= '1';
			 RR_EN <= '1';
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir2(15 downto 12)="0111") then
        if ir1(11 downto 9)=ir2(8 downto 6) then
		    IF_EN<='0';
			 ID_EN<='0';
			 RR_EN<='0';
--			 wait until (clock'event and clock='1');
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 IF_EN <= '1';
		    ID_EN <= '1';
		    RR_EN <= '1';
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir2(15 downto 12)="1010") then
        if ir1(11 downto 9)=ir2(8 downto 6) then
		    IF_EN<='0';
			 ID_EN<='0';
			 RR_EN<='0';
--			 wait until (clock'event and clock='1');
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 IF_EN <= '1';
		    ID_EN <= '1';
		    RR_EN <= '1';
			 selA <= "01";
			 selB <= "01";
        end if;
	  else
		    IF_EN <= '1';
		    ID_EN <= '1';
		    RR_EN <= '1';
			 selA <= "01";
			 selB <= "00";
	  end if;
		  
	  if (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir3(15 downto 12)="0010" or ir3(15 downto 12)="0001" or ir3(15 downto 12)="1000" or ir3(15 downto 12)="0101") then
	     if ir1(5 downto 3)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(5 downto 3)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir3(15 downto 12)="1011" or ir3(15 downto 12)="1101" or ir3(15 downto 12)="1100" or ir3(15 downto 12)="0000") then
	     if ir1(5 downto 3)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir3(15 downto 12)="0111") then
        if ir1(5 downto 3)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0001" or ir1(15 downto 12)="0010") and (ir3(15 downto 12)="1010") then
        if ir1(5 downto 3)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;	  
	  elsif (ir1(15 downto 12)="0000") and (ir3(15 downto 12)="0010" or ir3(15 downto 12)="0001" or ir3(15 downto 12)="1000" or ir3(15 downto 12)="0101") then
	     if ir1(8 downto 6)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(8 downto 6)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir3(15 downto 12)="1011" or ir3(15 downto 12)="1101" or ir3(15 downto 12)="1100" or ir3(15 downto 12)="0000") then
	     if ir1(8 downto 6)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir3(15 downto 12)="0111") then
        if ir1(8 downto 6)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0000") and (ir3(15 downto 12)="1010") then
        if ir1(8 downto 6)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir3(15 downto 12)="0010" or ir3(15 downto 12)="0001" or ir3(15 downto 12)="1000" or ir3(15 downto 12)="0101") then
	     if ir1(11 downto 9)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir3(15 downto 12)="1011" or ir3(15 downto 12)="1101" or ir3(15 downto 12)="1100" or ir3(15 downto 12)="0000") then
	     if ir1(11 downto 9)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir3(15 downto 12)="0111") then
        if ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="1010" or ir1(15 downto 12)="0100" or ir1(15 downto 12)="1001") and (ir3(15 downto 12)="1010") then
        if ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir3(15 downto 12)="0010" or ir3(15 downto 12)="0001" or ir3(15 downto 12)="1000" or ir3(15 downto 12)="0101") then
	     if ir1(11 downto 9)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
		  elsif ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir3(15 downto 12)="1011" or ir3(15 downto 12)="1101" or ir3(15 downto 12)="1100" or ir3(15 downto 12)="0000") then
	     if ir1(11 downto 9)=ir3(11 downto 9) then
		    FU_out<=MEMWB_out;
			 selA <= "11";
			 selB <= "00";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir3(15 downto 12)="0111") then
        if ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "00";
			 selB <= "00";
        end if;
	  elsif (ir1(15 downto 12)="0111") and (ir3(15 downto 12)="1010") then
        if ir1(11 downto 9)=ir3(8 downto 6) then
		    FU_out<=MEMWB_out;
			 selA <= "00";
			 selB <= "11";
        else
			 selA <= "01";
			 selB <= "01";
        end if;
	  else
		    selA <= "01";
			 selB <= "00";
	  end if;
	end process;
end architecture;