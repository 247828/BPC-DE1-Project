----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2024 05:59:39 PM
-- Design Name: 
-- Module Name: top_level_01 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level_01 is
    Port ( JC0 : out STD_LOGIC;
           JD0 : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           DP : out STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (8 downto 0));
end top_level_01;

architecture Behavioral of top_level_01 is


component clock_enable
 generic (
        PERIOD : integer
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;
		


component trig_pulse
Generic (
		PULSE_WIDTH : integer -- 10 ns * PULSE_WIDTH pulse width
	);

	Port ( 
		start		: in STD_LOGIC;
		trig_out	: out STD_LOGIC; -- := '0';
		clk		: in std_logic;
		rst		: in std_logic
	);
end component;
			


component echo_detect
Port ( 
		trig		: in STD_LOGIC;
		echo_in		: in STD_LOGIC;
		clk		    : in std_logic;
		rst		    : in std_logic;
		distance	: out STD_LOGIC_VECTOR (8 downto 0) -- result in cm in range 3 to 400 => 9 bits (512 values)
	);
end component;
			


component bin2seg
 Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (8 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;
				
signal sig_start : std_logic;
signal sig_distance : std_logic_vector(8 downto 0);
signal sig_trig : std_logic;

	
begin

per_gen : clock_enable
generic map (
    PERIOD => 100000000
)
port map (
    clk => CLK100MHZ,
           rst => BTNC,
           pulse => sig_start              
);
		
trg_pls : trig_pulse
generic map (
   PULSE_WIDTH => 10000000 -- 10 ns * PULSE_WIDTH pulse width
)
port map (
   start =>	sig_start, 
		trig_out =>	sig_trig,	 
		clk	=> CLK100MHZ,		
		rst	=> BTNC		
);
		
 echo_1 : echo_detect
port map (
        trig =>	sig_trig,
		echo_in	=> JD0,
		clk	=>	CLK100MHZ,   
		rst	=> BTNC,  
		distance => sig_distance 
);
		
display : bin2seg

port map (
           clear => '0',
           bin => sig_distance,
           seg(6) => CA,
           seg(5) => CB,
           seg(4) => CC,
           seg(3) => CD, 
           seg(2) => CE,
           seg(1) => CF,
           seg(0) => CG
);
	JC0 <= sig_trig;
	AN <= b"1111_1110";	
	LED <= sig_distance;

end Behavioral;
