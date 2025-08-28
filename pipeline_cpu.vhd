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
signal w_opcode_id : std_logic_vector(6 downto 0);
signal w_Reg_Destino_id : std_logic_vector(4 downto 0);
signal w_funcao_ula_id : std_logic_vector(3 downto 0);

--sinais BARRAMENTO id-ex
signal w_MemToReg_ID_EX : std_logic;
signal w_BRANCH_ID_EX : std_logic;
signal w_JUMP_ID_EX : std_logic;
signal w_MemWrite_ID_EX : std_logic;
signal w_AluSrc_ID_EX : std_logic;
signal w_RegWrite_ID_EX : std_logic;
signal w_AluOP_ID_EX : std_logic_vector(1 downto 0);
signal w_imm_src_ID_EX : std_logic_vector(1 downto 0);
signal w_addr_mais4_ID_EX : std_logic_vector(31 downto 0);
signal w_RD1_ID_EX : std_logic_vector(31 downto 0);
signal w_RD2_ID_EX : std_logic_vector(31 downto 0);
signal w_imediato_ID_EX : std_logic_vector(31 downto 0);
signal w_Reg_Destino_ID_EX : std_logic_vector(4 downto 0); 
signal w_funcao_ula_ID_EX : std_logic_vector(3 downto 0);

--sinais ETAPA ex
signal w_addr_mais4_mais_immed_ex : std_logic_vector(31 downto 0);
signal w_Zero_ex : std_logic;
signal w_Resultado_Ula_ex : std_logic_vector(31 downto 0);
signal w_data_in_ram_ex : std_logic_vector(31 downto 0);
signal w_funct3_ex : std_logic;

--sinais BARRAMENTO ex-mem
signal w_MemToReg_EX_MEM : std_logic;
signal w_BRANCH_EX_MEM : std_logic;
signal w_JUMP_EX_MEM : std_logic;
signal w_RegWrite_EX_MEM : std_logic;
signal w_MemWrite_EX_MEM : std_logic;
signal w_addr_mais4_mais_immed_EX_MEM : std_logic_vector(31 downto 0);
signal w_Zero_EX_MEM : std_logic;
signal w_Resultado_Ula_EX_MEM : std_logic_vector(31 downto 0);
signal w_RD2_EX_MEM : std_logic_vector(31 downto 0);
signal w_Reg_Destino_EX_MEM : std_logic_vector(4 downto 0);
signal w_funct3_EX_MEM : std_logic;

--sinais ETAPA mem
signal w_ocorreu_desvio_mem : std_logic;
signal w_data_out_mem       : std_logic_vector(31 downto 0);
signal w_saida_ula_mem      : std_logic_vector(31 downto 0);

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

component Execution is
port(
	i_pc_mais_quatro : in std_logic_vector(31 downto 0);
	i_imediato       : in std_logic_vector(31 downto 0);
	i_A              : in std_logic_vector(31 downto 0); --recebe o RD1
	i_B              : in std_logic_vector(31 downto 0); --recebe o RD2
	i_funcao         : in std_logic_vector(3 downto 0);
	i_AluSrc         : in std_logic;                     --do controle
	i_AluOP          : in std_logic_vector(1 downto 0);  --do controle
	o_Desvio         : out std_logic_vector(31 downto 0);
	o_Zero           : out std_logic;
	o_Resultado_Ula  : out std_logic_vector(31 downto 0);
	o_Data_in_ram    : out std_logic_vector(31 downto 0);
	o_funct3         : out std_logic
);
end component;

component Ex_Mem is
port(
   i_CLK        : in std_logic;
	i_RST        : in std_logic;
	i_Mem_To_Reg : in std_logic;
	i_Branch     : in std_logic;
	i_Jump       : in std_logic;
	i_Reg_Write  : in std_logic;
	i_MemWrite   : in std_logic;
	i_addr_mais4 : in std_logic_vector(31 downto 0);
	i_Zero       : in std_logic;
	i_Ula_Result : in std_logic_vector(31 downto 0);
	i_RD2        : in std_logic_vector(31 downto 0);
	i_Reg_Dst    : in std_logic_vector(4 downto 0);
	i_funct3     : in std_logic;
	o_Mem_To_Reg : out std_logic;
	o_Branch     : out std_logic;
	o_Jump       : out std_logic;
	o_Reg_Write  : out std_logic;
	o_MemWrite   : out std_logic;
	o_addr_mais4 : out std_logic_vector(31 downto 0);
	o_Zero       : out std_logic;
	o_Ula_Result : out std_logic_vector(31 downto 0);
	o_RD2        : out std_logic_vector(31 downto 0);
	o_Reg_Dst    : out std_logic_vector(4 downto 0);
	o_funct3     : out std_logic
);
end component;

component Memory is
port(
   i_CLK            : in std_logic;
	i_Zero           : in std_logic;
	i_Jump           : in std_logic; --do controle
	i_Branch         : in std_logic; --do controle
	i_funct3         : in std_logic;
	i_saida_ULA      : in std_logic_vector(31 downto 0);
	i_data_in        : in std_logic_vector(31 downto 0);
	i_WriteEnable    : in std_logic; --do controle
	o_ocorreu_desvio : out std_logic;
	o_data_out       : out std_logic_vector(31 downto 0);
	o_saida_ULA      : out std_logic_vector(31 downto 0)
);
end component;

