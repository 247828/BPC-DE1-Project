
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity us_detector is
    Port ( echo : in STD_LOGIC;
           trig : out STD_LOGIC;
           dev_num : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           segM : out STD_LOGIC_VECTOR (3 downto 0);
           segD : out STD_LOGIC_VECTOR (3 downto 0);
           segC : out STD_LOGIC_VECTOR (3 downto 0);
           rst : in STD_LOGIC;
           led : out STD_LOGIC);
end us_detector;
			
architecture Behavioral of us_detector is

    component clock_enable
        generic (
            PERIOD : integer
        );
        Port ( 
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pulse : out STD_LOGIC
        );
        end component;
        
        
         component simple_counter
        generic (
        N : integer 
    );
    
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (N-1 downto 0)
          );
        
        
end component;

signal sig_distance_bits : std_logic_vector (21 downto 0);
signal sig_counter_trig : std_logic;

begin

    trig_pulse : clock_enable
    generic map (
       PERIOD => 10000000 -- 100 ms
    )
    port map (
       clk => clk,
       rst => rst,
       pulse => trig
    );
    
     distance_c : simple_counter
    generic map (
       N => 22 -- 10 us
    )
    port map (
       clk => clk,
       rst => rst,
       en => sig_counter_trig,
       count => sig_distance_bits
       
    );



end Behavioral;
