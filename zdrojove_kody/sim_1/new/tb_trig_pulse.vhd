-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 10.4.2024 16:36:09 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_trig_pulse is
end tb_trig_pulse;

architecture tb of tb_trig_pulse is

    component trig_pulse
        Generic (
		  PULSE_WIDTH : integer := 1500 -- sirka pulzu: clk * PULSE_WIDTH
		);				      -- sirka pulzu 20 us pri clk = 100 MHz
        port (start    : in std_logic;
              trig_out : out std_logic;
              clk      : in std_logic;
              rst      : in std_logic);
    end component;

    signal start    : std_logic;
    signal trig_out : std_logic;
    signal clk      : std_logic;
    signal rst      : std_logic;

    constant TbPeriod : time := 10 ns; -- 100 MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : trig_pulse
    port map (start    => start,
              trig_out => trig_out,
              clk      => clk,
              rst      => rst);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        start <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        start <= '1';
        wait for TbPeriod;
        start <= '0';
        wait for 20 us;
        start <= '1';
        wait for TbPeriod;
        start <= '0';
        wait for 5 us;
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 2 us;
        start <= '1';
        wait for TbPeriod;
        start <= '0';
        wait for 20 us;
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_trig_pulse of tb_trig_pulse is
    for tb
    end for;
end cfg_tb_trig_pulse;