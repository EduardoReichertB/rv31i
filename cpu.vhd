library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
port(
  i_Clock : in std_logic;
  i_Reset : in std_logic
);
end entity;

architecture arch_cpu of cpu is

signal w_PC_endereco : std_logic_vector(31 downto 0); -- 
signal w_instrucao   : std_logic_vector(31 downto 0); -- o_q -- instru��o da rom
signal w_data_RD1   : std_logic_vector(31 downto 0); -- valor armazenado dentro do registrador "A" selecionado
signal w_data_RD2   : std_logic_vector(31 downto 0); -- valor armazenado dentro do registrador "B" selecionado
signal w_data_out : std_logic_vector(31 downto 0);
signal w_desvio_pro_mux_pc : std_logic;
signal w_MUX_SAIDA_BANCO_REGISTRADOR : std_logic_vector(31 downto 0);
signal W_MUX_SAIDA_RAM : std_logic_vector(31 downto 0);
signal w_MUX_DESVIO    : std_logic_vector(31 downto 0);
signal w_imm_src 	 : std_logic_vector(1 downto 0);
signal w_Saida_extensor  : std_logic_vector(31 downto 0);
signal w_JUMP     : std_logic;
signal w_BRANCH   : std_logic;
signal w_MemToReg  : std_logic;
signal w_MemWrit  : std_logic;
signal w_AluSrc   : std_logic;
signal w_RegWrit  : std_logic;
signal w_AluOP    : std_logic_vector(1 downto 0);
signal w_saida_add_desvio : std_logic_vector (31 downto 0);
signal w_add_pc_mais_4 : std_logic_vector (31 downto 0);
signal w_terra : std_logic;
signal w_saida_operacao_UlaControl : std_logic_vector(2 downto 0);
signal w_Zero     :  std_logic;
signal w_Overflow :  std_logic;
signal w_S        :  std_logic_vector (31 downto 0);


------------------------------------------------------COME�O DECLARA��O DE COMPONENTES-----------------------------------------------
component pc is
  port (
    i_RST  : in std_logic;
    i_CLK  : in std_logic; -- clock
    i_Data : in std_logic_vector (31 downto 0); 
    o_PC   : out std_logic_vector (31 downto 0) 
  ); 
end component;

component rom is
  generic (
    DATA_WIDTH : natural := 32;
    ADDR_WIDTH : natural := 8
  );
  port (
    clk     : in  std_logic;
    addr_in : in  std_logic_vector(31 downto 0); -- vai receber o w_PC_endereco do pc
    q       : out std_logic_vector(DATA_WIDTH-1 downto 0) --
  );
end component;

component regFile
port(
  i_R1        : in std_logic_vector(4 downto 0);
  i_R2        : in std_logic_vector(4 downto 0); 
  i_WriteData : in std_logic_vector(31 downto 0); --o dado que sera escrito no registrador habilitado
  i_EnableReg : in std_logic_vector(4 downto 0);  --habilita 1 registrador para ser atualiado
  i_CLK       : in std_logic;
  i_RST       : in std_logic;
  i_Escrever  : in std_logic;                     --se 1 ent�o tem escrita; se 0 n�o tem
  o_RD1       : out std_logic_vector(31 downto 0);
  o_RD2       : out std_logic_vector(31 downto 0)
);
end component;

