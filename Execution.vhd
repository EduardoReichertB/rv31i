library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Execution is
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
end entity;

architecture ex_arch of Execution is

signal w_nada2, w_nada3 : std_logic;
signal w_B : std_logic_vector(31 downto 0);
signal w_sel : std_logic_vector(2 downto 0);

component add32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 i_CIN  : in std_logic;
 o_S    : out std_logic_vector (31 downto 0);
 o_COUT : out std_logic
);
end component;

component ULA is
port(
  i_A        : in std_logic_vector(31 downto 0);
  i_B        : in std_logic_vector(31 downto 0);
  i_SEL      : in std_logic_vector(2 downto 0);
  o_Zero     : out std_logic;
  o_Overflow : out std_logic;
  o_S        : out std_logic_vector(31 downto 0)
);
end component;

component mux32 is
port (
 i_SEL  : in std_logic; --Entrada
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;

component UlaControlador is
port(
  i_Endereco : in std_logic_vector(5 downto 0);
  --i_Endereco(5) => AluOP(1)
  --i_Endereco(4) => AluOP(0)
  --i_Endereco(3) => funct7, bit 30 da instrução
  --i_Endereco(2) => funct3, bit 14 da instrução
  --i_Endereco(1) => funct3, bit 13 da instrução
  --i_Endereco(0) => funct3, bit 12 da instrução
  o_Operacao : out std_logic_vector(2 downto 0)
);
end component;

begin

u_add_desvio : add32
port map(
	i_A    => i_pc_mais_quatro,
	i_B    => i_imediato,
	i_CIN  => '0',
	o_S    => o_Desvio,
	o_COUT => w_nada2
);

u_Mux_ALU_Src : mux32
port map(
	i_SEL => i_AluSrc,
	i_A   => i_B,
	i_B   => i_imediato,
	o_S   => w_B
);

u_ulacontrolador : UlaControlador
port map(
    i_Endereco(5) => i_Aluop(1),
    i_Endereco(4) => i_Aluop(0),
    i_Endereco(3) => i_funcao(3),
    i_Endereco(2) => i_funcao(2),
    i_Endereco(1) => i_funcao(1),
    i_Endereco(0) => i_funcao(0),
    o_operacao    => w_sel
);

u_ULA : ULA
port map(
	i_A        => i_A,
	i_B        => w_B,
	i_SEL      => w_sel,
	o_Zero     => o_Zero,
	o_Overflow => w_nada3,
	o_S        => o_Resultado_Ula
);

o_Data_in_ram <= i_B;

o_funct3 <= i_funcao(0);

end architecture;