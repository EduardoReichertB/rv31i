library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
port(
  i_A        : in std_logic_vector(31 downto 0);
  i_B        : in std_logic_vector(31 downto 0);
  i_SEL      : in std_logic_vector(2 downto 0);
  o_Zero     : out std_logic;
  o_Overflow : out std_logic;
  o_S        : out std_logic_vector(31 downto 0)
);
end entity;

architecture arch_ULA of ULA is

signal w_Sadd, w_Ssub, w_Sand, w_Sxor, w_Sor, w_Sslt, w_Ssll, w_Ssrl, w_Ssra, w_negado_B: std_logic_vector(31 downto 0);
signal w_overflow_add, w_overflow_sub : std_logic;

component add32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 i_CIN  : in std_logic;
 o_S    : out std_logic_vector (31 downto 0);
 o_COUT : out std_logic
);
end component;


component and32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;

component or32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;

component xor32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0); 
 o_S    : out std_logic_vector (31 downto 0)
);
end component;

component slt32 is
port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 o_S    : out std_logic_vector (31 downto 0)
);
end component; 

component mux32_8x1 is
port (
 i_SEL  : in std_logic_vector (2 downto 0);
 i_A    : in std_logic_vector (31 downto 0);  --ADD 
 i_B    : in std_logic_vector (31 downto 0);  --SUB 
 i_C    : in std_logic_vector (31 downto 0);  --AND 
 i_D    : in std_logic_vector (31 downto 0);  --OR
 i_E    : in std_logic_vector (31 downto 0);  --XOR
 i_F    : in std_logic_vector (31 downto 0);  --SLT
 i_G    : in std_logic_vector (31 downto 0);
 i_H    : in std_logic_vector (31 downto 0);
 o_S    : out std_logic_vector(31 downto 0)
);
end component;

component verifica_Zero is
port(
  i_Result : in std_logic_vector(31 downto 0);
  o_Zero   : out std_logic
);
end component;

begin

w_negado_B <= i_B xor ("11111111111111111111111111111111");

u_add : add32
port map(
  i_A    => i_A,
  i_B    => i_B,
  i_CIN  => '0',
  o_S    => w_Sadd,
  o_COUT => w_overflow_add
);

u_sub : add32
port map(
  i_A    => i_A,
  i_B    => w_negado_B,
  i_CIN  => '1',
  o_S    => w_Ssub,
  o_COUT => w_overflow_sub
);

u_and : and32
port map(
  i_A => i_A,
  i_B => i_B,
  o_S => w_Sand
);

u_or : or32
port map(
  i_A => i_A,
  i_B => i_B,
  o_S => w_Sor
);

u_xor : xor32
port map(
  i_A => i_A,
  i_B => i_B,
  o_S => w_Sxor
);

u_slt : slt32
port map(
  i_A => i_A,
  i_B => i_B,
  o_S => w_Sslt
);

u_mux8x1 : mux32_8x1
port map(
  i_SEL => i_SEL,
  i_A   => w_Sadd, --ADD 000
  i_B   => w_Ssub, --SUB 001
  i_C   => w_Sand, --AND 010
  i_D   => w_Sor,  --OR  011
  i_E   => w_Sxor, --XOR 100
  i_F   => w_Sslt, --SLT 101
  i_G   => "00000000000000000000000000000000",
  i_H   => "00000000000000000000000000000000",
  o_S   => o_S
);

o_Overflow <= w_overflow_add when i_SEL = "000" else  -- ADD
              w_overflow_sub when i_SEL = "001" else  -- SUB
              '0';


u_verifica : verifica_Zero
port map(
  i_Result => w_Ssub,
  o_Zero   => o_Zero
);

end architecture;

