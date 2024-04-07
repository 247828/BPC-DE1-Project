
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity echo_detect is
	Port ( 
		trig		: in STD_LOGIC;
		echo_in		: in STD_LOGIC;
		clk		: in std_logic;
		rst		: in std_logic;
		distance	: out STD_LOGIC_VECTOR (8 downto 0) -- vysledok v cm (snima od cca 2 to 400 cm => cca 400 hodnot => potrebnych 9 bitov 
	);
end echo_detect;

architecture Behavioral of echo_detect is
        -- konstanty
        constant ONE_CM         : integer :=  5827; -- (343 m/s (20˚C)) 5878 (340 m/s (15˚C)) potrebny pocet clk cyklov na 1 cm (clk = 100 MHz)
	-- vnutorne signaly
	signal sig_count	: integer range 0 to ONE_CM + 1; -- := 0; vnutorne pocitadlo
	signal sig_result	: integer range 0 to 500; -- := 0; -- vysledok v cm
	signal count_enable	: std_logic; -- := '0';
	
	begin
		count : process(clk) is
			begin
				if (trig = '1') then - vyslanie trigovacieho pulzu - zaciatok pocitania
					count_enable <= '1';
				end if;
    
				if (rising_edge(clk)) then -- kazdu nabeznu hranu hodinoveho signalu
					if (rst = '1') then -- resetovanie 
						count_enable <= '0';
						sig_count <= 0;
						sig_result <= 0;
						distance <= (others => '0');
					-- pocitanie, kym nedorazila vlna naspat
					elsif (count_enable = '1') then                 
						if (echo_in = '1') then -- prichod odrazenej vlny naspat - vynulovanie signalov a poslanie vysledku
							count_enable <= '0';
							distance <= std_logic_vector(to_unsigned(sig_result, 9));
							sig_result <= 0;
							sig_count <= 0;       
						elsif (echo_in = '1' and sig_count > ONE_CM) then -- ak sa napocitalo tolko cyklov odpovedajucich 1 cm
							sig_result <= sig_result + 1; -- pripocitaj 1 cm k vysledku
							sig_count <= 0; -- vynuluj vnutorne pocitadlo
						else
							sig_count <= sig_count + 1;
						end if;
					end if;
				end if;
			end process;

end Behavioral;
