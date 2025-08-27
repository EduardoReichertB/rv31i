library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Write_Back is
port(
	i_saida_ula  : in std_logic_vector(31 downto 0);
	i_data_out   : in std_logic_vector(31 downto 0);
	i_MemToReg   : in std_logic;
	o_Data_write : out std_logic_vector(31 downto 0)
);
end entity;

architecture wb_arch of Write_Back is

component mux32 is
port (
 i_SEL  : in std_logic; --Entrada
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;

begin

u_mux_write_back : mux32
port map(
	i_SEL => i_MemToReg,
	i_A   => i_saida_ula,
	i_B   => i_data_out,
	o_S   => o_Data_write
);

end architecture;
