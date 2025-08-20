library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodeRD is
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
 
end entity;
 
architecture arch_decodeRD of decodeRD is
begin

  gen_decode : for i in 0 to 31 generate
  begin
    o_RD(i) <= 
      (not i_R(4) and not i_R(3) and not i_R(2) and not i_R(1) and not i_R(0) and i_x0(i))  or
      (not i_R(4) and not i_R(3) and not i_R(2) and not i_R(1) and     i_R(0) and i_x1(i))  or
      (not i_R(4) and not i_R(3) and not i_R(2) and     i_R(1) and not i_R(0) and i_x2(i))  or
      (not i_R(4) and not i_R(3) and not i_R(2) and     i_R(1) and     i_R(0) and i_x3(i))  or
      (not i_R(4) and not i_R(3) and     i_R(2) and not i_R(1) and not i_R(0) and i_x4(i))  or
      (not i_R(4) and not i_R(3) and     i_R(2) and not i_R(1) and     i_R(0) and i_x5(i))  or
      (not i_R(4) and not i_R(3) and     i_R(2) and     i_R(1) and not i_R(0) and i_x6(i))  or
      (not i_R(4) and not i_R(3) and     i_R(2) and     i_R(1) and     i_R(0) and i_x7(i))  or
      (not i_R(4) and     i_R(3) and not i_R(2) and not i_R(1) and not i_R(0) and i_x8(i))  or
      (not i_R(4) and     i_R(3) and not i_R(2) and not i_R(1) and     i_R(0) and i_x9(i))  or
      (not i_R(4) and     i_R(3) and not i_R(2) and     i_R(1) and not i_R(0) and i_x10(i)) or
      (not i_R(4) and     i_R(3) and not i_R(2) and     i_R(1) and     i_R(0) and i_x11(i)) or
      (not i_R(4) and     i_R(3) and     i_R(2) and not i_R(1) and not i_R(0) and i_x12(i)) or
      (not i_R(4) and     i_R(3) and     i_R(2) and not i_R(1) and     i_R(0) and i_x13(i)) or
      (not i_R(4) and     i_R(3) and     i_R(2) and     i_R(1) and not i_R(0) and i_x14(i)) or
      (not i_R(4) and     i_R(3) and     i_R(2) and     i_R(1) and     i_R(0) and i_x15(i)) or
      (    i_R(4) and not i_R(3) and not i_R(2) and not i_R(1) and not i_R(0) and i_x16(i)) or
      (    i_R(4) and not i_R(3) and not i_R(2) and not i_R(1) and     i_R(0) and i_x17(i)) or
      (    i_R(4) and not i_R(3) and not i_R(2) and     i_R(1) and not i_R(0) and i_x18(i)) or
      (    i_R(4) and not i_R(3) and not i_R(2) and     i_R(1) and     i_R(0) and i_x19(i)) or
      (    i_R(4) and not i_R(3) and     i_R(2) and not i_R(1) and not i_R(0) and i_x20(i)) or
      (    i_R(4) and not i_R(3) and     i_R(2) and not i_R(1) and     i_R(0) and i_x21(i)) or
      (    i_R(4) and not i_R(3) and     i_R(2) and     i_R(1) and not i_R(0) and i_x22(i)) or
      (    i_R(4) and not i_R(3) and     i_R(2) and     i_R(1) and     i_R(0) and i_x23(i)) or
      (    i_R(4) and     i_R(3) and not i_R(2) and not i_R(1) and not i_R(0) and i_x24(i)) or
      (    i_R(4) and     i_R(3) and not i_R(2) and not i_R(1) and     i_R(0) and i_x25(i)) or
      (    i_R(4) and     i_R(3) and not i_R(2) and     i_R(1) and not i_R(0) and i_x26(i)) or
      (    i_R(4) and     i_R(3) and not i_R(2) and     i_R(1) and     i_R(0) and i_x27(i)) or
      (    i_R(4) and     i_R(3) and     i_R(2) and not i_R(1) and not i_R(0) and i_x28(i)) or
      (    i_R(4) and     i_R(3) and     i_R(2) and not i_R(1) and     i_R(0) and i_x29(i)) or
      (    i_R(4) and     i_R(3) and     i_R(2) and     i_R(1) and not i_R(0) and i_x30(i)) or
      (    i_R(4) and     i_R(3) and     i_R(2) and     i_R(1) and     i_R(0) and i_x31(i));
  end generate gen_decode;

end architecture;
 