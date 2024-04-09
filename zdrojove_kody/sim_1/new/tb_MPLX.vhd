-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 9.4.2024 13:26:10 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_MPLX is
end tb_MPLX;

architecture tb of tb_MPLX is

    component MPLX
        port (clk    : in std_logic;
              reset  : in std_logic;
              in_A   : in std_logic;
              in_B   : in std_logic;
              in_C   : in std_logic;
              in_D   : in std_logic;
              button : in std_logic;
              echo   : out std_logic);
    end component;

    signal clk    : std_logic;
    signal reset  : std_logic;
    signal in_A   : std_logic;
    signal in_B   : std_logic;
    signal in_C   : std_logic;
    signal in_D   : std_logic;
    signal button : std_logic;
    signal echo   : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : MPLX
    port map (clk    => clk,
              reset  => reset,
              in_A   => in_A,
              in_B   => in_B,
              in_C   => in_C,
              in_D   => in_D,
              button => button,
              echo   => echo);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        in_A <= '0';
        in_B <= '0';
        in_C <= '1';
        in_D <= '1';
        button <= '0';
        wait for 1*TbPeriod;

        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 1*TbPeriod;
        button <= '0';
        wait for 1*TbPeriod;
        button <= '1';
        wait for 10*TbPeriod;
        reset <= '1';
        wait for 100*TbPeriod;
        
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_MPLX of tb_MPLX is
    for tb
    end for;
end cfg_tb_MPLX;
