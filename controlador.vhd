library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlador is
port(
  i_opcode   : in std_logic_vector(6 downto 0);
  o_JUMP     : out std_logic;
  o_BRANCH   : out std_logic;
  o_MemToReg : out std_logic;
  o_MemWrite : out std_logic;
  o_AluSrc   : out std_logic;
  o_RegWrite : out std_logic;
  o_AluOP    : out std_logic_vector(1 downto 0);
  o_imm_src  : out std_logic_vector(1 downto 0)
);
end entity;

architecture arch_controlador of controlador is
begin
  process (i_opcode)
  begin
    -- Default values
    o_JUMP     <= '0';
    o_BRANCH   <= '0';
    o_MemToReg <= '0';
    o_MemWrite <= '0';
    o_AluSrc   <= '0';
    o_RegWrite <= '0';
    o_AluOP    <= "00";
    o_imm_src  <= "00";

    case i_opcode is
      -- Load Word
      when "0000011" => 
        o_JUMP     <= '0';
        o_BRANCH   <= '0';
        o_MemToReg <= '1';
        o_MemWrite <= '0';
        o_AluSrc   <= '1';
        o_RegWrite <= '1';
        o_AluOP    <= "00";
        o_imm_src  <= "00";

      -- FORMATO SW
      when "0100011" => 
        o_JUMP     <= '0';
        o_BRANCH   <= '0';
        o_MemToReg <= '0';
        o_MemWrite <= '1';
        o_AluSrc   <= '1';
        o_RegWrite <= '0';
        o_AluOP    <= "00";
        o_imm_src  <= "01";

      -- Formato R
      when "0110011" => 
        o_JUMP     <= '0';
        o_BRANCH   <= '0';
        o_MemToReg <= '0';
        o_MemWrite <= '0';
        o_AluSrc   <= '0';
        o_RegWrite <= '1';
        o_AluOP    <= "10";
        o_imm_src  <= "00";
		  
		-- FORMATO I
      when "0010011" => 
        o_JUMP     <= '0';
        o_BRANCH   <= '0';
        o_MemToReg <= '0';
        o_MemWrite <= '0';
        o_AluSrc   <= '1'; --i_B da ULA se torna o imediato
        o_RegWrite <= '1';
        o_AluOP    <= "11";
        o_imm_src  <= "00";

      -- Branches (B-type)
      when "1100011" => 
        o_JUMP     <= '0';
        o_BRANCH   <= '1';
        o_MemToReg <= '0';
        o_MemWrite <= '0';
        o_AluSrc   <= '0';
        o_RegWrite <= '0';
        o_AluOP    <= "01";
        o_imm_src  <= "10";

      -- JAL (J-type)
      when "1101111" => 
        o_JUMP     <= '1';
        o_BRANCH   <= '0';
        o_MemToReg <= '0';
        o_MemWrite <= '0';
        o_AluSrc   <= '0';
        o_RegWrite <= '0';
        o_AluOP    <= "00";
        o_imm_src  <= "11";

      when others => null;
    end case;
  end process;
end architecture;
