library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_enable is
	generic (
		PERIOD : INTEGER := 10_000_000
	);
	port ( 
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		pulse : out STD_LOGIC
	);
end clock_enable;

architecture Behavioral of clock_enable is
    -- vnutorne signaly a konstanty
    constant BITS_NEEDED : INTEGER := integer(ceil(log2(real(PERIOD + 1)))); -- ceil() zaokruhli nahor
    signal sig_count : STD_LOGIC_VECTOR(BITS_NEEDED - 1 downto 0);

begin
	p_clk_enable : process (clk) is
	begin
		-- Synchronny proces
		if (rising_edge(clk)) then
			-- ak je reset v urovni HIGH, tak
			if (rst = '1') then
				-- vynuluj vsetky bity v lokalnom pocitadlu
				sig_count <= (others => '0'); -- others - priradi vsetkemu co nastavim
				pulse <= '0'; -- Nastav vystupny pulz na uroven LOW
		    -- ak nie, tak ak je pocitadlo sig_count rovne PERIOD-1, tak
			elsif (sig_count = PERIOD-1) then
				-- vynuluj vsetky bity v lokalnom pocitadlu
				sig_count <= (others => '0');
					-- nastav uroven vystupneho pulzu na HIG
					pulse <= '1';
				-- ak ani toto, tak
			else 
				sig_count <= sig_count + 1; -- Zvys lokalne pocitadlo o jedna
				pulse <= '0'; -- Nastav vystupny pulz na LOW
			end if;
		end if;
	end process p_clk_enable;
end architecture behavioral;
