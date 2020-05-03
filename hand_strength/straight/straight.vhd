library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity straight is
    port(
        cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found : out STD_LOGIC;
        rank  : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
    );
end straight;

architecture straight_arch of straight is
    component priority_encoder
        generic(input_width : natural := 2);
        port(
             input    : in  STD_LOGIC_VECTOR(       input_width - 1 downto 0);
             found    : out STD_LOGIC;
             position : out STD_LOGIC_VECTOR(log_2(input_width) - 1 downto 0)
        );
    end component;

    signal rank_group     : STD_LOGIC_VECTOR(13 downto 0);
    signal straight_found : STD_LOGIC_VECTOR( 9 downto 0);
begin
    rank_grouping: for i in 0 to 12 generate
        rank_group(i) <= cards(51 - i - 13 * 0) OR
                         cards(51 - i - 13 * 1) OR
                         cards(51 - i - 13 * 2) OR
                         cards(51 - i - 13 * 3);
    end generate;

    -- Add the Ace below the deuce to check the {5,4,3,2,A} straight
    rank_group(13) <= rank_group(0);

    straight_checkers: for i in 0 to 9 generate
        straight_found(9 - i) <= rank_group(i + 0) AND
                                 rank_group(i + 1) AND
                                 rank_group(i + 2) AND
                                 rank_group(i + 3) AND
                                 rank_group(i + 4);
    end generate;

    rank_selector: priority_encoder 
        generic map(
            input_width => 10
        )
        port map(
            input    => straight_found,
            found    => found,
            position => rank
        );
end straight_arch;