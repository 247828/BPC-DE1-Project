-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 14.4.2024 19:47:46 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_echo_detect is
end tb_echo_detect;

architecture tb of tb_echo_detect is

    component echo_detect
        generic (
            DEVICE_NUMBER : INTEGER := 2;
            MIN_DISTANCE : INTEGER := 50
        );
        port (trig     : in std_logic;
              echo_in  : in std_logic;
              clk      : in std_logic;
              rst      : in std_logic;
              dev_num  : out std_logic_vector (2 downto 0);
              distance : out std_logic_vector (8 downto 0);
              status   : out std_logic);
    end component;

    signal trig     : std_logic;
    signal echo_in  : std_logic;
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal dev_num  : std_logic_vector (2 downto 0);
    signal distance : std_logic_vector (8 downto 0);
    signal status   : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : echo_detect
    port map (trig     => trig,
              echo_in  => echo_in,
              clk      => clk,
              rst      => rst,
              dev_num  => dev_num,
              distance => distance,
              status   => status);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        trig <= '0';
        echo_in <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        trig <= '1';
        wait for 20 ns;
        trig <= '0';
        wait for 20 ns;
        echo_in <= '1';
        wait for 2 ms;
        echo_in <= '0';
        wait for 20 ns;
        trig <= '1';
        wait for 20 ns;
        trig <= '0';
        wait for 20 ns;
        echo_in <= '1';
        wait for 50 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        echo_in <= '0';
        wait for 20 ns;
        trig <= '1';
        wait for 20 ns;
        trig <= '0';
        wait for 20 ns;
        echo_in <= '1';
        wait for 20 ms;
        echo_in <= '0';
        wait for 20 ns;
        wait for 100 * TbPeriod;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_echo_detect of tb_echo_detect is
    for tb
    end for;
end cfg_tb_echo_detect;
