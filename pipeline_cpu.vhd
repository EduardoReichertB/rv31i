library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_cpu is
port(
	i_Clock : in std_logic;
	i_Reset : in std_logic
);
end entity;

architecture pipeline_arch of pipeline_cpu is

--sinais ETAPA if
signal w_addr_mais4_if : std_logic_vector(31 downto 0);
signal w_instrucao_if : std_logic_vector(31 downto 0);

--sinais BARRAMENTO if-id
signal w_addr_mais4_IF_ID : std_logic_vector(31 downto 0);
signal w_instrucao_IF_ID : std_logic_vector(31 downto 0);

--sinais ETAPA id
signal w_RD1_id : std_logic_vector(31 downto 0);
signal w_RD2_id : std_logic_vector(31 downto 0);
signal w_imediato_id : std_logic_vector(31 downto 0);
signal w_opcode_id : std_logic_vector(5 downto 0);
signal w_Reg_Destino_id : std_logic_vector(4 downto 0);
signal w_funcao_ula : std_logic_vector(3 downto 0);

--sinais BARRAMENTO id-ex


--sinais ETAPA ex


--sinais BARRAMENTO ex-mem



--sinais ETAPA mem
signal w_Desvio_mem : std_logic;
signal w_addr_mais4_mais_immed_mem : std_logic_vector(31 downto 0);

--sinais BARRAMENTO mem-wb


--sinais ETAPA wb
signal w_Reg_Destino_wb : std_logic_vector(4 downto 0);
signal w_Data_write_wb : std_logic_vector(31 downto 0);

--sinais CONTROLE
 signal w_JUMP : std_logic;
 signal w_BRANCH : std_logic;
 signal w_MemToReg : std_logic;
 signal w_MemWrite : std_logic;
 signal w_AluSrc : std_logic;
 signal w_RegWrite : std_logic;
 signal w_AluOP : std_logic_vector(1 downto 0);
 signal w_imm_src : std_logic_vector(1 downto 0);

component Instruction_Fetch is
port(
	i_addr_mais4  : in std_logic_vector(31 downto 0); --a saida o_addr_mais4 vai vir como esta entrada
	i_addr_desvio : in std_logic_vector(31 downto 0); 
	i_SEL         : in std_logic;                     --seletor é a saída da verificação de desvio na etapa memory
	i_CLK         : in std_logic;
	i_RST         : in std_logic;
	o_addr_mais4  : out std_logic_vector(31 downto 0); --proxima instrução da rom
	o_instrucao   : out std_logic_vector(31 downto 0)  --instrução atual da rom
);
end component;

component If_Id is
port(
	i_CLK : in std_logic;
	i_RST : in std_logic;
	i_Instrucao_ROM   : in std_logic_vector (31 downto 0);
	i_Program_Counter : in std_logic_vector (31 downto 0);  --igual ao addr_mais4
	o_Program_Counter : out std_logic_vector (31 downto 0); --igual ao addr_mais4
	o_Instrucao_ROM   : out std_logic_vector (31 downto 0)
);
end component;

component Instruction_Decode is
port(
	i_instrucao   : in std_logic_vector(31 downto 0);
	i_Dado_Novo   : in std_logic_vector(31 downto 0);
	i_Reg_Destino : in std_logic_vector(4 downto 0); --vem da saida o_reg_destino
	i_imm_src     : in std_logic_vector(1 downto 0); --do controle
	i_RegWrite    : in std_logic;                    --do controle
	i_CLK         : in std_logic;
	i_RST         : in std_logic;
	o_RD1         : out std_logic_vector(31 downto 0);
	o_RD2         : out std_logic_vector(31 downto 0);
	o_imediato    : out std_logic_vector(31 downto 0);
	o_Reg_Destino : out std_logic_vector(4 downto 0); --eventualmente vira a entrada i_Reg_Destino
	o_opcode      : out std_logic_vector(6 downto 0);
	o_funcao_ula  : out std_logic_vector(3 downto 0) --o funct7 mais o funct3 para o alucontrol
);
end component;

