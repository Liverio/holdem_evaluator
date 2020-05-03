library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity masker is
    port(
        cards        : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        rank         : in  STD_LOGIC_VECTOR( 4 - 1 downto 0);
        cards_masked : out STD_LOGIC_VECTOR(52 - 1 downto 0)
    );
end masker;

architecture masker_arch of masker is
begin
    process(cards, rank)
    begin
        cards_masked <= cards;

        case rank is
            when x"C" =>
                for i in 0 to 3 loop
                    cards_masked(51 - 13 * i) <= '0';
                end loop;

            when x"B" =>
                for i in 0 to 3 loop
                    cards_masked(50 - 13 * i) <= '0';
                end loop;
            
            when x"A" =>
                for i in 0 to 3 loop
                    cards_masked(49 - 13 * i) <= '0';
                end loop;
            
            when x"9" =>
                for i in 0 to 3 loop
                    cards_masked(48 - 13 * i) <= '0';
                end loop;
            
            when x"8" =>
                for i in 0 to 3 loop
                    cards_masked(47 - 13 * i) <= '0';
                end loop;

            when x"7" =>
                for i in 0 to 3 loop
                    cards_masked(46 - 13 * i) <= '0';
                end loop;

            when x"6" =>
                for i in 0 to 3 loop
                    cards_masked(45 - 13 * i) <= '0';
                end loop;

            when x"5" =>
                for i in 0 to 3 loop
                    cards_masked(44 - 13 * i) <= '0';
                end loop;

            when x"4" =>
                for i in 0 to 3 loop
                    cards_masked(43 - 13 * i) <= '0';
                end loop;
            
            when x"3" =>
                for i in 0 to 3 loop
                    cards_masked(42 - 13 * i) <= '0';
                end loop;
            
            when x"2" =>
                for i in 0 to 3 loop
                    cards_masked(41 - 13 * i) <= '0';
                end loop;

            when x"1" =>
                for i in 0 to 3 loop
                    cards_masked(40 - 13 * i) <= '0';
                end loop;
            
            when x"0" =>
                for i in 0 to 3 loop
                    cards_masked(39 - 13 * i) <= '0';
                end loop;
                
            when others =>
                cards_masked <= cards;
        end case;
    end process;
end masker_arch;