begin

u_Instruction_Fetch : Instruction_Fetch
port map(
	i_addr_mais4  => w_addr_mais4_if,
	i_addr_desvio => w_addr_mais4_mais_immed_EX_MEM, --vem do addr+4 + o imediato
	i_SEL         => w_ocorreu_desvio_mem,        --vem do verificador de desvio
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
	o_funcao_ula  => w_funcao_ula_id
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

u_Id_Ex : Id_Ex
port map(
	i_CLK               => i_Clock,
	i_RST               => i_Reset,
	i_Mem_to_Reg        => w_MemToReg,
	i_Branch            => w_BRANCH,
	i_Jump              => w_JUMP,
	i_Alu_Src           => w_AluSrc,
	i_Reg_Write         => w_RegWrite,
	i_MemWrite          => w_MemWrite,
	i_AluOP             => w_AluOP,
	i_addr_mais4        => w_addr_mais4_IF_ID, --para somar com o endereço calculado para casos de branch e jump
	i_RD1               => w_RD1_id,
	i_RD2               => w_RD2_id,
	i_inteiro_extendido => w_imediato_id,
	i_Reg_Dst           => w_Reg_Destino_id, --o registrador de destino
	i_funcao_ula        => w_funcao_ula_id, --o funct7 mais o funct3 para o alucontrol
	o_Mem_to_Reg        => w_MemToReg_ID_EX,
	o_Branch            => w_BRANCH_ID_EX,
	o_Jump              => w_JUMP_ID_EX,
	o_Alu_Src           => w_AluSrc_ID_EX,
	o_Reg_Write         => w_RegWrite_ID_EX,
	o_MemWrite          => w_MemWrite_ID_EX,
	o_AluOP             => w_AluOP_ID_EX,
	o_addr_mais4        => w_addr_mais4_ID_EX, --para somar com o endereço calculado para casos de branch e jump
	o_RD1               => w_RD1_ID_EX,
	o_RD2               => w_RD2_ID_EX,
	o_inteiro_extendido => w_imediato_ID_EX,
	o_Reg_Dst           => w_Reg_Destino_ID_EX, --o registrador de destino
	o_funcao_ula        => w_funcao_ula_ID_EX   --o funct7 mais o funct3 para o alucontrol
);

U_Execution : Execution
port map(
	i_pc_mais_quatro => w_addr_mais4_IF_ID,
	i_imediato       => w_imediato_ID_EX,
	i_A              => w_RD1_ID_EX, --recebe o RD1
	i_B              => w_RD2_ID_EX, --recebe o RD2
	i_funcao         => w_funcao_ula_ID_EX,
	i_AluSrc         => w_AluSrc_ID_EX, --do controle
	i_AluOP          => w_AluOP_ID_EX, --do controle
	o_Desvio         => w_addr_mais4_mais_immed_ex,
	o_Zero           => w_Zero_ex,
	o_Resultado_Ula  => w_Resultado_Ula_ex,
	o_Data_in_ram    => w_data_in_ram_ex,
	o_funct3         => w_funct3_ex --para o controlador do desvio (BEQ ou BNE)
);

u_Ex_Mem : Ex_Mem 
port map(
   i_CLK        => i_Clock,
	i_RST        => i_Reset,
	i_Mem_To_Reg => w_MemToReg_ID_EX,
	i_Branch     => w_BRANCH_ID_EX,
	i_Jump       => w_JUMP_ID_EX,
	i_Reg_Write  => w_RegWrite_ID_EX,
	i_MemWrite   => w_MemWrite_ID_EX,
	i_addr_mais4 => w_addr_mais4_mais_immed_ex,
	i_Zero       => w_Zero_ex,
	i_Ula_Result => w_Resultado_Ula_ex,
	i_RD2        => w_RD2_ID_EX,
	i_Reg_Dst    => w_Reg_Destino_ID_EX,
	i_funct3     => w_funct3_ex,
	o_Mem_To_Reg => w_MemToReg_EX_MEM,
	o_Branch     => w_BRANCH_EX_MEM,
	o_Jump       => w_JUMP_EX_MEM,
	o_Reg_Write  => w_RegWrite_EX_MEM,
	o_MemWrite   => w_MemWrite_EX_MEM,
	o_addr_mais4 => w_addr_mais4_mais_immed_EX_MEM,
	o_Zero       => w_Zero_EX_MEM,
	o_Ula_Result => w_Resultado_Ula_EX_MEM,
	o_RD2        => w_RD2_EX_MEM,
	o_Reg_Dst    => w_Reg_Destino_EX_MEM,
	o_funct3     => w_funct3_EX_MEM
);

u_Memory : Memory
port map(
   i_CLK            => i_Clock,
	i_Zero           => w_Zero_EX_MEM,
	i_Jump           => w_JUMP_EX_MEM,   --do controle
	i_Branch         => w_BRANCH_EX_MEM, --do controle
	i_funct3         => w_funct3_EX_MEM,
	i_saida_ULA      => w_Resultado_Ula_EX_MEM,
	i_data_in        => w_RD2_EX_MEM,
	i_WriteEnable    => w_MemWrite_EX_MEM,--do controle
	o_ocorreu_desvio => w_ocorreu_desvio_mem,
	o_data_out       => w_data_out_mem,
	o_saida_ULA      => w_saida_ula_mem
);

end architecture;
