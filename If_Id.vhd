library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity If_Id is
port(
	i_CLK : in std_logic;
	i_RST : in std_logic;
	i_Instrucao_ROM : in std_logic_vector (31 downto 0);
	i_Programe_Counter :in std_logic_vector (31 downto 0);
	o_Programe_Counter : out std_logic_vector (31 downto 0);
	o_Instrucao_ROM : out std_logic_vector (31 downto 0)
);
end entity;

architecture arch_IF_Id of If_Id is

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

u_reg_Rom : registrador
	port map(
		i_CLK      => i_CLK,
		i_RST      => i_RST,
		i_D        => i_Instrucao_ROM,
		i_Enable   => '1',
		i_Escrever => '1',
		o_S        => o_Instrucao_ROM
);

u_reg_Intrucao : registrador 
port map(
		i_CLK      => i_CLK,
		i_RST      => i_RST,
		i_D        => i_Programe_Counter,
		i_Enable   => '1',
		i_Escrever => '1',
		o_S        => o_Programe_Counter
);

end architecture;