
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity bin2bcd9 is
    Port ( in_bin : in STD_LOGIC_VECTOR (8 downto 0);
           out_bcd : out STD_LOGIC_VECTOR (10 downto 0));
end bin2bcd9;

architecture Behavioral of bin2bcd9 is
begin
    bcd1 : process(in_bin)
    variable z : STD_LOGIC_VECTOR (19 downto 0);
        begin

        for i in 0 to 19 loop
             z(i) := '0';
        end loop;
            z(11 downto 3):= in_bin;

            for i in 0 to 5 loop
                if z(12 downto 9) > 4 then
                    z(12 downto 9) := z(12 downto 9) + 3;
                end if;
                if z(16 downto 13) > 4 then 
                    z(16 downto 13) := z(16 downto 13) + 3;
                end if;
                z(19 downto 1) := z(18 downto 0);
            end loop;
   out_bcd <= z(19 downto 9);

end process bcd1;
end Behavioral;