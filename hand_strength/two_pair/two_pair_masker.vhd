library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_pair_masker is
    port(
        cards        : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        rank         : in  STD_LOGIC_VECTOR( 4 - 1 downto 0);
        cards_masked : out STD_LOGIC_VECTOR(52 - 1 downto 0)
    );
end two_pair_masker;

architecture two_pair_masker_arch of two_pair_masker is
begin
    ------------------------------
    -- Mask highest-ranked pair --
    ------------------------------
    process(cards, rank)
    begin
        cards_masked <= cards;

        case rank is
            when "1100" =>
                cards_masked(51 - 13 * 0) <= '0';
                cards_masked(51 - 13 * 1) <= '0';
                cards_masked(51 - 13 * 2) <= '0';
                cards_masked(51 - 13 * 3) <= '0';
            
            when "1011" =>
                cards_masked(50 - 13 * 0) <= '0';
                cards_masked(50 - 13 * 1) <= '0';
                cards_masked(50 - 13 * 2) <= '0';
                cards_masked(50 - 13 * 3) <= '0';
            
            when "1010" =>
                cards_masked(49 - 13 * 0) <= '0';
                cards_masked(49 - 13 * 1) <= '0';
                cards_masked(49 - 13 * 2) <= '0';
                cards_masked(49 - 13 * 3) <= '0';
            
            when "1001" =>
                cards_masked(48 - 13 * 0) <= '0';
                cards_masked(48 - 13 * 1) <= '0';
                cards_masked(48 - 13 * 2) <= '0';
                cards_masked(48 - 13 * 3) <= '0';

            when "1000" =>
                cards_masked(47 - 13 * 0) <= '0';
                cards_masked(47 - 13 * 1) <= '0';
                cards_masked(47 - 13 * 2) <= '0';
                cards_masked(47 - 13 * 3) <= '0';

            when "0111" =>
                cards_masked(46 - 13 * 0) <= '0';
                cards_masked(46 - 13 * 1) <= '0';
                cards_masked(46 - 13 * 2) <= '0';
                cards_masked(46 - 13 * 3) <= '0';

            when "0110" =>
                cards_masked(45 - 13 * 0) <= '0';
                cards_masked(45 - 13 * 1) <= '0';
                cards_masked(45 - 13 * 2) <= '0';
                cards_masked(45 - 13 * 3) <= '0';

            when "0101" =>
                cards_masked(44 - 13 * 0) <= '0';
                cards_masked(44 - 13 * 1) <= '0';
                cards_masked(44 - 13 * 2) <= '0';
                cards_masked(44 - 13 * 3) <= '0';

            when "0100" =>
                cards_masked(43 - 13 * 0) <= '0';
                cards_masked(43 - 13 * 1) <= '0';
                cards_masked(43 - 13 * 2) <= '0';
                cards_masked(43 - 13 * 3) <= '0';

            when "0011" =>
                cards_masked(42 - 13 * 0) <= '0';
                cards_masked(42 - 13 * 1) <= '0';
                cards_masked(42 - 13 * 2) <= '0';
                cards_masked(42 - 13 * 3) <= '0';

            when "0010" =>
                cards_masked(41 - 13 * 0) <= '0';
                cards_masked(41 - 13 * 1) <= '0';
                cards_masked(41 - 13 * 2) <= '0';
                cards_masked(41 - 13 * 3) <= '0';

            when "0001" =>
                cards_masked(40 - 13 * 0) <= '0';
                cards_masked(40 - 13 * 1) <= '0';
                cards_masked(40 - 13 * 2) <= '0';
                cards_masked(40 - 13 * 3) <= '0';

            when "0000" =>
                cards_masked(39 - 13 * 0) <= '0';
                cards_masked(39 - 13 * 1) <= '0';
                cards_masked(39 - 13 * 2) <= '0';
                cards_masked(39 - 13 * 3) <= '0';
            
            when others =>
                cards_masked <= cards;
        end case;
    end process;
end two_pair_masker_arch;