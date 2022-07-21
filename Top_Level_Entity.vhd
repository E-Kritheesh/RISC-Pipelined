library ieee;
use ieee.std_logic_1164.all;
library work;
use work.all;

entity Top_Level_Entity is
	port(clock: in std_logic;
		  Y: out std_logic);
end entity;

architecture TLE_arch of Top_Level_Entity is
----------------------------------------------------------------------------------------------------
	signal sig_IF_mux: std_logic_vector(1 downto 0);
	signal if_PCn_in, if_PC_EX_in, if_PC_BP_in, if_IR_out, if_PC_out, if_PCn_out: std_logic_vector(15 downto 0):=(others=>'0');
	
	component IF_stage is
		port(IF_EN: in std_logic;
			  sig_IF_mux: in std_logic_vector(1 downto 0);
			  PCn_in, PC_EX_in, PC_BP_in: in std_logic_vector(15 downto 0);
			  IR_out,PC_out,PCn_out: out std_logic_vector(15 downto 0));
	end component;
----------------------------------------------------------------------------------------------------
	signal IF_ID_EN,ifid_RST: std_logic;
	signal ifid_IR_in, ifid_PC_in, ifid_PCn_in: std_logic_vector(15 downto 0);
	signal ifid_IR_out, ifid_PC_out, ifid_PCn_out: std_logic_vector(15 downto 0);
	
	component IF_ID is
		port(IF_ID_EN,RST: in std_logic;
			  IR_in, PC_in,PCn_in: in std_logic_vector(15 downto 0);
			  IR_out,PC_out,PCn_out: out std_logic_vector(15 downto 0));
	end component;
----------------------------------------------------------------------------------------------------
	signal ID_EN: std_logic;
	signal id_IR, id_PC_in, id_PCn_in, id_LS7, id_SE7, id_SE10, id_PC_out, id_PCn_out: std_logic_vector(15 downto 0);
	signal id_D70: std_logic_vector(7 downto 0);
	signal id_D86, id_D119: std_logic_vector(2 downto 0);
	signal id_OP: std_logic_vector(3 downto 0);
	
	component ID_stage is
		port(ID_EN: in std_logic;
			  IR, PC_in, PCn_in: in std_logic_vector(15 downto 0);
			  LS7, SE7, SE10, PC_out, PCn_out: out std_logic_vector(15 downto 0);
			  D70: out std_logic_vector(7 downto 0);
			  D86, D119: out std_logic_vector(2 downto 0);
			  OP: out std_logic_vector(3 downto 0));
	end component;
