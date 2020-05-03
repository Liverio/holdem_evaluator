library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity high_card is
    port(
        cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        rank  : out STD_LOGIC_VECTOR(13 - 1 downto 0)
    );
end high_card;

architecture high_card_arch of high_card is
begin
    rank_grouping: for i in 0 to 12 generate
        rank(12 - i) <= cards(51 - i - 13 * 0) OR
                        cards(51 - i - 13 * 1) OR
                        cards(51 - i - 13 * 2) OR
                        cards(51 - i - 13 * 3);
    end generate;
end high_card_arch;