component controlador is
port(
  i_opcode   : in std_logic_vector(6 downto 0);
  o_JUMP     : out std_logic;
  o_BRANCH   : out std_logic;
  o_MemToReg : out std_logic;
  o_MemWrite : out std_logic;
  o_AluSrc   : out std_logic;
  o_RegWrite : out std_logic;
  o_AluOP    : out std_logic_vector(1 downto 0);
  o_imm_src  : out std_logic_vector(1 downto 0)
);
end component;

component Id_Ex is
port(
	i_CLK               : in std_logic;
	i_RST               : in std_logic;
	i_Mem_to_Reg        : in std_logic;
	i_Branch            : in std_logic;
	i_Jump              : in std_logic;
	i_Alu_Src           : in std_logic;
	i_Reg_Write         : in std_logic;
	i_MemWrite          : in std_logic;
	i_AluOP             : in std_logic_vector(1 downto 0);
	i_addr_mais4        : in std_logic_vector(31 downto 0); --para somar com o endereço calculado para casos de branch e jump
	i_RD1               : in std_logic_vector(31 downto 0);
	i_RD2               : in std_logic_vector(31 downto 0);
	i_inteiro_extendido : in std_logic_vector(31 downto 0);
	i_Reg_Dst           : in std_logic_vector(4 downto 0);  --o registrador de destino
	i_funcao_ula        : in std_logic_vector(3 downto 0); --o funct7 mais o funct3 para o alucontrol
	o_Mem_to_Reg        : out std_logic;
	o_Branch            : out std_logic;
	o_Jump              : out std_logic;
	o_Alu_Src           : out std_logic;
	o_Reg_Write         : out std_logic;
	o_MemWrite          : out std_logic;
	o_AluOP             : out std_logic_vector(1 downto 0);
	o_addr_mais4        : out std_logic_vector(31 downto 0); --para somar com o endereço calculado para casos de branch e jump
	o_RD1               : out std_logic_vector(31 downto 0);
	o_RD2               : out std_logic_vector(31 downto 0);
	o_inteiro_extendido : out std_logic_vector(31 downto 0);
	o_Reg_Dst           : out std_logic_vector(4 downto 0);  --o registrador de destino
	o_funcao_ula        : out std_logic_vector(3 downto 0) --o funct7 mais o funct3 para o alucontrol
);
end component;

begin

u_Instruction_Fetch : Instruction_Fetch
port map(
	i_addr_mais4  => w_addr_mais4_if,
	i_addr_desvio => w_addr_mais4_mais_immed_mem, --vem do addr+4 + o imediato
	i_SEL         => w_Desvio_mem,                --vem do verificador de desvio
	i_CLK         => i_Clock,
	i_RST         => i_Reset,
	o_addr_mais4  => w_addr_mais4_if,
	o_instrucao   => w_instrucao_if
);

u_If_Id : If_Id
port map(
	i_CLK             => i_Clock,
	i_RST             => i_Reset,
	i_Instrucao_ROM   => w_instrucao_if,
	i_Program_Counter => w_addr_mais4_if,
	o_Program_Counter => w_addr_mais4_IF_ID,
	o_Instrucao_ROM   => w_instrucao_IF_ID
);

u_Instruction_Decode : Instruction_Decode
port map(
	i_instrucao   => w_instrucao_if,
	i_Dado_Novo   => w_Data_write_wb,    
	i_Reg_Destino => w_Reg_Destino_wb,
	i_imm_src     => w_imm_src,  --controle
	i_RegWrite    => w_RegWrite, --controle
	i_CLK         => i_Clock,
	i_RST         => i_Reset,
	o_RD1         => w_RD1_id,
	o_RD2         => w_RD2_id,
	o_imediato    => w_imediato_id,
	o_Reg_Destino => w_Reg_Destino_id,
	o_opcode      => w_opcode_id,
	o_funcao_ula  => w_funcao_ula
);

u_Controlador : controlador
port map(
  i_opcode   => w_opcode_id,
  o_JUMP     => w_JUMP,
  o_BRANCH   => w_BRANCH,
  o_MemToReg => w_MemToReg,
  o_MemWrite => w_MemWrite,
  o_AluSrc   => w_AluSrc,
  o_RegWrite => w_RegWrite,
  o_AluOP    => w_AluOP,
  o_imm_src  => w_imm_src
);

end architecture;