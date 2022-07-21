library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity EX_stage is
	port(EX_EN: in std_logic;
		  LS7_in, SE7, SE10, D1, D2_in, FU_Data, PC_in, PCn_in: in std_logic_vector(15 downto 0);
		  D113_in: in std_logic_vector(8 downto 0);
		  OP_in: in std_logic_vector(3 downto 0);
		  Flags, FU_A_mux, FU_B_mux: in std_logic_vector(1 downto 0);
		  hb: out std_logic;
		  IF_PC_mux: out std_logic_vector(1 downto 0);
		  LS7_out, ALU_out, PCn_out, to_PC, D2_out: out std_logic_vector(15 downto 0);
		  D113_out: out std_logic_vector(8 downto 0);
		  OP_out: out std_logic_vector(3 downto 0));
end entity;

architecture EX_arch of EX_stage is
	signal fc, cf, zf: std_logic;
	signal alu_a, alu_b, alu_o:std_logic_vector(15 downto 0);
	signal sig_mux_b, sig_mux_a, sig_func: std_logic_vector(1 downto 0);
	
	component alu is
		port(flag_change: in std_logic;
			  opr1, opr2: in std_logic_vector(15 downto 0):=(others=>'0');
			  func: in std_logic_vector(1 downto 0):=(others=>'1');
			  cf, zf: out std_logic:=('1');
			  alu_out: out std_logic_vector(15 downto 0):=(others=>'0'));
	end component;
	
begin
	sig_mux_a <= FU_A_mux;
	sig_mux_b <= FU_B_mux;
	
	ALU_EX: ALU
		port map(fc, alu_a, alu_b, sig_func, cf, zf, alu_o);
	
	process(OP_in, EX_EN, Flags, zf, cf)
	begin
		if EX_EN='1' then
			if (OP_in = "0001" or OP_in = "0011") then										-----ADD
				IF_PC_mux <= "00";
				if((Flags="01" and zf='1') or (Flags="10" and cf='1') or (Flags="11" or Flags="00")) then
					sig_func <= "01";
				else
					sig_func <= "11";
				end if;
			elsif (OP_in = "0010") then															-----NAND
				IF_PC_mux <= "00";
				if((Flags="01" and zf='1') or (Flags="10" and cf='1') or (Flags="11" or Flags="00")) then
					sig_func <= "10";
				else
					sig_func <= "11";
				end if;
			elsif (OP_in = "1001") then															-----JAL
				sig_func <= "01";
				IF_PC_mux <= "01";
			elsif (OP_in = "1000") then															-----BEQ
				sig_func <= "01";
				if ((D1 xor D2_in) = "0000000000000000") then
					IF_PC_mux <= "01";
				else
					IF_PC_mux <= "00";
				end if;
			elsif (OP_in = "0111" or OP_in = "0101") then									-----LW, SW
				IF_PC_mux <= "00";
				sig_func <= "01";
			elsif (OP_in = "1011") then															-----JRI
				sig_func <= "01";
				IF_PC_mux <= "01";
			elsif (OP_in = "1010") then															-----JLR
				IF_PC_mux <= "01";
			end if;
		else
			sig_func <= "11";
			IF_PC_mux <= "00";
			null;
		end if;
	end process;
	
	process(EX_EN, sig_mux_a, sig_mux_b, LS7_in, OP_in, D113_in, PCn_in)
	begin
		if EX_EN='1' then
			if (sig_mux_a="00") then
				alu_a <= D1;
			elsif (sig_mux_a="01") then
				alu_a <= PC_in;
			elsif (sig_mux_a="11") then
				alu_a <= FU_Data;
			end if;
			
			if (sig_mux_b="00") then
				alu_b <= D2_in;
			elsif (sig_mux_b="01") then
				alu_b <= SE10;
			elsif (sig_mux_b="10") then
				alu_b <= SE7;
			else
				alu_b <= FU_Data;
			end if;
			to_PC <= alu_o;
			LS7_out <= LS7_in;
			OP_out <= OP_in;
			D113_out <= D113_in;
			PCn_out <= PCn_in;
			ALU_out <= alu_o;
			D2_out <= D2_in;
			hb <= zf;
		else
			null;
		end if;
	end process;
end architecture;