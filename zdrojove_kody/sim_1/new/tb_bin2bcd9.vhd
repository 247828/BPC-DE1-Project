-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 7.4.2024 17:13:06 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_bin2bcd9 is
end tb_bin2bcd9;

architecture tb of tb_bin2bcd9 is

    component bin2bcd9
        port (b : in std_logic_vector (8 downto 0);
              p : out std_logic_vector (10 downto 0));
    end component;

    signal b : std_logic_vector (8 downto 0);
    signal p : std_logic_vector (10 downto 0);

begin

    dut : bin2bcd9
    port map (b => b,
              p => p);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        report "Simulace zaèala!";
        
        b <= b"110010000"; -- 400
        wait for 50 ns;
            assert (p = "10000000000")
            report "Chyba u prevodu z binarniho kodu 11001000 (vyjadreno v decimalni soustave: 400) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"000001010"; -- 10
        wait for 50 ns;
            assert (p = "00000010000")
            report "Chyba u prevodu z binarniho kodu 000001010 (vyjadreno v decimalni soustave: 10) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"000001000"; -- 8
        wait for 50 ns;
            assert (p = "00000001000")
            report "Chyba u prevodu z binarniho kodu 000001000 (vyjadreno v decimalni soustave: 8) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"000000001"; -- 1
        wait for 50 ns;
            assert (p = "00000000001")
            report "Chyba u prevodu z binarniho kodu 000000001 (vyjadreno v decimalni soustave: 1) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"010101010"; -- 170
        wait for 50 ns;
            assert (p = "00101110000")
            report "Chyba u prevodu z binarniho kodu 00010101010 (vyjadreno v decimalni soustave: 170) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"000111111"; -- 63
        wait for 50 ns;
            assert (p = "00001100011")
            report "Chyba u prevodu z binarniho kodu 000111111 (vyjadreno v decimalni soustave: 63) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"001111111"; -- 127
        wait for 50 ns;
            assert (p = "00100100111")
            report "Chyba u prevodu z binarniho kodu 001111111 (vyjadreno v decimalni soustave: 127) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"011111111"; -- 255
        wait for 50 ns;
            assert (p = "01001010101")
            report "Chyba u prevodu z binarniho kodu 0111111111 (vyjadreno v decimalni soustave: 255) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"000000000"; -- 0
        wait for 50 ns;
            assert (p = "00000000000")
            report "Chyba u prevodu z binarniho kodu 000000000 (vyjadreno v decimalni soustave: 0) na BCD, prevod neprobehl uspesne!"
            severity error;
            
        b <= b"110010001"; -- 401, zkouska cisla > 400
        wait for 50 ns;
            assert (p = "10000000001")
            report "Chyba u prevodu z binarniho kodu 110010001 (vyjadreno v decimalni soustave: 401) na BCD, prevod neprobehl uspesne!"
            severity error;
        b <= (others => '0');
        report "Simulace skonèila!";
        -- EDIT Add stimuli here

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_bin2bcd9 of tb_bin2bcd9 is
    for tb
    end for;
end cfg_tb_bin2bcd9;