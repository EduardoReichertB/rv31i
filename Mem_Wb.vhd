library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mem_Wb is
port(
	i_CLK        : in std_logic;
	i_RST        : in std_logic;
	i_Mem_To_Reg : in std_logic;
	i_Reg_Write  : in std_logic;
	i_data_out   : in std_logic_vector(31 downto 0);
	i_Ula_Result : in std_logic_vector(31 downto 0);
	i_Reg_Dst    : in std_logic_vector(4 downto 0);
	o_Mem_To_Reg : out std_logic;
	o_Reg_Write  : out std_logic;
	o_data_out   : out std_logic_vector(31 downto 0);
	o_Ula_Result : out std_logic_vector(31 downto 0);
	o_Reg_Dst    : out std_logic_vector(4 downto 0)
);
end entity;

architecture mem_wb_arch of Mem_Wb is

component registrador_1bit
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
    i_D       : in std_logic; 
    o_S       : out std_logic 
  ); 
end component; 

component registrador is
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
	 i_Enable  : in std_logic;
	 i_Escrever: in std_logic; 
    i_D       : in std_logic_vector (31 downto 0); 
    o_S       : out std_logic_vector (31 downto 0) 
  ); 
end component; 

begin

REG_Mem_To_Reg : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Mem_to_Reg,
	o_S   => o_Mem_to_Reg
);

REG_Reg_Write : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Reg_Write,
	o_S   => o_Reg_Write
);

REG_Saida_Memoria : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_data_out,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_data_out
);

REG_Ula_Result : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_Ula_Result,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_Ula_Result
);

gen_Reg_Destino : for i in 0 to 4 generate
  REG_Reg_Destino: registrador_1bit
  port map(
    i_CLK      => i_CLK,
	 i_RST      => i_RST,
    i_D        => i_Reg_Dst(i),
    o_S        => o_Reg_Dst(i)
  );
end generate gen_Reg_Destino;

end architecture;

