library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
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
end entity;

architecture mem_arch of Memory is

component muxPC_Control is
port(
  i_Entrada : in std_logic_vector(3 downto 0);
  --i_Entrada(3) => JUMP do controle
  --i_Entrada(2) => BRANCH do controle
  --i_Entrada(1) => bit (12) da instrução (FUNCT3 usado para diferenciar BEQ do BNE)
    --0 -> BEQ; 1 -> BNE
  --i_Entrada(0) => Zero flag
  o_Desvio : out std_logic
);
end component;

component data_memory is
    generic (
        DATA_WIDTH : natural := 32;  -- 32 bits para RISC-V
        ADDR_WIDTH : natural := 10   -- 2^10 endereços = 1KB (1024 palavras de 32 bits)
    );
    port (
        clk      : in std_logic;
        addr     : in std_logic_vector(31 downto 0);  -- Endereço byte-addressable
        data_in  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        we       : in std_logic;  -- Write Enable
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;

begin

u_controlador_de_desvio : muxPC_Control
port map(
	i_Entrada(3) => i_Jump,
	i_Entrada(2) => i_Branch,
	i_Entrada(1) => i_funct3,
	i_Entrada(0) => i_Zero,
	o_Desvio     => o_ocorreu_desvio
);

u_memoria : data_memory
generic map(
	DATA_WIDTH => 32,  -- 32 bits para RISC-V
   ADDR_WIDTH => 10
)
port map(
	clk      => i_CLK,
	addr     => i_saida_ULA,
	data_in  => i_data_in,
	we       => i_WriteEnable,
	data_out => o_data_out
);

o_saida_ULA <= i_saida_ULA;

end architecture;