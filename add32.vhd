library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity add32 is   

port (
 i_A    : in std_logic_vector (31 downto 0);
 i_B    : in std_logic_vector (31 downto 0);
 i_CIN  : in std_logic;
 o_S    : out std_logic_vector (31 downto 0);
 o_COUT : out std_logic
);

end add32;
---------------------------------------------
architecture arch_add of add32 is

signal w_CO : std_logic_vector(30 downto 0);
begin

  o_S(0)    <= i_A(0) xor i_B(0) xor i_CIN;
  w_CO(0) <= (i_A(0) and i_B(0)) or (i_A(0) and i_CIN) or (i_B(0) and i_CIN);
  
  gen_add32 : for i in 0 to 29 generate
  begin
  
    o_S(i+1)    <= i_A(i+1) xor i_B(i+1) xor w_CO(i);
    w_CO(i+1) <= (i_A(i+1) and i_B(i+1)) or (i_A(i+1) and w_CO(i)) or (i_B(i+1) and w_CO(i));
  
  end generate gen_add32;
  
  o_S(31) <= i_A(31) xor i_B(31) xor w_CO(30);
  o_COUT  <= (i_A(31) and i_B(31)) or (i_A(31) and w_CO(30)) or (i_B(31) and w_CO(30));

end arch_add;