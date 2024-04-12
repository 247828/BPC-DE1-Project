library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    port ( 
        -- JC konektor - vystupy trig HC-SR04
        JC0       : out STD_LOGIC;
        -- JD konektor - vstupy echo HC-SR04
		JD0       : in STD_LOGIC;
		CLK100MHZ : in STD_LOGIC;
		BTNC      : in STD_LOGIC; -- reset aktivny v HIGH ('1')
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
		-- zobrazenie vysledku v cm na LED-ky v binarnom kode
		LED       : out STD_LOGIC_VECTOR (8 downto 0)
	); 
end top_level;

architecture Behavioral of top_level is
    -- pridanie komponentov
    component clock_enable
        generic (
			PERIOD : integer
		);
		port (
			clk      : in STD_LOGIC;
			rst      : in STD_LOGIC;
			pulse    : out STD_LOGIC);
	end component;	

	component trig_pulse
		generic (
			PULSE_WIDTH : integer -- 10 ns * PULSE_WIDTH dlzka pulzu
		);
		port ( 
			start        : in STD_LOGIC;
			trig_out     : out STD_LOGIC; -- := '0';
			clk          : in std_logic;
			rst          : in std_logic
		);
	end component;
			
	component echo_detect
		port ( 
			trig     : in STD_LOGIC;
			echo_in  : in STD_LOGIC;
			clk      : in std_logic;
			rst      : in std_logic;
			distance : out STD_LOGIC_VECTOR (8 downto 0)
		);
	end component;
			
	component bin2seg
		port ( 
			clear    : in STD_LOGIC;
			bin      : in STD_LOGIC_VECTOR (3 downto 0);
			seg      : out STD_LOGIC_VECTOR (6 downto 0));
	end component;
	
	component bin2bcd9
		Port ( in_bin : in STD_LOGIC_VECTOR (8 downto 0);
           out_bcd : out STD_LOGIC_VECTOR (11 downto 0));
	end component;
	
	component driver_7seg_4digits
        port (
            clk     : in    std_logic;
            rst     : in    std_logic;
            data0   : in    std_logic_vector(3 downto 0);
            data1   : in    std_logic_vector(3 downto 0);
            data2   : in    std_logic_vector(3 downto 0);
            data3   : in    std_logic_vector(3 downto 0);
            dp_vect : in    std_logic_vector(3 downto 0);
            dp      : out   std_logic;
            seg     : out   std_logic_vector(6 downto 0);
            dig     : out   std_logic_vector(7 downto 0)
        );
	end component;
	

	-- lokalne signaly			
	signal sig_start       : std_logic;
	signal sig_trig        : std_logic;
	signal sig_distance    : std_logic_vector(8 downto 0);
	signal sig_seg         : std_logic_vector(3 downto 0);
    signal selected_d : std_logic_vector(8 downto 0);
    signal sig_2seg : std_logic_vector (11 downto 0);
    signal sig_dev_num: std_logic_vector(3 downto 0);
    
	begin
        -- instanciacia
        -- generator periodickeho pulzu na cykly
		cycle_gen : clock_enable
			generic map (
				PERIOD => 10_000_000 -- 100 ms cyklus 
			)
			port map (
				clk     => CLK100MHZ,
				rst     => BTNC,
				pulse   => sig_start
			);
		-- generator jednorazoveho pulzu
		trig_puls_gen : trig_pulse
			generic map (
				PULSE_WIDTH => 2000 -- 20 us pulz pre trig (min. 10 us)
			)
			port map (
				start       => sig_start, 
				trig_out    => sig_trig,	 
				clk         => CLK100MHZ,		
				rst         => BTNC		
			);
		-- vstupy od echo
		echo_1 : echo_detect
			port map (
				trig        => sig_trig,
				echo_in     => JD0,
				clk         => CLK100MHZ,   
				rst         => BTNC,  
				distance    => sig_distance 
			);
		-- 7 segmentovy displej
		display : bin2seg
			port map (
				clear	=> '0',
				bin     => sig_seg(3 downto 0),
				seg(6)	=> CA,
				seg(5)	=> CB,
				seg(4)	=> CC,
				seg(3)	=> CD, 
				seg(2)	=> CE,
				seg(1)	=> CF,
				seg(0)	=> CG
			);
			
		-- multiplexor
		displaj2 : driver_7seg_4digits 
		  port map (
            clk => CLK100MHZ,
            rst => BTNC, 
            data0 => sig_2seg(3 downto 0),  
            data1 => sig_2seg(7 downto 4),    
            data2 => sig_2seg(11 downto 8),    
            data3 => sig_dev_num,  
            dp_vect => "0100",
            dp => DP,     
            seg => sig_seg,   
            dig => AN
		  );
		
		-- dekoder binary -> BCD
		decoder : bin2bcd9
		port map (
			   in_bin => sig_distance,
			   out_bcd => sig_2seg
			);
			
		JC0 <= sig_trig;	-- vystup trig signalu	
		-- zobrazenie hexadecimal vysledku v cm na 3 segmenty
		
		-- priradenie vnutorych signalov

end Behavioral;