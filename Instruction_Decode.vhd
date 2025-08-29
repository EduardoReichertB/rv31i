library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Decode is
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
end entity;

architecture id_arch of Instruction_Decode is

component regFile is
port(
  i_R1        : in std_logic_vector(4 downto 0);
  i_R2        : in std_logic_vector(4 downto 0); 
  i_WriteData : in std_logic_vector(31 downto 0); --o dado que sera escrito no registrador habilitado
  i_EnableReg : in std_logic_vector(4 downto 0);  --habilita 1 registrador para ser atualiado
  i_CLK       : in std_logic;
  i_RST       : in std_logic;
  i_Escrever  : in std_logic;                     --se 1 então tem escrita; se 0 não tem
  o_RD1       : out std_logic_vector(31 downto 0);
  o_RD2       : out std_logic_vector(31 downto 0)
);
end component;

component extensor_sinal is
port (
	i_instrucao : in  std_logic_vector(31 downto 0);
	i_imm_src   : in  std_logic_vector(1 downto 0);
	o_inteiro   : out std_logic_vector(31 downto 0)
);
end component;

begin

u_banco_registrador : regFile
port map(
  i_R1        => i_instrucao(19 downto 15),
  i_R2        => i_instrucao(24 downto 20),
  i_WriteData => i_Dado_Novo,   --dado que vai ser escrito
  i_EnableReg => i_Reg_Destino, --registrador aonde o dado vai ser escrito
  i_CLK       => i_CLK,
  i_RST       => i_RST,
  i_Escrever  => i_RegWrite, --do controle
  o_RD1       => o_RD1,
  o_RD2       => o_RD2
);

u_extensor_sinal : extensor_sinal
port map(
	i_instrucao => i_instrucao,
	i_imm_src   => i_imm_src, --do controle
	o_inteiro   => o_imediato
);

o_opcode <= i_instrucao(6 downto 0);

o_Reg_Destino <= i_instrucao(11 downto 7);

o_funcao_ula(0) <= i_instrucao(12);
o_funcao_ula(1) <= i_instrucao(13);
o_funcao_ula(2) <= i_instrucao(14);
o_funcao_ula(3) <= i_instrucao(30);

end architecture;
