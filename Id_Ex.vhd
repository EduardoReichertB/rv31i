library IEEE;	
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Id_Ex is
port(
	i_CLK               : in std_logic;
	i_RST               : in std_logic;
	i_Mem_to_Reg        : in std_logic;
	i_Branch            : in std_logic;
	i_Jump              : in std_logic;
	i_Alu_Src           : in std_logic;
	i_Reg_Write         : in std_logic;
	i_MemWrite          : in std_logic;
	i_AluOP             : in std_logic_vector(1 downto 0);
	i_addr_mais4        : in std_logic_vector(31 downto 0); --para somar com o endereço calculado para casos de branch e jump
	i_RD1               : in std_logic_vector(31 downto 0);
	i_RD2               : in std_logic_vector(31 downto 0);
	i_inteiro_extendido : in std_logic_vector(31 downto 0);
	i_Reg_Dst           : in std_logic_vector(4 downto 0);  --o registrador de destino
	i_funcao_ula        : in std_logic_vector(3 downto 0); --o funct7 mais o funct3 para o alucontrol
	o_Mem_to_Reg        : out std_logic;
	o_Branch            : out std_logic;
	o_Jump              : out std_logic;
	o_Alu_Src           : out std_logic;
	o_Reg_Write         : out std_logic;
	o_MemWrite          : out std_logic;
	o_AluOP             : out std_logic_vector(1 downto 0);
	o_addr_mais4        : out std_logic_vector(31 downto 0); --para somar com o endereço calculado para casos de branch e jump
	o_RD1               : out std_logic_vector(31 downto 0);
	o_RD2               : out std_logic_vector(31 downto 0);
	o_inteiro_extendido : out std_logic_vector(31 downto 0);
	o_Reg_Dst           : out std_logic_vector(4 downto 0);  --o registrador de destino
	o_funcao_ula        : out std_logic_vector(3 downto 0) --o funct7 mais o funct3 para o alucontrol
);
end entity;

architecture id_ex_arch of Id_Ex is

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

component registrador_1bit is
  port (
    i_CLK     : in std_logic; -- clock
	 i_RST     : in std_logic;
    i_D       : in std_logic; 
    o_S       : out std_logic 
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

REG_Branch : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Branch,
	o_S   => o_Branch
);

REG_Jump : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Jump,
	o_S   => o_Jump
);

REG_Alu_Src : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Alu_Src,
	o_S   => o_Alu_Src
);

REG_Reg_Write : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_Reg_Write,
	o_S   => o_Reg_Write
);

REG_MemWrite : registrador_1bit
port map(
	i_CLK => i_CLK,
	i_RST => i_RST,
	i_D   => i_MemWrite,
	o_S   => o_MemWrite
);

gen_Reg_AluOP : for i in 0 to 1 generate
  REG_AluOP: registrador_1bit
  port map(
    i_CLK      => i_CLK,
	 i_RST      => i_RST,
    i_D        => i_AluOP(i),
    o_S        => o_AluOP(i)
  );
end generate gen_Reg_AluOP;

REG_addr_mais4 : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_addr_mais4,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_addr_mais4
);

REG_RD1 : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_RD1,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_RD1
);

REG_RD2 : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_RD2,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_RD2
);

REG_Inteiro_Extendido : registrador
port map(
	i_CLK      => i_CLK,
	i_RST      => i_RST,	
	i_D        => i_inteiro_extendido,		
	i_Enable   => '1',
	i_Escrever => '1',
	o_S        => o_inteiro_extendido
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

gen_Reg_Funcao_Ula : for i in 0 to 3 generate
  REG_Funcao_Ula: registrador_1bit
  port map(
    i_CLK      => i_CLK,
	 i_RST      => i_RST,
    i_D        => i_funcao_ula(i),
    o_S        => o_funcao_ula(i)
  );
end generate gen_Reg_Funcao_Ula;

end architecture;
	