library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity extensor_sinal is
    port (
        i_instrucao : in  std_logic_vector(31 downto 0);
        i_imm_src   : in  std_logic_vector(1 downto 0);
        o_inteiro   : out std_logic_vector(31 downto 0)
    );
end extensor_sinal;

architecture arch_extensor of extensor_sinal is
    -- Campos de imediato dos diferentes formatos de instrução
    signal w_imm_I : std_logic_vector(11 downto 0);
    signal w_imm_S : std_logic_vector(11 downto 0);
    signal w_imm_B : std_logic_vector(12 downto 0);
    signal w_imm_J : std_logic_vector(20 downto 0);
begin
    -- Extração dos campos de imediato da instrução
    w_imm_I <= i_instrucao(31 downto 20);                                                                       -- Tipo I
    w_imm_S <= i_instrucao(31 downto 25) & i_instrucao(11 downto 7);                                            -- Tipo S
    w_imm_B <= i_instrucao(31) & i_instrucao(7) & i_instrucao(30 downto 25) & i_instrucao(11 downto 8) & '0';   -- Tipo B                         -- Tipo U
    w_imm_J <= i_instrucao(31) & i_instrucao(19 downto 12) & i_instrucao(20) & i_instrucao(30 downto 21) & '0'; -- Tipo J

    -- Processo de extensão de sinal
    process(i_imm_src, w_imm_I, w_imm_S, w_imm_B, w_imm_J)
    begin
        case i_imm_src is
            when "00" =>  -- Tipo I e LW
                o_inteiro <= (31 downto 12 => w_imm_I(11)) & w_imm_I;
                
            when "01" =>  -- Tipo S (SW)
                o_inteiro <= (31 downto 12 => w_imm_S(11)) & w_imm_S;
                
            when "10" =>  -- Tipo B (BEQ, BNE)
                o_inteiro <= (31 downto 13 => w_imm_B(12)) & w_imm_B;
                
            when "11" =>  -- Tipo J (JAL)
                o_inteiro <= (31 downto 21 => w_imm_J(20)) & w_imm_J;
                
            when others =>
                o_inteiro <= (others => '0');
        end case;
    end process;
	 
end architecture;
