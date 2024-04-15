-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 12.4.2024 08:30:20 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_seven_seg_disp_drv is
end tb_seven_seg_disp_drv;

architecture tb of tb_seven_seg_disp_drv is

    component seven_seg_disp_drv
        port (in_data0 : in std_logic_vector (3 downto 0);
              in_data1 : in std_logic_vector (3 downto 0);
              in_data2 : in std_logic_vector (3 downto 0);
              in_data3 : in std_logic_vector (3 downto 0);
              in_data4 : in std_logic_vector (3 downto 0);
              in_data5 : in std_logic_vector (3 downto 0);
              in_data6 : in std_logic_vector (3 downto 0);
              in_data7 : in std_logic_vector (3 downto 0);
              in_dp    : in std_logic_vector (7 downto 0);
              seg      : out std_logic_vector (6 downto 0);
              dp       : out std_logic;
              an       : out std_logic_vector (7 downto 0);
              clk      : in std_logic;
              rst      : in std_logic);
    end component;

    signal in_data0 : std_logic_vector (3 downto 0);
    signal in_data1 : std_logic_vector (3 downto 0);
    signal in_data2 : std_logic_vector (3 downto 0);
    signal in_data3 : std_logic_vector (3 downto 0);
    signal in_data4 : std_logic_vector (3 downto 0);
    signal in_data5 : std_logic_vector (3 downto 0);
    signal in_data6 : std_logic_vector (3 downto 0);
    signal in_data7 : std_logic_vector (3 downto 0);
    signal in_dp    : std_logic_vector (7 downto 0);
    signal seg      : std_logic_vector (6 downto 0);
    signal dp       : std_logic;
    signal an       : std_logic_vector (7 downto 0);
    signal clk      : std_logic;
    signal rst      : std_logic;

    constant TbPeriod : time := 10 ns; -- Clock 100MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : seven_seg_disp_drv
    port map (in_data0 => in_data0,
              in_data1 => in_data1,
              in_data2 => in_data2,
              in_data3 => in_data3,
              in_data4 => in_data4,
              in_data5 => in_data5,
              in_data6 => in_data6,
              in_data7 => in_data7,
              in_dp    => in_dp,
              seg      => seg,
              dp       => dp,
              an       => an,
              clk      => clk,
              rst      => rst);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in_data0 <= "0001";
        in_data1 <= "0010";
        in_data2 <= "0100";
        in_data3 <= "1001";
        in_data4 <= "0010";
        in_data5 <= "0100";
        in_data6 <= "1001";
        in_data7 <= "1000";
        in_dp <= "01010101";

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 600 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 200 ns;
        
        -- EDIT Add stimuli here

        
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_seven_seg_disp_drv of tb_seven_seg_disp_drv is
    for tb
    end for;
end cfg_tb_seven_seg_disp_drv;