
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port ( 
        -- JC konektor - vystupy trig HC-SR04
        JC0       : out STD_LOGIC;
        JC1       : out STD_LOGIC;
        JC2       : out STD_LOGIC;
        JC3       : out STD_LOGIC;
        -- JD konektor - vstupy echo HC-SR04
		JD0       : in STD_LOGIC;
		JD1       : in STD_LOGIC;
		JD2       : in STD_LOGIC;
		JD3       : in STD_LOGIC;
		-- hodiny, reset, prepinanie
		CLK100MHZ : in STD_LOGIC;
		BTNC      : in STD_LOGIC; -- reset
		LED       : out STD_LOGIC_VECTOR (3 downto 0)
	); 
end top_level;

architecture Behavioral of top_level is
    -- komponenty
    component clock_enable
        generic (
			PERIOD : INTEGER
		);
		port (
			clk      : in STD_LOGIC;
			rst      : in STD_LOGIC;
			pulse    : out STD_LOGIC);
	end component;	

	component trig_pulse
        generic (
			PULSE_WIDTH : INTEGER
		);
		port ( 
			start        : in STD_LOGIC;
			trig_out     : out STD_LOGIC; -- := '0';
			clk          : in STD_LOGIC;
			rst          : in STD_LOGIC
		);
	end component;
			
	component echo_detect
	    generic (
            DEVICE_NUMBER : INTEGER;
            MIN_DISTANCE : INTEGER
        );
		port ( 
			trig     : in STD_LOGIC;
			echo_in  : in STD_LOGIC;
			clk      : in STD_LOGIC;
			rst      : in STD_LOGIC;
			dev_num  : out STD_LOGIC_VECTOR (2 downto 0);
			distance : out STD_LOGIC_VECTOR (11 downto 0);
			status   : out STD_LOGIC
		);
	end component;
	-- lokalne signaly			
	signal sig_cycle_pulse : STD_LOGIC;
	signal sig_trig        : STD_LOGIC;
	-- vystupy z komponentu echo - vzdialenosti
	signal sig_d1          : STD_LOGIC_VECTOR(8 downto 0);
	signal sig_d2          : STD_LOGIC_VECTOR(8 downto 0);
	signal sig_d3          : STD_LOGIC_VECTOR(8 downto 0);
	signal sig_d4          : STD_LOGIC_VECTOR(8 downto 0);
	-- cislo zariadenia
	signal sig_dev1        : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_dev2        : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_dev3        : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_dev4        : STD_LOGIC_VECTOR(2 downto 0);
    -- vystup z multiplexoru
    --signal sig_bin_distance : STD_LOGIC_VECTOR(8 downto 0);
    --signal sig_dev          : STD_LOGIC_VECTOR(2 downto 0);
    -- vystupy s prevodnika
    --signal sig_bcd_distance : STD_LOGIC_VECTOR(11 downto 0);

	begin
        -- instanciacia
        -- generator periodickeho pulzu na cykly
        cycle_gen : clock_enable
			generic map (
				PERIOD => 100_000_000 -- 100 ms cyklus 
			)
			port map (
				clk     => CLK100MHZ,
				rst     => BTNC,
				pulse   => sig_cycle_pulse
			);
		-- generator jednorazoveho pulzu
		trig_puls_gen : trig_pulse
			generic map (
				PULSE_WIDTH => 2000 -- 20 us pulz pre trig (min. 10 us)
			)
			port map (
				start       => sig_cycle_pulse, 
				trig_out    => sig_trig,
				clk         => CLK100MHZ,		
				rst         => BTNC		
			);
		-- vstupy od echo
		echo_1 : echo_detect
            generic map (
                DEVICE_NUMBER => 1,
                MIN_DISTANCE => 100
            )
            port map (
				trig        => sig_trig,
				echo_in     => JD0,
				clk         => CLK100MHZ,   
				rst         => BTNC,
				dev_num     => sig_dev1,
				distance    => sig_d1,
				status      => LED(0)
			);
	    echo_2 : echo_detect
            generic map (
                DEVICE_NUMBER => 2,
                MIN_DISTANCE => 100
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD1,
				clk         => CLK100MHZ,   
				rst         => BTNC,
				dev_num     => sig_dev2,
				distance    => sig_d2,
				status      => LED(1)
			);
	    echo_3 : echo_detect
	        generic map (
                DEVICE_NUMBER => 3,
                MIN_DISTANCE => 100
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD2,
				clk         => CLK100MHZ,   
				rst         => BTNC,
				dev_num     => sig_dev3,
				distance    => sig_d3,
				status      => LED(2)
			);
	    echo_4 : echo_detect
	        generic map (
                DEVICE_NUMBER => 4,
                MIN_DISTANCE => 100
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD3,
				clk         => CLK100MHZ,   
				rst         => BTNC,
				dev_num     => sig_dev4,
				distance    => sig_d4,
				status      => LED(3)
			);			
		-- priradenie vnutorych signalov	
		JC0 <= sig_trig;	-- vystup trig signalu
		JC1 <= sig_trig;	-- vystup trig signalu	
		JC2 <= sig_trig;	-- vystup trig signalu	
		JC3 <= sig_trig;	-- vystup trig signalu		
end Behavioral;