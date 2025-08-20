library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity regFile is
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
end entity;

architecture arch_regFile of regFile is

type t_registrador is array (0 to 31) of std_logic_vector(31 downto 0);
signal w_S         : t_registrador;
signal w_EnableReg : std_logic_vector(31 downto 0);

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

component decodeEnableReg is
port(
  i_EnableWrite : in std_logic_vector(4 downto 0);
  o_EnableReg   : out std_logic_vector(31 downto 0)
);
end component;

component decodeRD is
port(
  i_R   : in std_logic_vector(4 downto 0);
  i_x0  : in std_logic_vector(31 downto 0);
  i_x1  : in std_logic_vector(31 downto 0);
  i_x2  : in std_logic_vector(31 downto 0);
  i_x3  : in std_logic_vector(31 downto 0);
  i_x4  : in std_logic_vector(31 downto 0);
  i_x5  : in std_logic_vector(31 downto 0);
  i_x6  : in std_logic_vector(31 downto 0);
  i_x7  : in std_logic_vector(31 downto 0);
  i_x8  : in std_logic_vector(31 downto 0);
  i_x9  : in std_logic_vector(31 downto 0);
  i_x10 : in std_logic_vector(31 downto 0);
  i_x11 : in std_logic_vector(31 downto 0);
  i_x12 : in std_logic_vector(31 downto 0);
  i_x13 : in std_logic_vector(31 downto 0);
  i_x14 : in std_logic_vector(31 downto 0);
  i_x15 : in std_logic_vector(31 downto 0);
  i_x16 : in std_logic_vector(31 downto 0);
  i_x17 : in std_logic_vector(31 downto 0);
  i_x18 : in std_logic_vector(31 downto 0);
  i_x19 : in std_logic_vector(31 downto 0);
  i_x20 : in std_logic_vector(31 downto 0);
  i_x21 : in std_logic_vector(31 downto 0);
  i_x22 : in std_logic_vector(31 downto 0);
  i_x23 : in std_logic_vector(31 downto 0);
  i_x24 : in std_logic_vector(31 downto 0);
  i_x25 : in std_logic_vector(31 downto 0);
  i_x26 : in std_logic_vector(31 downto 0);
  i_x27 : in std_logic_vector(31 downto 0);
  i_x28 : in std_logic_vector(31 downto 0);
  i_x29 : in std_logic_vector(31 downto 0);
  i_x30 : in std_logic_vector(31 downto 0);
  i_x31 : in std_logic_vector(31 downto 0);
  o_RD  : out std_logic_vector(31 downto 0)
 );
end component;

begin

decoder: decodeEnableReg
port map(
  i_EnableWrite => i_EnableReg,
  o_EnableReg   => w_EnableReg
);

gen_registrador: for i in 0 to 31 generate
  reg: registrador
  port map(
    i_CLK      => i_CLK,
	 i_RST      => i_RST,
    i_D        => i_WriteData,
    i_Enable   => w_EnableReg(i),
	 i_Escrever => i_Escrever,
    o_S        => w_S(i)
  );
end generate gen_registrador;

RD1: decodeRD
port map(
    i_R   => i_R1,
    i_x0  => w_S(0),
    i_x1  => w_S(1),
    i_x2  => w_S(2),
    i_x3  => w_S(3),
    i_x4  => w_S(4),
    i_x5  => w_S(5),
    i_x6  => w_S(6),
    i_x7  => w_S(7),
    i_x8  => w_S(8),
    i_x9  => w_S(9),
    i_x10 => w_S(10),
    i_x11 => w_S(11),
    i_x12 => w_S(12),
    i_x13 => w_S(13),
    i_x14 => w_S(14),
    i_x15 => w_S(15),
    i_x16 => w_S(16),
    i_x17 => w_S(17),
    i_x18 => w_S(18),
    i_x19 => w_S(19),
    i_x20 => w_S(20),
    i_x21 => w_S(21),
    i_x22 => w_S(22),
    i_x23 => w_S(23),
    i_x24 => w_S(24),
    i_x25 => w_S(25),
    i_x26 => w_S(26),
    i_x27 => w_S(27),
    i_x28 => w_S(28),
    i_x29 => w_S(29),
    i_x30 => w_S(30),
    i_x31 => w_S(31),
    o_RD  => o_RD1
);

RD2: decodeRD
port map(
    i_R   => i_R2,
    i_x0  => w_S(0),
    i_x1  => w_S(1),
    i_x2  => w_S(2),
    i_x3  => w_S(3),
    i_x4  => w_S(4),
    i_x5  => w_S(5),
    i_x6  => w_S(6),
    i_x7  => w_S(7),
    i_x8  => w_S(8),
    i_x9  => w_S(9),
    i_x10 => w_S(10),
    i_x11 => w_S(11),
    i_x12 => w_S(12),
    i_x13 => w_S(13),
    i_x14 => w_S(14),
    i_x15 => w_S(15),
    i_x16 => w_S(16),
    i_x17 => w_S(17),
    i_x18 => w_S(18),
    i_x19 => w_S(19),
    i_x20 => w_S(20),
    i_x21 => w_S(21),
    i_x22 => w_S(22),
    i_x23 => w_S(23),
    i_x24 => w_S(24),
    i_x25 => w_S(25),
    i_x26 => w_S(26),
    i_x27 => w_S(27),
    i_x28 => w_S(28),
    i_x29 => w_S(29),
    i_x30 => w_S(30),
    i_x31 => w_S(31),
    o_RD  => o_RD2
);

end architecture;