----------------------------------------------------------------------------------------------------
	signal ID_RR_EN, idrr_RST: std_logic;
	signal idrr_PC_in, idrr_SE10_in, idrr_SE7_in, idrr_LS7_in, idrr_PCn_in: std_logic_vector(15 downto 0);
	signal idrr_PC_out, idrr_SE10_out, idrr_SE7_out, idrr_LS7_out, idrr_PCn_out: std_logic_vector(15 downto 0);
	signal idrr_OP_in, idrr_OP_out: std_logic_vector(3 downto 0);
	signal idrr_D119_in, idrr_D86_in, idrr_D119_out, idrr_D86_out: std_logic_vector(2 downto 0);
	signal idrr_D70_in, idrr_D70_out: std_logic_vector(7 downto 0);
	       
	component ID_RR is
		port(ID_RR_EN,RST: in std_logic;
			  PC_in,SE10_in,SE7_in,LS7_in,PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  D119_in,D86_in: in std_logic_vector(2 downto 0);
			  D70_in: in std_logic_vector(7 downto 0);
			  PC_out,SE10_out,SE7_out,LS7_out,PCn_out: out std_logic_vector(15 downto 0);
			  OP_out: out std_logic_vector(3 downto 0);
			  D119_out,D86_out: out std_logic_vector(2 downto 0);
			  D70_out: out std_logic_vector(7 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal RR_EN, rr_CLK: std_logic;
	signal rr_LS7_in, rr_SE7_in, rr_SE10_in, rr_PC_in, rr_PCn_in, rr_D3: std_logic_vector(15 downto 0);
	signal rr_LS7_out, rr_SE7_out, rr_SE10_out, rr_PC_out, rr_PCn_out, rr_D1, rr_D2: std_logic_vector(15 downto 0);
	signal rr_D70: std_logic_vector(7 downto 0);
	signal rr_D86, rr_D119: std_logic_vector(2 downto 0);
	signal rr_OP_in, rr_LM_SM_in,	rr_OP_out: std_logic_vector(3 downto 0);
	signal rr_A3_in: std_logic_vector(11 downto 0);
	signal rr_Flags: std_logic_vector(1 downto 0);
	signal rr_D113: std_logic_vector(8 downto 0);
	
	component RR_stage is
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
	end component;
------------------------------------------------------------------------------------------------------
	signal RR_EXE_EN, rrexe_RST: std_logic;
	signal rrexe_SE10_in, rrexe_SE7_in, rrexe_LS7_in, rrexe_D1_in, rrexe_D2_in, rrexe_PC_in, rrexe_PCn_in: std_logic_vector(15 downto 0);
   signal rrexe_SE10_out, rrexe_SE7_out, rrexe_LS7_out, rrexe_D1_out, rrexe_D2_out, rrexe_PC_out, rrexe_PCn_out: std_logic_vector(15 downto 0);
	signal rrexe_OP_in, rrexe_OP_out: std_logic_vector(3 downto 0);
	signal rrexe_flags_in, rrexe_flags_out: std_logic_vector(1 downto 0);
	signal rrexe_D113_in, rrexe_D113_out: std_logic_vector(8 downto 0);
	
	component RR_EXE is
		port(RR_EXE_EN,RST: in std_logic;
			  SE10_in,SE7_in,LS7_in,D1_in,D2_in,PC_in,PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  flag_in: in std_logic_vector(1 downto 0);
			  D113_in: in std_logic_vector(8 downto 0);
			  SE10_out,SE7_out,LS7_out,D1_out,D2_out,PC_out,PCn_out: out std_logic_vector(15 downto 0);
			  OP_out: out std_logic_vector(3 downto 0);
			  flag_out: out std_logic_vector(1 downto 0);
			  D113_out: out std_logic_vector(8 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal EX_EN, ex_hb: std_logic;
	signal ex_LS7_in, ex_SE7, ex_SE10, ex_D1, ex_D2_in, ex_FU_Data, ex_PC_in, ex_PCn_in: std_logic_vector(15 downto 0);
	signal ex_LS7_out, ex_ALU_out, ex_PCn_out, ex_to_PC, ex_D2_out: std_logic_vector(15 downto 0);
	signal ex_D113_in, ex_D113_out: std_logic_vector(8 downto 0);
	signal ex_OP_in, ex_OP_out: std_logic_vector(3 downto 0);
	signal ex_Flags, ex_FU_A_mux, ex_FU_B_mux, ex_IF_PC_mux: std_logic_vector(1 downto 0);
	
	component EX_stage is
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
	end component;
------------------------------------------------------------------------------------------------------
	signal EXE_MEM_EN, exemem_RST: std_logic;
	signal exemem_LS7_in, exemem_ALUout_in, exemem_D2_in, exemem_PCn_in: std_logic_vector(15 downto 0);
	signal exemem_LS7_out, exemem_ALUout_out, exemem_D2_out, exemem_PCn_out: std_logic_vector(15 downto 0);
	signal exemem_OP_in, exemem_OP_out: std_logic_vector(3 downto 0);
	signal exemem_D113_in, exemem_D113_out: std_logic_vector(8 downto 0);

	component EXE_MEM is
		port(EXE_MEM_EN,RST: in std_logic;
			  LS7_in,ALUout_in,D2_in,PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  D113_in: in std_logic_vector(8 downto 0);
			  LS7_out,ALUout_out,D2_out,PCn_out: out std_logic_vector(15 downto 0);
			  OP_out: out std_logic_vector(3 downto 0);
			  D113_out: out std_logic_vector(8 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal MEM_EN,mem_clk: std_logic;
	signal mem_LS7_in, mem_ALUout_in, mem_D2_in, mem_PCn_in, mem_LS7_out, mem_ALUout_out, mem_DR_out, mem_PCn_out: std_logic_vector(15 downto 0);
	signal mem_OP_in,	mem_OP_out: std_logic_vector(3 downto 0);
	signal mem_D113_in, mem_D113_out: std_logic_vector(8 downto 0);

	component MEM_Stage is
		port(MEM_EN,clk: in std_logic;
			  LS7_in,ALUout_in,D2_in, PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  D113_in: in std_logic_vector(8 downto 0);
			  LS7_out,ALUout_out,DR_out, PCn_out: out std_logic_vector(15 downto 0);
			  OP_out: out std_logic_vector(3 downto 0);
			  D113_out: out std_logic_vector(8 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal MEM_WB_EN, memwb_RST: std_logic;
	signal memwb_LS7_in, memwb_ALUout_in, memwb_DR_in, memwb_PCn_in: std_logic_vector(15 downto 0);
	signal memwb_LS7_out, memwb_ALUout_out, memwb_DR_out, memwb_PCn_out: std_logic_vector(15 downto 0);
	signal memwb_OP_in, memwb_OP_out: std_logic_vector(3 downto 0);
	signal memwb_D113_in, memwb_D113_out: std_logic_vector(8 downto 0);

	component MEM_WB is
		port(MEM_WB_EN,RST: in std_logic;
			  LS7_in,ALUout_in,DR_in,PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  D113_in: in std_logic_vector(8 downto 0);
			  LS7_out,ALUout_out,DR_out,PCn_out: out std_logic_vector(15 downto 0);
			  OP_out: out std_logic_vector(3 downto 0);
			  D113_out: out std_logic_vector(8 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal WB_EN: std_logic;
	signal wb_LS7_in, wb_ALUout_in, wb_DR_in, wb_PCn_in, wb_D3_out: std_logic_vector(15 downto 0);
	signal wb_OP_in: std_logic_vector(3 downto 0);
	signal wb_D113_in: std_logic_vector(8 downto 0);
	signal wb_A3_out: std_logic_vector(11 downto 0);

	component WB_Stage is
		port(WB_EN: in std_logic;
			  LS7_in,ALUout_in,DR_in,PCn_in: in std_logic_vector(15 downto 0);
			  OP_in: in std_logic_vector(3 downto 0);
			  D113_in: in std_logic_vector(8 downto 0);
			  D3_out: out std_logic_vector(15 downto 0);
			  A3_out: out std_logic_vector(11 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal bc_mux: std_logic_vector(1 downto 0);
	
	component Branch_Control is
		port(clock, hb: in std_logic;
			  PC_in: in std_logic_vector(15 downto 0);
			  IR50: in std_logic_vector(5 downto 0);
			  mux_out: out std_logic_vector(1 downto 0):="10";
			  addr_out: out std_logic_vector(15 downto 0));
	end component;
------------------------------------------------------------------------------------------------------
	signal fu_IR, fu_EXEMEM_out, fu_MEMWB_out: std_logic_vector(15 downto 0);
	signal fu_IF_EN, fu_ID_EN, fu_RR_EN: std_logic;
	
	
	component forwarding_unit is
		port(clock: in std_logic;
			  IR: in std_logic_vector(15 downto 0);
			  EXEMEM_out: in std_logic_vector(15 downto 0);
			  MEMWB_out: in std_logic_vector(15 downto 0);
			  IF_EN, ID_EN, RR_EN: out std_logic;
			  selA: out std_logic_vector(1 downto 0):="00";
			  selB: out std_logic_vector(1 downto 0):="00";
			  FU_out: out std_logic_vector(15 downto 0));
	end component;

begin
	
	Y<='0';
	
	IFstage:IF_stage
		port map(fu_IF_EN, sig_IF_mux, if_PCn_in, if_PC_EX_in, if_PC_BP_in, if_IR_out, if_PC_out, if_PCn_out);
	
	IFID: IF_ID
		port map(IF_ID_EN, ifid_RST, ifid_IR_in, ifid_PC_in, ifid_PCn_in, ifid_IR_out, ifid_PC_out, ifid_PCn_out);
	
	IDstage: ID_stage
		port map(fu_ID_EN, id_IR, id_PC_in, id_PCn_in, id_LS7, id_SE7, id_SE10, id_PC_out, id_PCn_out, id_D70, id_D86, id_D119, id_OP);
	
	IDRR: ID_RR
		port map(ID_RR_EN, idrr_RST, idrr_PC_in, idrr_SE10_in, idrr_SE7_in, idrr_LS7_in, idrr_PCn_in, idrr_OP_in, idrr_D119_in, idrr_D86_in,
					idrr_D70_in, idrr_PC_out, idrr_SE10_out, idrr_SE7_out, idrr_LS7_out, idrr_PCn_out, idrr_OP_out, idrr_D119_out, idrr_D86_out,
					idrr_D70_out);
	
	RRstage: RR_stage
		port map(fu_RR_EN, rr_CLK, rr_LS7_in, rr_SE7_in, rr_SE10_in, rr_PC_in, rr_PCn_in, rr_D3, rr_D70, rr_D86, rr_D119, rr_OP_in, rr_LM_SM_in, 
					rr_A3_in, rr_LS7_out, rr_SE7_out, rr_SE10_out, rr_PC_out, rr_PCn_out, rr_D1, rr_D2, rr_Flags, rr_OP_out, rr_D113);
	
	RREXE: RR_EXE
		port map(RR_EXE_EN, rrexe_RST, rrexe_SE10_in, rrexe_SE7_in, rrexe_LS7_in, rrexe_D1_in, rrexe_D2_in, rrexe_PC_in, rrexe_PCn_in, rrexe_OP_in,
					rrexe_Flags_in, rrexe_D113_in, rrexe_SE10_out, rrexe_SE7_out, rrexe_LS7_out, rrexe_D1_out, rrexe_D2_out, rrexe_PC_out,
					rrexe_PCn_out, rrexe_OP_out, rrexe_Flags_out, rrexe_D113_out);
	
	EXstage:EX_stage
		port map('1', ex_LS7_in, ex_SE7, ex_SE10, ex_D1, ex_D2_in, ex_FU_Data, ex_PC_in, ex_PCn_in, ex_D113_in, ex_OP_in, ex_Flags, ex_FU_A_mux,
					ex_FU_B_mux, ex_hb, ex_IF_PC_mux, ex_LS7_out, ex_ALU_out, ex_PCn_out, ex_to_PC, ex_D2_out, ex_D113_out, ex_OP_out);
	
	EXEMEM:EXE_MEM
		port map(EXE_MEM_EN, exemem_RST, exemem_LS7_in, exemem_ALUout_in, exemem_D2_in, exemem_PCn_in, exemem_OP_in, exemem_D113_in, 
					exemem_LS7_out, exemem_ALUout_out, exemem_D2_out, exemem_PCn_out, exemem_OP_out, exemem_D113_out);
	
	MEMstage:MEM_stage
		port map('1',mem_clk, mem_LS7_in, mem_ALUout_in, mem_D2_in, mem_PCn_in, mem_OP_in, mem_D113_in, mem_LS7_out,
					mem_ALUout_out, mem_DR_out, mem_PCn_out, mem_OP_out, mem_D113_out);
	
	MEMWB: MEM_WB
		port map(MEM_WB_EN, memwb_RST, memwb_LS7_in, memwb_ALUout_in, memwb_DR_in, memwb_PCn_in, memwb_OP_in, memwb_D113_in,
					memwb_LS7_out, memwb_ALUout_out, memwb_DR_out, memwb_PCn_out, memwb_OP_out, memwb_D113_out);
	
	WBstage:WB_Stage
		port map('1', wb_LS7_in, wb_ALUout_in, wb_DR_in, wb_PCn_in, wb_OP_in, wb_D113_in, wb_D3_out, wb_A3_out);
		
	Branch_Pred:Branch_Control
		port map(clock, ex_hb, if_PC_out, if_IR_out(5 downto 0), bc_mux, if_PC_BP_in);
	
	FU:forwarding_unit
		port map(clock, fu_IR, fu_EXEMEM_out, fu_MEMWB_out, fu_IF_EN, fu_ID_EN, fu_RR_EN, ex_FU_A_mux, ex_FU_B_mux, ex_FU_Data);
	
	process(ifid_IR_out)
	begin
		if ifid_IR_out(15 downto 12)="1000" then
			sig_IF_mux<=bc_mux;
		else
			sig_IF_mux<=ex_IF_PC_mux;
		end if;
	end process;
	
--------------------------------------------IF-----------------------------------------------
	if_PC_EX_in<=ex_to_PC;
	if_PCn_in<=ifid_PCn_out;
--------------------------------------------ID-----------------------------------------------
	id_IR <= ifid_IR_out;
	id_PC_in <= ifid_PC_out;
	id_PCn_in <= ifid_PCn_out;
--------------------------------------------RR-----------------------------------------------
	rr_CLK <= clock;
	rr_LS7_in <= idrr_LS7_out;
	rr_SE7_in <= idrr_SE7_out;
	rr_SE10_in <= idrr_SE10_out;
	rr_PC_in <= idrr_PC_out;
	rr_PCn_in <= idrr_PCn_out;
	rr_D70 <= idrr_D70_out;
	rr_D86 <= idrr_D86_out;
	rr_D119 <= idrr_D119_out;
	rr_OP_in <= idrr_OP_out;
--------------------------------------------EX-----------------------------------------------
	ex_LS7_in <= rrexe_LS7_out;
	ex_SE7 <= rrexe_SE7_out;
	ex_SE10 <= rrexe_SE10_out;
	ex_D1 <= rrexe_D1_out;
	ex_D2_in <= rrexe_D2_out;
	ex_PC_in <= rrexe_PC_in;
	ex_PCn_in <= rrexe_PCn_out;
	ex_D113_in <= rrexe_D113_out;
	ex_Flags <= rrexe_Flags_out;
--------------------------------------------MEM-----------------------------------------------
	mem_clk <= clock;
	mem_LS7_in <= exemem_LS7_out;
	mem_ALUout_in <= exemem_ALUout_out;
	mem_D2_in <= exemem_D2_out;
	mem_PCn_in <= exemem_PCn_out;
	mem_OP_in <= exemem_OP_out;
	mem_D113_in <= exemem_D113_out;
--------------------------------------------WB-----------------------------------------------
	wb_LS7_in <= memwb_LS7_out;
	wb_ALUout_in <= memwb_ALUout_out;
	wb_DR_in <= memwb_DR_out;
	wb_PCn_in <= memwb_PCn_out;
	wb_OP_in <= memwb_OP_out;
	wb_D113_in <= memwb_D113_out;
--------------------------------------------FU-----------------------------------------------
	fu_IR(15 downto 12) <= idrr_OP_out;
	fu_IR(11 downto 9) <= idrr_D119_out;
	fu_IR(8 downto 6) <= idrr_D86_out;
	fu_IR(5 downto 0) <= idrr_D70_out(5 downto 0);
	fu_EXEMEM_out <= exemem_ALUout_out;
	fu_MEMWB_out <= memwb_DR_out;
	
	
	process(clock)
	begin
		if (clock'event and clock='1') then
			if IF_ID_EN='1' then
				ifid_IR_in <= if_IR_out;
				ifid_PC_in <= if_PC_out;
				ifid_PCn_in <= if_PCn_out;
			else
				null;
			end if;
			
			if ID_RR_EN='1' then
				idrr_LS7_in <= id_LS7;
				idrr_SE10_in <= id_SE10;
				idrr_SE7_in <= id_SE7;
				idrr_D119_in <= id_D119;
				idrr_D86_in <= id_D86;
				idrr_D70_in <= id_D70;
				idrr_OP_in <= id_OP;
				idrr_PC_in <= id_PC_out;
				idrr_PCn_in <= id_PCn_out;
			else
				null;
			end if;
			
			if RR_EXE_EN='1' then
				rrexe_LS7_in <= rr_LS7_out;
				rrexe_SE10_in <= rr_SE10_out;
				rrexe_SE7_in <= rr_SE7_out;
				rrexe_D1_in <= rr_D1;
				rrexe_D2_in <= rr_D2;
				rrexe_PC_in <= rr_PC_out;
				rrexe_OP_in <= rr_OP_out;
				rrexe_Flags_in <= rr_Flags;
				rrexe_D113_in <= rr_D113;
				rrexe_PCn_in <= rr_PCn_out;
			else
				null;
			end if;
			
			if EXE_MEM_EN='1' then
				exemem_LS7_in <= ex_LS7_out;
				exemem_ALUout_in <= ex_ALU_out;
				exemem_D2_in <= ex_D2_out;
				exemem_PCn_in <= ex_PCn_out;
				exemem_OP_in <= ex_OP_out;
				exemem_D113_in <= ex_D113_out;
			else
				null;
			end if;
			
			if MEM_WB_EN='1' then
				memwb_LS7_in <= mem_LS7_out;
				memwb_ALUout_in <= mem_ALUout_out;
				memwb_DR_in <= mem_DR_out;
				memwb_PCn_in <= mem_PCn_out;
				memwb_OP_in <= mem_OP_out;
				memwb_D113_in <= mem_D113_out;
			else
				null;
			end if;
			
			rr_D3 <= wb_D3_out;
			rr_A3_in <= wb_A3_out;
		else
			null;
		end if;	
	end process;
end architecture;