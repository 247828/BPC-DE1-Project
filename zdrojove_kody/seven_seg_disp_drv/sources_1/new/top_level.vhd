library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           DP : out STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is
    -- deklarácie komponentovy
component seven_seg_disp_drv
    port ( 
        clk                 : in STD_LOGIC; -- hodiny
        rst                 : in STD_LOGIC; -- synchronny reset aktivny v urovni HIGH
        -- vstupne udaje: binarke cislo, pozicie desatinnych bodiek a viditelnost segmentov
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
        -- vystup pre sedem segmentove displeje dosky Nexys A7-50T
        seg                 : out STD_LOGIC_VECTOR (6 downto 0);
        dp                  : out STD_LOGIC;
        an                  : out STD_LOGIC_VECTOR (7 downto 0)   
    );
    
    -- lokálne signály
    
end component;
    -- inštaciacia
begin
    display : seven_seg_disp_drv
        port map (
            clk                 => CLK100MHZ,
            rst                 => BTNC,
            in_data0            => b"0001",
            in_data1            => b"0010",
            in_data2            => b"0011",
            in_data3            => b"0100",
            in_data4            => b"0101",
            in_data5            => b"0110",
            in_data6            => b"0111",
            in_data7            => b"1000",
            in_dp               => b"0010_0010",
            in_visible_digits   => b"1111_1111",
            seg(0)              => CA,
            seg(1)              => CB,
            seg(2)              => CC,
            seg(3)              => CD,
            seg(4)              => CE,
            seg(5)              => CF,
            seg(6)              => CG,   
            dp                  => DP,
            an                  => AN
        );

end Behavioral;
