-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 10.4.2024 18:22:19 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_echo_detect is
end tb_echo_detect;

architecture tb of tb_echo_detect is

    component echo_detect
        port (trig     : in std_logic;
              echo_in  : in std_logic;
              clk      : in std_logic;
              rst      : in std_logic;
              distance : out std_logic_vector (8 downto 0));
    end component;

    signal trig     : std_logic;
    signal echo_in  : std_logic;
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal distance : std_logic_vector (8 downto 0);

    constant TbPeriod : time := 10 ns; -- 100 MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : echo_detect
    port map (trig     => trig,
              echo_in  => echo_in,
              clk      => clk,
              rst      => rst,
              distance => distance);

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
        wait for 150 us;
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
        wait for 150 us;
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