component data_memory 
    generic (
        DATA_WIDTH : natural := 32;  -- 32 bits para RISC-V
        ADDR_WIDTH : natural := 10   -- 2^10 endere�os = 1KB (1024 palavras de 32 bits)
    );
    port (
        clk      : in std_logic;
        addr     : in std_logic_vector(31 downto 0);  -- Endere�o byte-addressable
        data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        we       : in std_logic;  -- Write Enable
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;

component muxPC_control
	port(
		i_Entrada : in std_logic_vector(3 downto 0);
		o_Desvio : out std_logic
);
end component;

component mux32   
port (
 i_SEL  : in std_logic; --Entrada
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;


component extensor_sinal
    port (
        i_instrucao : in  std_logic_vector(31 downto 0);
        i_imm_src   : in  std_logic_vector(1 downto 0);
        o_inteiro   : out std_logic_vector(31 downto 0)
    );
end component;


component controlador 
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


component add32    
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 i_CIN  : in std_logic;
 o_S    : out std_logic_vector (31 downto 0);
 o_COUT : out std_logic
);
end component;

component UlaControlador 
port(
  i_Endereco : in std_logic_vector(5 downto 0);
  o_Operacao : out std_logic_vector(2 downto 0)
);
end component;

component ULA
port(
  i_A        : in std_logic_vector(31 downto 0);
  i_B        : in std_logic_vector(31 downto 0);
  i_SEL      : in std_logic_vector(2 downto 0);
  o_Zero     : out std_logic;
  o_Overflow : out std_logic;
  o_S        : out std_logic_vector(31 downto 0)
);
end component;

------------------------------------------------------FIM DECLARA��O DE COMPONENTES-----------------------------------------------

begin

u_PC : pc
port map(
	i_RST  => i_Reset,
	i_CLK  => i_Clock,
	i_Data => w_MUX_DESVIO,--aqui vai receber um desvio ou o pc+4 (que vai ser decidido por um MUX)
	o_PC   => w_PC_endereco
);

u_ROM : rom
generic map(
	DATA_WIDTH => 32,
	ADDR_WIDTH => 8
)
port map(
	clk     => i_Clock,
	addr_in => w_PC_endereco, --recebe o endere�o do PC
	q       => w_instrucao    --sai a instru��o atual
);

u_CONTROL : controlador 
port map(
	i_opcode   =>  w_instrucao (6 downto 0),
	o_JUMP     =>  w_JUMP,
	o_BRANCH   =>  w_BRANCH,
	o_MemToReg =>  w_MemToReg,
	o_MemWrite =>  w_MemWrit,
	o_AluSrc   =>  w_AluSrc, 
	o_RegWrite =>  w_RegWrit,
	o_AluOP    =>  w_AluOP,  
	o_imm_src  =>  w_imm_src
);

u_REG_FILE : regFile
port map(
	i_R1        =>  w_instrucao (19 downto 15),
	i_R2        =>  w_instrucao (24 downto 20),
	i_WriteData =>  W_MUX_SAIDA_RAM, -- saida mux da ula
	i_EnableReg =>  w_instrucao (11 downto 7),
	i_CLK       =>  i_Clock,
	i_RST       =>  i_Reset,
	i_Escrever  =>  w_RegWrit,-- o_RegWrite do control
	o_RD1       =>  w_data_RD1,
	o_RD2       =>  w_data_RD2
);

u_MUX_SAIDA_BANCO_REGISTRADORES : mux32
port map(
	i_SEL  =>  w_AluSrc,-- SAIDA DO CONTROL o_AluSrc
	i_A    =>  w_data_RD2,
	i_B    =>  w_Saida_extensor,-- IMEDIADO VINDO DO EXTENSOR DE SINAL
	o_S    =>  w_MUX_SAIDA_BANCO_REGISTRADOR
);

u_MUX_SAIDA_RAM : mux32
port map(
	i_SEL  =>  w_MemToReg,
	i_A    =>  w_S,       -- saida da ULA
	i_B    =>  w_data_out,-- saida da RAM
	o_S    =>  W_MUX_SAIDA_RAM
);

u_MUX_PC_CONTROL : mux32
port map(
	i_SEL  =>  w_desvio_pro_mux_pc,
	i_A    =>  w_add_pc_mais_4,
	i_B    =>  w_saida_add_desvio,
	o_S    =>  w_MUX_DESVIO
);

u_RAM :data_memory 
    generic map(
        DATA_WIDTH => 32,  -- 32 bits para RISC-V
        ADDR_WIDTH => 10   -- 2^10 endere�os = 1KB (1024 palavras de 32 bits)
    )
    port map(
        clk      => i_Clock,
        addr     => w_S,--saida ULA
        data_in  => w_data_RD2,
        we        => w_MemWrit,  -- Write Enable
        data_out => w_data_out
    );
	 
u_extensor_sinal : extensor_sinal
    port map(
        i_instrucao =>  w_instrucao,
        i_imm_src   =>  w_imm_src,
        o_inteiro   =>  w_Saida_extensor
    );
	 
u_ULA : ULA
port map(
  i_A        => w_data_RD1,
  i_B        => w_MUX_SAIDA_BANCO_REGISTRADOR,
  i_SEL      => w_saida_operacao_UlaControl,-- saida ULA control
  o_Zero     => w_Zero,    
  o_Overflow => w_Overflow,
  o_S        => w_S
);

u_decodificador : muxPC_control
	port map(
		i_Entrada(3) => w_JUMP,  
		i_Entrada(2) => w_BRANCH,
		i_Entrada(1) => w_instrucao(12),
		i_Entrada(0) => w_Zero,
		o_Desvio  => w_desvio_pro_mux_pc
);

u_add_desvio : add32    
port map(
 i_A    => w_PC_endereco,
 i_B    => w_Saida_extensor,
 i_CIN  => '0',
 o_S    => w_saida_add_desvio,
 o_COUT => w_terra
);

u_add_pc_mais_4 : add32    
port map(
 i_A    => w_PC_endereco,
 i_B    => "00000000000000000000000000000100",
 i_CIN  => '0',
 o_S    => w_add_pc_mais_4,
 o_COUT => w_terra
);

u_UlaControlador : UlaControlador 
port map(
  i_Endereco(5) => w_AluOP(1),
  i_Endereco(4) => w_AluOP(0),
  i_Endereco(3) => w_instrucao(30),
  i_Endereco(2) => w_instrucao(14),
  i_Endereco(1) => w_instrucao(13),
  i_Endereco(0) => w_instrucao(12),
  o_Operacao => w_saida_operacao_UlaControl
);

end architecture;
