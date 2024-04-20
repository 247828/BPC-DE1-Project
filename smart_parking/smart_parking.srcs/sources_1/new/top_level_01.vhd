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
		BTNC      : in STD_LOGIC; -- prepinanie multiplexoru
		BTND      : in STD_LOGIC; -- reset aktivny v HIGH ('1')
		-- 7 segmentovy displej
		CA        : out STD_LOGIC; 
		CB        : out STD_LOGIC;
		CC        : out STD_LOGIC;
		CD        : out STD_LOGIC;
		CE        : out STD_LOGIC;
		CF        : out STD_LOGIC;
		CG        : out STD_LOGIC;
		AN        : out STD_LOGIC_VECTOR (7 downto 0);
		DP        : out STD_LOGIC; -- desatinna ciarka
		-- LED-ky - zobrazenie obsadenosti parkovacieho miesta
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
			distance : out STD_LOGIC_VECTOR (8 downto 0);
			status   : out STD_LOGIC
		);
	end component;
	-- multiplexor vystupnych signalov
	component mplx
	    port ( 
            clk     : in STD_LOGIC;
            reset   : in STD_LOGIC;
            in_A    : in STD_LOGIC_VECTOR(8 downto 0);
            in_Ad   : in STD_LOGIC_VECTOR(2 downto 0);
            in_B    : in STD_LOGIC_VECTOR(8 downto 0);
            in_Bd   : in STD_LOGIC_VECTOR(2 downto 0);
            in_C    : in STD_LOGIC_VECTOR(8 downto 0);
            in_Cd   : in STD_LOGIC_VECTOR(2 downto 0);
            in_D    : in STD_LOGIC_VECTOR(8 downto 0);
            in_Dd   : in STD_LOGIC_VECTOR(2 downto 0);
            button  : in STD_LOGIC;
            dis_out : out STD_LOGIC_VECTOR(8 downto 0);
            dev_out : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;
    -- prevodnik bin to bcd
    component bin2bcd9
        port ( 
            in_bin : in STD_LOGIC_VECTOR (8 downto 0);
            out_bcd : out STD_LOGIC_VECTOR (10 downto 0));
    end component;
	-- ovladac 7 segmentovych displejov
    component seven_seg_disp_drv
        port ( 
            clk                 : in STD_LOGIC;
            rst                 : in STD_LOGIC;
            in_data0            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data1            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data2            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data3            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data4            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data5            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data6            : in STD_LOGIC_VECTOR (3 downto 0);
            in_data7            : in STD_LOGIC_VECTOR (3 downto 0);
            in_dp               : in STD_LOGIC_VECTOR (7 downto 0);
            in_visible_digits   : in STD_LOGIC_VECTOR(7 downto 0);
            seg                 : out STD_LOGIC_VECTOR (6 downto 0);
            dp                  : out STD_LOGIC;
            an                  : out STD_LOGIC_VECTOR (7 downto 0)   
    );
    end component;
    component debounce
        port (
        clk      : in    std_logic; --! Main clock
        rst      : in    std_logic; --! High-active synchronous reset
        en       : in    std_logic; --! Clock enable input
        bouncey  : in    std_logic; --! Bouncey button input
        clean    : out   std_logic; --! Debounced button output
        pos_edge : out   std_logic; --! Positive-edge (rising) impulse
        neg_edge : out   std_logic  --! Negative-edge (falling) impulse
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
    signal sig_bin_distance : STD_LOGIC_VECTOR(8 downto 0);
    signal sig_dev          : STD_LOGIC_VECTOR(2 downto 0);
    -- vystupy s prevodnika
    signal sig_bcd_distance : STD_LOGIC_VECTOR(11 downto 0);
    signal sig_clean_button : STD_LOGIC;

	begin
        -- instanciacia
        -- generator periodickeho pulzu na cykly
        cycle_gen : clock_enable
			generic map (
				PERIOD => 20_000_000 -- 100 ms cyklus
			)
			port map (
				clk     => CLK100MHZ,
				rst     => BTND,
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
				rst         => BTND		
			);
		-- vstupy od echo
		echo_1 : echo_detect
            generic map (
                DEVICE_NUMBER => 1,
                MIN_DISTANCE => 20
            )
            port map (
				trig        => sig_trig,
				echo_in     => JD0,
				clk         => CLK100MHZ,   
				rst         => BTND,
				dev_num     => sig_dev1,
				distance    => sig_d1,
				status      => LED(0)
			);
	    echo_2 : echo_detect
            generic map (
                DEVICE_NUMBER => 2,
                MIN_DISTANCE => 20
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD1,
				clk         => CLK100MHZ,   
				rst         => BTND,
				dev_num     => sig_dev2,
				distance    => sig_d2,
				status      => LED(1)
			);
			echo_3 : echo_detect
            generic map (
                DEVICE_NUMBER => 3,
                MIN_DISTANCE => 20
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD2,
				clk         => CLK100MHZ,   
				rst         => BTND,
				dev_num     => sig_dev3,
				distance    => sig_d3,
				status      => LED(2)
			);
			echo_4 : echo_detect
            generic map (
                DEVICE_NUMBER => 4,
                MIN_DISTANCE => 20
            )
			port map (
				trig        => sig_trig,
				echo_in     => JD3,
				clk         => CLK100MHZ,   
				rst         => BTND,
				dev_num     => sig_dev4,
				distance    => sig_d4,
				status      => LED(3)
			);

		-- multiplexor
		multiplexer : mplx
            port map ( 
                clk     => CLK100MHZ,
                reset   => BTND,
                in_A    => sig_d1,
                in_Ad   => sig_dev1,
                in_B    => sig_d2,
                in_Bd   => sig_dev2,
                in_C    => sig_d3,
                in_Cd   => sig_dev3,
                in_D    => sig_d4,
                in_Dd   => sig_dev4,
                button  => BTNC,
                dis_out => sig_bin_distance,
                dev_out => sig_dev
            ); 
        dbounc : debounce
            port map   (         
                clk      => CLK100MHZ,
                rst      =>BTND,
                en => sig_trig,     
                bouncey => BTNC, 
                clean    => open,
                pos_edge => sig_clean_button,
                neg_edge => open
            );
		-- dekoder binary -> BCD
		decoder : bin2bcd9
        port map( 
            in_bin => sig_bin_distance,
            out_bcd => sig_bcd_distance(10 downto 0)
         );
		-- 7 segmentove displeje
		display : seven_seg_disp_drv
            port map (
                clk                     => CLK100MHZ,
                rst                     => BTND,
                in_data0                => sig_bcd_distance(3 downto 0),
                in_data1                => sig_bcd_distance(7 downto 4),
                in_data2                => sig_bcd_distance(11 downto 8),
                in_data3                => b"0000",
                in_data4(2 downto 0)    => sig_dev,
                in_data4(3)             => '0',
                in_data5                => b"0000",
                in_data6                => b"0000",
                in_data7                => b"0000",
                in_dp                   => b"1111_1011",
                in_visible_digits       => b"0001_0111",
                dp                      => DP,
                an                      => AN,
                seg(6)	                => CA,
				seg(5)                  => CB,
				seg(4)                  => CC,
				seg(3)                  => CD, 
				seg(2)                  => CE,
				seg(1)                  => CF,
				seg(0)                  => CG
		   );
		-- priradenie vnutorych signalov	
		JC0 <= sig_trig;	-- vystup trig signalu
		JC1 <= sig_trig;	-- vystup trig signalu	
		JC2 <= sig_trig;	-- vystup trig signalu	
		JC3 <= sig_trig;	-- vystup trig signalu		
		sig_bcd_distance(11) <= '0';

end Behavioral;