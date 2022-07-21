library ieee;
use ieee.std_logic_1164.all;
use work.all;
use ieee.numeric_std.all;

entity Branch_Control is
	port(clock, hb: in std_logic;
		  PC_in: in std_logic_vector(15 downto 0);
		  IR50: in std_logic_vector(5 downto 0);
		  mux_out: out std_logic_vector(1 downto 0):="10";
		  addr_out: out std_logic_vector(15 downto 0));
end entity;

architecture branch_control_arch of Branch_Control is
	
	signal SE_10: std_logic_vector(15 downto 0):=(others=>'0');
	signal reset: std_logic;
	type state is (taken, not_taken);
	signal y_present, y_next: state := taken;
	
begin
	
	process(clock, reset, y_next)
	begin
		if (clock'event and clock='1') then
			if reset='1' then
				y_present<=taken;
			else
				y_present<=y_next;
			end if;
		end if;
	end process;
	
	process(y_present, hb)
	begin
		case y_present is
		when taken=>
			if (hb='0') then
				y_next<=not_taken;
				mux_out<="00";
				reset<='1';
			else
				reset<='0';
				mux_out<="10";
				y_next<=y_present;
			end if;
		when not_taken=>
			if (hb='1') then
				y_next<=taken;
				mux_out<="10";
				reset<='1';
			else
				mux_out<="00";
				y_next<=y_present;
				reset<='0';
			end if;
		end case;
	end process;
	
	SE_10(15) <= IR50(5);
	SE_10(14 downto 5) <= (others=>'0');
	SE_10(4 downto 0) <= IR50(4 downto 0);
	process(SE_10)
		variable addr: std_logic_vector(15 downto 0);
	begin
		addr := std_logic_vector(signed(PC_in) + signed(SE_10));
		addr_out <= addr;
	end process;
	
end architecture;