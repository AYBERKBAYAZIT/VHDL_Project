library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
	
entity saat_frekans_bolucu is
  generic(
    N : integer := 2
  );
  Port ( 
    in_clk : in std_logic;
    out_clk_2 : out std_logic
  );
end saat_frekans_bolucu;
	
architecture Behavioral of saat_frekans_bolucu is
  signal r_sayac : std_logic_vector(1 downto 0) := (others => '0');
begin
  out_clk_2  <= r_sayac(0);
  process(in_clk)
  begin
    if rising_edge(in_clk) then
      r_sayac <= r_sayac + 1;                        
    end if;
  end process;
end Behavioral;
