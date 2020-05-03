library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity poker is
    port(
        cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found  : out STD_LOGIC;
        rank   : out STD_LOGIC_VECTOR(13 - 1 downto 0);
        kicker : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
    );
end poker;

architecture poker_arch of poker is
    ---------------------
    -- Poker detection --
    ---------------------
    signal poker_found : STD_LOGIC_VECTOR(12 downto 0);
    signal found_int   : STD_LOGIC_VECTOR(3 downto 0);
    type tp_rank is array(0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal rank_int    : tp_rank;

    ----------------------
    -- Kicker detection --
    ----------------------
    signal cards_masked : STD_LOGIC_VECTOR(51 downto 0);
    signal cards_rank   : STD_LOGIC_VECTOR(12 downto 0);
begin
    ---------------------
    -- Poker detection --
    ---------------------
    checkers: for i in 0 to 12 generate
        poker_found(12 - i) <= cards(51 - i) AND
                               cards(38 - i) AND
                               cards(25 - i) AND
                               cards(12 - i);                              
    end generate;

    found <= '1' when poker_found /= "0000000000000" else '0';
    rank  <= poker_found;

    ----------------------
    -- Kicker detection --
    ----------------------
    -- Mask poker cards
    process(cards, poker_found)
    begin
        cards_masked <= cards;

        case poker_found is
            when "1000000000000" =>
                for i in 0 to 3 loop
                    cards_masked(51 - 13 * i) <= '0';
                end loop;

            when "0100000000000" =>
                for i in 0 to 3 loop
                    cards_masked(50 - 13 * i) <= '0';
                end loop;
            
            when "0010000000000" =>
                for i in 0 to 3 loop
                    cards_masked(49 - 13 * i) <= '0';
                end loop;
            
            when "0001000000000" =>
                for i in 0 to 3 loop
                    cards_masked(48 - 13 * i) <= '0';
                end loop;
            
            when "0000100000000" =>
                for i in 0 to 3 loop
                    cards_masked(47 - 13 * i) <= '0';
                end loop;

            when "0000010000000" =>
                for i in 0 to 3 loop
                    cards_masked(46 - 13 * i) <= '0';
                end loop;

            when "0000001000000" =>
                for i in 0 to 3 loop
                    cards_masked(45 - 13 * i) <= '0';
                end loop;

            when "0000000100000" =>
                for i in 0 to 3 loop
                    cards_masked(44 - 13 * i) <= '0';
                end loop;

            when "0000000010000" =>
                for i in 0 to 3 loop
                    cards_masked(43 - 13 * i) <= '0';
                end loop;
            
            when "0000000001000" =>
                for i in 0 to 3 loop
                    cards_masked(42 - 13 * i) <= '0';
                end loop;
            
            when "0000000000100" =>
                for i in 0 to 3 loop
                    cards_masked(41 - 13 * i) <= '0';
                end loop;

            when "0000000000010" =>
                for i in 0 to 3 loop
                    cards_masked(40 - 13 * i) <= '0';
                end loop;
            
            when "0000000000001" =>
                for i in 0 to 3 loop
                    cards_masked(39 - 13 * i) <= '0';
                end loop;
                
            when others          =>
                cards_masked <= cards;
        end case;
    end process;

    -- Identify the highest kicker
    cards_rank_gen: for i in 0 to 12 generate
        cards_rank(i) <= cards_masked(51 - i) OR
                         cards_masked(38 - i) OR
                         cards_masked(25 - i) OR
                         cards_masked(12 - i);
    end generate;

    kicker <= x"C" when cards_rank( 0) = '1' else
              x"B" when cards_rank( 1) = '1' else
              x"A" when cards_rank( 2) = '1' else
              x"9" when cards_rank( 3) = '1' else
              x"8" when cards_rank( 4) = '1' else
              x"7" when cards_rank( 5) = '1' else
              x"6" when cards_rank( 6) = '1' else
              x"5" when cards_rank( 7) = '1' else
              x"4" when cards_rank( 8) = '1' else
              x"3" when cards_rank( 9) = '1' else
              x"2" when cards_rank(10) = '1' else
              x"1" when cards_rank(11) = '1' else
              x"0";
end poker_arch;