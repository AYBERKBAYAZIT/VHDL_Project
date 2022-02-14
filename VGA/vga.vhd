library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;	
entity vga is
  Port ( 
    clk100MHz : in std_logic;
    rst : in std_logic;  
    v_sync: out std_logic; 
    h_sync: out std_logic; 
    in_red: in std_logic_vector(1 downto 0);
    in_green: in std_logic_vector(1 downto 0);    
    in_blue: in std_logic_vector(1 downto 0);    
    red : out std_logic_vector(3 downto 0); 
    green : out std_logic_vector(3 downto 0); 
    blue : out std_logic_vector(3 downto 0);
    vert_hareket : in std_logic_vector(4 downto 0);
    hor_hareket : in std_logic_vector(4 downto 0)
  );
end vga;
 
architecture Behavioral of vga is
  constant V_TOPLAM : integer := 666;
  constant V_ACTIVE_VIDEO : integer := 600;
  constant V_FRONT_PORCH : integer := 37;
  constant V_SYNC_PULSE : integer := 6;
  constant V_BACK_PORCH : integer := 23;      
  constant H_TOPLAM : integer := 1040;
  constant H_ACTIVE_VIDEO : integer := 800;
  constant H_FRONT_PORCH : integer := 56;
  constant H_SYNC_PULSE : integer := 120;
  constant H_BACK_PORCH : integer := 64;     
  signal v_sayac : std_logic_vector(11 downto 0) := (others => '0');
  signal h_sayac : std_logic_vector(11 downto 0) := (others => '0');
  signal clk50MHz : std_logic;
component saat_frekans_bolucu
  generic(
    N : integer := 2
  );
  Port ( 
    in_clk : in std_logic;
    out_clk_2 : out std_logic                                                  
  );
end component;  
  	
begin
saat50MHz: saat_frekans_bolucu 
  Port map( 
    in_clk => clk100MHz,
    out_clk_2 => clk50MHz                                                     
  );
  v_sync <= '0' when (v_sayac >= V_ACTIVE_VIDEO + V_FRONT_PORCH and v_sayac < V_ACTIVE_VIDEO + V_FRONT_PORCH + V_SYNC_PULSE) else '1';
  h_sync <= '0' when (h_sayac >= H_ACTIVE_VIDEO + H_FRONT_PORCH and h_sayac < H_ACTIVE_VIDEO + H_FRONT_PORCH + H_SYNC_PULSE) else '1';
  red <= in_red & "00" when (v_sayac >= (0+conv_integer(vert_hareket)) and v_sayac < (100+conv_integer(vert_hareket)) and h_sayac >= (0+conv_integer(hor_hareket)) and h_sayac < (150+conv_integer(hor_hareket))) else "0000"; 
  green <= in_green & "00" when (v_sayac >= (0+conv_integer(vert_hareket)) and v_sayac < (100+conv_integer(vert_hareket)) and h_sayac >= (0+conv_integer(hor_hareket)) and h_sayac < (150+conv_integer(hor_hareket))) else "0000";
  blue <= in_blue & "00" when (v_sayac >= (0+conv_integer(vert_hareket)) and v_sayac < (100+conv_integer(vert_hareket)) and h_sayac >= (0+conv_integer(hor_hareket)) and h_sayac < (150+conv_integer(hor_hareket))) else "0000";
  	
  process(clk50MHz, rst)
  begin
    if rst = '1' then
      v_sayac <= (others => '0');
      h_sayac <= (others => '0');
    elsif rising_edge(clk50MHz) then
      if (h_sayac < H_TOPLAM) then
        h_sayac <= h_sayac + 1;
      else
        h_sayac <= (others => '0');
        if (v_sayac < V_TOPLAM) then
          v_sayac <= v_sayac + 1;
        else
          v_sayac <= (others => '0');
        end if;
      end if;
    end if;
  end process;
	
end Behavioral;