library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity RR_stage is
	port(RR_EN, CLK: in std_logic;
		  LS7_in, SE7_in, SE10_in, PC_in, PCn_in, D3: in std_logic_vector(15 downto 0);
		  D70: in std_logic_vector(7 downto 0);
		  D86, D119: in std_logic_vector(2 downto 0);
		  OP_in, LM_SM_in: in std_logic_vector(3 downto 0);
		  A3_in: in std_logic_vector(11 downto 0);
		  LS7_out, SE7_out, SE10_out, PC_out, PCn_out, D1, D2: out std_logic_vector(15 downto 0);
		  Flags: out std_logic_vector(1 downto 0);
		  OP_out: out std_logic_vector(3 downto 0);
		  D113: out std_logic_vector(8 downto 0));
end entity;

architecture RR_arch of RR_stage is
	signal sig_RF_wr, sig_A1: std_logic;
	signal sig_A2, sig_A3: std_logic_vector(1 downto 0);
	signal sig_RF_A1, sig_RF_A2, sig_RF_A3: std_logic_vector(2 downto 0);
	signal A3: std_logic_vector(13 downto 0);
	
	component RF is
		port(CLK: in std_logic; RF_A1, RF_A2, RF_A3: in std_logic_vector(2 downto 0);
			  RF_D3: in std_logic_vector(15 downto 0); EN: in std_logic;
			  RF_D1, RF_D2: out std_logic_vector(15 downto 0));
	end component;
begin
	A3(2 downto 0) <= LM_SM_in(2 downto 0);
	A3(13 downto 3) <= A3_in(10 downto 0);
	
	RegFile: RF
		port map(CLK, sig_RF_A1, sig_RF_A2, sig_RF_A3, D3, sig_RF_wr, D1, D2);
	process(OP_in, A3)
	begin
		sig_A3 <= A3(13 downto 12);
		
		if (OP_in="0001" or OP_in="0010" or OP_in="0011" or OP_in="1011" or OP_in="1100" or OP_in="1101" or OP_in="1000") then
			sig_A1 <= '0';
		elsif (OP_in="0111" or OP_in="0101" or OP_in="1100" or OP_in="1101") then
			sig_A1 <= '1';
		end if;
		
		if (OP_in="0101") then
			sig_A2 <= "00";
			sig_RF_wr <= A3_in(11);
		elsif (OP_in="0001" or OP_in="0010" or OP_in="1010" or OP_in="1000") then
			sig_A2 <= "01";
			sig_RF_wr <= A3_in(11);
		elsif (OP_in="1100" or OP_in="1101") then
			sig_A2 <= "10";
			sig_RF_wr <= LM_SM_in(3);
		else
			sig_RF_wr <= A3_in(11);
		end if;
	end process;
	
	process(RR_EN, sig_A1, sig_A2, sig_A3, LS7_in, SE7_in, SE10_in, PC_in, PCn_in, D70, D86, D119, A3, D3)
	begin
		if RR_EN='1' then
			if sig_A1 = '0' then
				sig_RF_A1 <= D119;
			else
				sig_RF_A1 <= D86;
			end if;
			if sig_A2 = "00" then
				sig_RF_A2 <= D119;
			elsif sig_A2 = "01" then
				sig_RF_A2 <= D86;
			elsif sig_A2 = "10" then
				sig_RF_A2 <= LM_SM_in(2 downto 0);
			end if;
			if sig_A3 = "00" then
				sig_RF_A3 <= A3(11 downto 9);
			elsif sig_A3 = "01" then
				sig_RF_A3 <= A3(8 downto 6);
			elsif sig_A3 = "10" then
				sig_RF_A3 <= A3(5 downto 3);
			else
				sig_RF_A3 <= A3(2 downto 0);
			end if;
			LS7_out <= LS7_in;
			SE7_out <= SE7_in;
			SE10_out <= SE10_in;
			OP_out <= OP_in;
			Flags <= D70(1 downto 0);
			D113(8 downto 6) <= D119;
			D113(5 downto 3) <= D86;
			D113(2 downto 0) <= D70(5 downto 3);
			PC_out <= PC_in;
			PCn_out <= PCn_in;
		else
			null;
		end if;
	end process;
end architecture;