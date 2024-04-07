
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trig_pulse is
	Generic (
		PULSE_WIDTH : integer := 10_000_000 -- 10 ns * PULSE_WIDTH pulse width
	);

	Port ( 
		start		: in STD_LOGIC;
		trig_out	: out STD_LOGIC; -- := '0';
		clk		: in std_logic;
		rst		: in std_logic
	);
end trig_pulse;

architecture Behavioral of trig_pulse is
	-- variables
	signal sig_count : integer range 0 to 10_000_000; -- := 0;
	signal start_pulse : std_logic; -- := '0';
	
    begin
	pulse : process(clk) is
		begin
			if (start = '1') then
				start_pulse <= '1';
			end if;
    
			if (rising_edge(clk)) then
				if (rst = '1') then
					trig_out <= '0';
					start_pulse <= '0';
					sig_count <= 0;
			elsif (start_pulse = '1') then -- send 100ns trig
				if (sig_count = PULSE_WIDTH) then -- (10 * PULSE_WIDTH)ns trig is completed, reset tmp signals for the new calculation
					trig_out <= '0';
					start_pulse <= '0';
					sig_count <= 0;
				else
					trig_out <= '1';
					sig_count <= sig_count + 1;
				end if;
			end if;
		end if;
	end process;
end Behavioral;
