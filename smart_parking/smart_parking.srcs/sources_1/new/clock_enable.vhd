
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_enable is
    generic (
        PERIOD : integer := 10_000_000
    );
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pulse : out STD_LOGIC
    );
end clock_enable;

architecture Behavioral of clock_enable is
    -- vnutorne signaly a konstanty
    constant BITS_NEEDED : integer := integer(ceil(log2(real(PERIOD + 1)))); -- ceil() zaokruhli nahor
    signal sig_count : std_logic_vector(BITS_NEEDED - 1 downto 0);

begin
    --! Generate clock enable signal. By default, enable signal
    --! is low and generated pulse is always one clock long.
    p_clk_enable : process (clk) is
    begin
        -- Synchronny proces
        if (rising_edge(clk)) then
            -- ak je reset v urovni HIGH, tak
            if (rst = '1') then
                -- vynuluj vsetky bity v lokalnom pocitadlu
                sig_count <= (others => '0'); -- others - priradi vstkemu co nastavim
                -- Nastav vystupny pulz na uroven LOW
                pulse <= '0';
            -- ak nie, tak ak je pocitadlo sig_count rovne PERIOD-1, tak
            elsif (sig_count = PERIOD-1) then
                -- vynuluj vsetky bity v lokalnom pocitadlu
                 sig_count <= (others => '0');
                -- nastav uroven vystupneho pulzu na HIG
                pulse <= '1';
            -- ak ani toto, tak
            else 
                -- Zvys lokalne pocitadlo o jedna
                sig_count <= sig_count + 1;
                -- Nastav vystupny pulz na LOW
                pulse <= '0';
            -- kazdy "if" musi koncit "end if"
            end if;
        end if;

    end process p_clk_enable;

end architecture behavioral;