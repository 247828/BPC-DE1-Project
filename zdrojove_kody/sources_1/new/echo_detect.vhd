
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
		clk		    : in std_logic;
		rst		    : in std_logic;
		distance	: out STD_LOGIC_VECTOR (8 downto 0) -- result in cm in range 3 to 400 => 9 bits (512 values)
	);
end echo_detect;

architecture Behavioral of echo_detect is
	-- variables
	signal sig_count	: integer range 0 to 5828; -- := 0; --5828 (343 m/s) 5879 (340 m/s)
	signal sig_result	: integer range 0 to 500; -- := 0; -- result in cm
	signal count_enable	: std_logic; -- := '0';
	
	begin
		count : process(clk) is
			begin
				if (trig = '1') then
					count_enable <= '1';
				end if;
    
				if (rising_edge(clk)) then
					-- reset
					if (rst = '1') then
						count_enable <= '0';
						sig_count <= 0;
						sig_result <= 0;
						distance <= (others => '0');
                    
					elsif (count_enable = '1') then 
                
						if (echo_in = '0') then -- when echo wave comes reset process the
                    
							count_enable <= '0';
							distance <= std_logic_vector(to_unsigned(sig_result, 9));
							sig_result <= 0;
							sig_count <= 0;       
                        
						elsif (echo_in = '1' and sig_count > 5827) then --5827 (343 m/s) 5878 (340 m/s)
                    
							sig_result <= sig_result + 1;
							sig_count <= 0;
                        
						else    
							sig_count <= sig_count + 1; -- +1
					
						end if;
					end if;
				end if;
		end process;
end Behavioral;
