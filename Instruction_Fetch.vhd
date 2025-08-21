library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Fetch is
port(
	i_addr_mais4  : in std_logic_vector(31 downto 0);
	i_addr_desvio : in std_logic_vector(31 downto 0);
	i_SEL         : in std_logic;
	i_CLK         : in std_logic;
	i_RST         : in std_logic;
	o_addr_mais4  : out std_logic_vector(31 downto 0);
	o_instrucao   : out std_logic_vector(31 downto 0)
);
end entity;

architecture if_arch of Instruction_Fetch is

signal w_proximo_endereco, w_endereco : std_logic_vector(31 downto 0);
signal w_nada : std_logic;

component mux32 is
port (
	i_SEL  : in std_logic; --Entrada
	i_A    : in std_logic_vector (31 downto 0);
	i_B    : in std_logic_vector (31 downto 0); 
	o_S    : out std_logic_vector (31 downto 0)
);
end component;

component pc is
port (
	i_CLK  : in std_logic; -- clock
	i_RST  : in std_logic; --reset
	i_Data : in std_logic_vector (31 downto 0); 
	o_PC   : out std_logic_vector (31 downto 0) 
); 
end component;

component rom is
generic (
	DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 8  -- 2^8 instruções = 256 instruções
);
port (
	clk      : in  std_logic;
	addr_in  : in  std_logic_vector(31 downto 0);
	q        : out std_logic_vector(DATA_WIDTH-1 downto 0)
);
end component;

component add32 is
port (
	i_A    : in std_logic_vector (31 downto 0);
	i_B    : in std_logic_vector (31 downto 0);
	i_CIN  : in std_logic;
	o_S    : out std_logic_vector (31 downto 0);
	o_COUT : out std_logic
);
end component;

begin

u_mux_for_pc : mux32
port map(
	i_SEL => i_SEL, --vem do muxPC_control
	i_A   => i_addr_mais4,
	i_B   => i_addr_desvio,
	o_S   => w_proximo_endereco
);

u_pc : pc
port map(
	i_CLK  => i_CLK,
	i_RST  => i_RST,
	i_Data => w_proximo_endereco,
	o_PC   => w_endereco
);

u_rom : rom
generic map(
	DATA_WIDTH => 32,
	ADDR_WIDTH => 8  -- 2^8 instruções = 256 instruções
)
port map(
	clk     => i_CLK,
	addr_in => w_endereco,
	q       => o_instrucao
);

u_pc_mais_quatro : add32
port map(
	i_A    => w_endereco,
	i_B    => "00000000000000000000000000000100",
	i_CIN  => '0',
	o_S    => o_addr_mais4,
	o_COUT => w_nada
);

end architecture;
	
	