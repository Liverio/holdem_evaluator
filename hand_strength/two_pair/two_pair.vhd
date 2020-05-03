library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity two_pair is
    port(
        cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found  : out STD_LOGIC;
        rank   : out STD_LOGIC_VECTOR( 8 - 1 downto 0);
        kicker : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
    );
end two_pair;

architecture two_pair_arch of two_pair is
    component pair
        port(
            cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found : out STD_LOGIC;
            rank  : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
        );
    end component;

    component two_pair_masker
        port(
            cards        : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            rank         : in  STD_LOGIC_VECTOR( 4 - 1 downto 0);
            cards_masked : out STD_LOGIC_VECTOR(52 - 1 downto 0)
        );
    end component;

    component priority_encoder
        generic(input_width : natural := 2);
        port(
             input    : in  STD_LOGIC_VECTOR(       input_width - 1 downto 0);
             found    : out STD_LOGIC;
             position : out STD_LOGIC_VECTOR(log_2(input_width) - 1 downto 0)
        );
    end component;

    -------------------------
    -- Highest-ranked pair --
    -------------------------
    signal pair_0_found : STD_LOGIC;
    signal pair_0_rank  : STD_LOGIC_VECTOR(3 downto 0);

    --------------------------------
    -- Second highest-ranked pair --
    --------------------------------
    signal cards_masked : STD_LOGIC_VECTOR(51 downto 0);
    signal pair_1_found : STD_LOGIC;
    signal pair_1_rank  : STD_LOGIC_VECTOR(3 downto 0);

    ------------
    -- Kicker --
    ------------
    signal cards_masked_2 : STD_LOGIC_VECTOR(51 downto 0);
    signal cards_rank     : STD_LOGIC_VECTOR(12 downto 0);
begin
    -------------------------
    -- Highest-ranked pair --
    -------------------------
    pair_0: pair
        port map(
            cards => cards,
            found => pair_0_found,
            rank  => pair_0_rank
        );
        
    --------------------------------
    -- Second highest-ranked pair --
    --------------------------------
    -- Mask highest-ranked pair
    two_pair_masker_0: two_pair_masker
        port map(
            cards        => cards,
            rank         => pair_0_rank,
            cards_masked => cards_masked
        );

    pair_1: pair
        port map(
            cards => cards_masked,
            found => pair_1_found,
            rank  => pair_1_rank
        );
    
    found <= pair_0_found AND pair_1_found;
    rank  <= pair_0_rank & pair_1_rank;

    ------------
    -- Kicker --
    ------------    
    -- Mask second highest-ranked pair
    two_pair_masker_1: two_pair_masker
        port map(
            cards        => cards_masked,
            rank         => pair_1_rank,
            cards_masked => cards_masked_2
        );

    -- Remove suit info
    card_rank_gen: for i in 0 to 12 generate
        cards_rank(12 - i) <= cards_masked_2(51 - i - 13 * 0) OR
                              cards_masked_2(51 - i - 13 * 1) OR
                              cards_masked_2(51 - i - 13 * 2) OR
                              cards_masked_2(51 - i - 13 * 3);
    end generate; 

    rank_selector: priority_encoder 
        generic map(
            input_width => 13
        )
        port map(
            input    => cards_rank,
            found    => open,
            position => kicker
        );
end two_pair_arch;