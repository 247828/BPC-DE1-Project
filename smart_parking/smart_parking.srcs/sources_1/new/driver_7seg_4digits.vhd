----------------------------------------------------------
--
--! @title Driver for 4-digit 7-segment display
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2020 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for display driver
--
--             +-------------------+
--        -----|> clk              |
--        -----| rst            dp |-----
--             |          seg(6:0) |--/--
--        --/--| data0(3:0)        |  7
--        --/--| data1(3:0)        |
--        --/--| data2(3:0)        |
--        --/--| data3(3:0)        |
--          4  |           dig(3:0)|--/--
--        --/--| dp_vect(3:0)      |  4
--          4  +-------------------+
--
-- Inputs:
--   clk          -- Main clock
--   rst          -- Synchronous reset
--   dataX(3:0)   -- Data values for individual digits
--   dp_vect(3:0) -- Decimal points for individual digits
--
-- Outputs:
--   dp:          -- Decimal point for specific digit
--   seg(6:0)     -- Cathode values for individual segments
--   dig(3:0)     -- Common anode signals to individual digits
--
----------------------------------------------------------

entity driver_7seg_4digits is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    data0   : in    std_logic_vector(3 downto 0);
    data1   : in    std_logic_vector(3 downto 0);
    data2   : in    std_logic_vector(3 downto 0);
    data3   : in    std_logic_vector(3 downto 0);
    dp_vect : in    std_logic_vector(3 downto 0);
    dp      : out   std_logic;
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(7 downto 0)
  );
  
end entity driver_7seg_4digits;


----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_4digits is

component cnt_up_down
generic (
    N_BITS : natural --! Default number of counter bits
  );
  port (
    clk    : in    std_logic; --! Main clock
    rst    : in    std_logic; --! Synchronous reset
    en     : in    std_logic; --! Enable input
    cnt_up : in    std_logic; --! Direction of the counter (1 @ UP, 0 @ DOWN)
    cnt    : out   std_logic_vector(N_BITS - 1 downto 0) --! Counter value
  );
end component;

component bin2seg
Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

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

  -- Internal clock enable
  signal sig_en_4ms : std_logic;

  -- Internal 2-bit counter for multiplexing 4 digits
  signal sig_cnt_2bit : std_logic_vector(1 downto 0);

  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  clk_en0 : clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 4
      -- FOR IMPLEMENTATION, CHANGE THIS VALUE TO 400,000
      -- 4      @ 4 ns
      -- 400000 @ 4 ms
      PERIOD => 400000
    )
    port map (
      clk => clk, 
      rst => rst, 
      pulse  => sig_en_4ms
    );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity performs
  -- a 2-bit down counter
  --------------------------------------------------------
  bin_cnt0 : cnt_up_down
generic map (
    N_BITS => 2
  )
  port map (
    clk => clk, 
    rst => rst,  
    en => sig_en_4ms, 
    cnt_up => '1',
    cnt => sig_cnt_2bit  
  );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity performs
  -- a 7-segment display decoder
  --------------------------------------------------------
  hex2seg : bin2seg
    port map (
      clear => rst,
      bin   => sig_hex,
      seg   => seg
    );

  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_hex <= data0;
        dp      <= dp_vect(0);
        dig     <= "11111110";
      else

        case sig_cnt_2bit is

          when "11" =>
            sig_hex <= data3;
            dp      <= dp_vect(3);
            dig     <= "11101111";

          when "10" =>
            -- DEFINE ALL OUTPUTS FOR "10" HERE
            sig_hex <= data2;
            dp      <= dp_vect(2);
            dig <= "11111011";
            
          when "01" =>
            -- DEFINE ALL OUTPUTS FOR "01" HERE
            sig_hex <= data1;
            dp      <= dp_vect(1); 
            dig <= "11111101";
            
          when others =>
            -- DEFINE ALL OUTPUTS FOR "00" HERE
            sig_hex <= (others => '0');
            
        end case;

      end if;
    end if;

  end process p_mux;

end architecture behavioral;