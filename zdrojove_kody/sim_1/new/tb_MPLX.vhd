
-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 11.4.2024 16:19:11 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_MPLX is
end tb_MPLX;

architecture tb of tb_MPLX is

    component MPLX
        port (clk     : in std_logic;
              reset   : in std_logic;
              in_A    : in std_logic_vector (8 downto 0);
              in_Ad   : in std_logic_vector (2 downto 0);
              in_B    : in std_logic_vector (8 downto 0);
              in_Bd   : in std_logic_vector (2 downto 0);
              in_C    : in std_logic_vector (8 downto 0);
              in_Cd   : in std_logic_vector (2 downto 0);
              in_D    : in std_logic_vector (8 downto 0);
              in_Dd   : in std_logic_vector (2 downto 0);
              button  : in std_logic;
              dis_out : out std_logic_vector (8 downto 0);
              dev_out : out std_logic_vector (2 downto 0));
    end component;

    signal clk     : std_logic;
    signal reset   : std_logic;
    signal in_A    : std_logic_vector (8 downto 0);
    signal in_Ad   : std_logic_vector (2 downto 0);
    signal in_B    : std_logic_vector (8 downto 0);
    signal in_Bd   : std_logic_vector (2 downto 0);
    signal in_C    : std_logic_vector (8 downto 0);
    signal in_Cd   : std_logic_vector (2 downto 0);
    signal in_D    : std_logic_vector (8 downto 0);
    signal in_Dd   : std_logic_vector (2 downto 0);
    signal button  : std_logic;
    signal dis_out : std_logic_vector (8 downto 0);
    signal dev_out : std_logic_vector (2 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : MPLX
    port map (clk     => clk,
              reset   => reset,
              in_A    => in_A,
              in_Ad   => in_Ad,
              in_B    => in_B,
              in_Bd   => in_Bd,
              in_C    => in_C,
              in_Cd   => in_Cd,
              in_D    => in_D,
              in_Dd   => in_Dd,
              button  => button,
              dis_out => dis_out,
              dev_out => dev_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        in_A <= "111111111";
        in_Ad <= "100";
        in_B <= (others => '0');
        in_Bd <= (others => '0');
        in_C <= (others => '0');
        in_Cd <= (others => '0');
        in_D <= (others => '0');
        in_Dd <= (others => '0');
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
        -- Reset generation
        -- EDIT: Check that reset is really your reset signal
       

        

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
