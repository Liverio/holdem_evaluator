library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity hand_strength is
    port(
        cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        hand   : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
        rank   : out STD_LOGIC_VECTOR(13 - 1 downto 0);
        kicker : out STD_LOGIC_VECTOR(12 - 1 downto 0)
    );
end hand_strength;

architecture hand_strength_arch of hand_strength is
    component straight_flush
        port(
            cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found : out STD_LOGIC;
            rank  : out STD_LOGIC_VECTOR(4 - 1 downto 0)
        );
    end component;

    component poker
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found  : out STD_LOGIC;
            rank   : out STD_LOGIC_VECTOR(13 - 1 downto 0);
            kicker : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
        );
    end component;

    component full_house
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found  : out STD_LOGIC;
            rank   : out STD_LOGIC_VECTOR( 8 - 1 downto 0)
        );
    end component;

    component flush
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found  : out STD_LOGIC;
            rank   : out STD_LOGIC_VECTOR(13 - 1 downto 0)
        );
    end component;

    component straight
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found  : out STD_LOGIC;
            rank   : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
        );
    end component;

    component three_of_a_kind
        port(
            cards    : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found    : out STD_LOGIC;
            rank     : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_0 : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_1 : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
        );
    end component;

    component two_pair
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found  : out STD_LOGIC;
            rank   : out STD_LOGIC_VECTOR(8 - 1 downto 0);
            kicker : out STD_LOGIC_VECTOR(4 - 1 downto 0)
        );
    end component;

    component pair
        port(
            cards    : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found    : out STD_LOGIC;
            rank     : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_0 : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_1 : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_2 : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
        );
    end component;

    component high_card
        port(
            cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            rank  : out STD_LOGIC_VECTOR(13 - 1 downto 0)
        );
    end component;

    --------------------
    -- Hand detectors --
    --------------------
    signal straight_flush_found  : STD_LOGIC;
    signal poker_found           : STD_LOGIC;
    signal full_house_found      : STD_LOGIC;
    signal flush_found           : STD_LOGIC;
    signal straight_found        : STD_LOGIC;
    signal three_of_a_kind_found : STD_LOGIC;
    signal two_pair_found        : STD_LOGIC;
    signal pair_found            : STD_LOGIC;

    signal straight_flush_rank  : STD_LOGIC_VECTOR( 3 downto 0);
    signal poker_rank           : STD_LOGIC_VECTOR(12 downto 0);
    signal full_house_rank      : STD_LOGIC_VECTOR( 7 downto 0);
    signal flush_rank           : STD_LOGIC_VECTOR(12 downto 0);
    signal straight_rank        : STD_LOGIC_VECTOR( 3 downto 0);
    signal three_of_a_kind_rank : STD_LOGIC_VECTOR( 3 downto 0);
    signal two_pair_rank        : STD_LOGIC_VECTOR( 7 downto 0);
    signal pair_rank            : STD_LOGIC_VECTOR( 3 downto 0);
    signal high_card_rank       : STD_LOGIC_VECTOR(12 downto 0);

    signal poker_kicker             : STD_LOGIC_VECTOR(3 downto 0);
    signal three_of_a_kind_kicker_0 : STD_LOGIC_VECTOR(3 downto 0);
    signal three_of_a_kind_kicker_1 : STD_LOGIC_VECTOR(3 downto 0);
    signal two_pair_kicker          : STD_LOGIC_VECTOR(3 downto 0);
    signal pair_kicker_0            : STD_LOGIC_VECTOR(3 downto 0);
    signal pair_kicker_1            : STD_LOGIC_VECTOR(3 downto 0);
    signal pair_kicker_2            : STD_LOGIC_VECTOR(3 downto 0);

    signal kicker_0 : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal kicker_1 : STD_LOGIC_VECTOR(4 - 1 downto 0);
    signal kicker_2 : STD_LOGIC_VECTOR(4 - 1 downto 0);
begin
    --------------------
    -- Hand detectors --
    --------------------
    straight_flush_I: straight_flush
        port map(
            cards => cards,
            found => straight_flush_found,
            rank  => straight_flush_rank
        );

    poker_I: poker
        port map(
            cards  => cards,
            found  => poker_found,
            rank   => poker_rank,
            kicker => poker_kicker
        );
    
    full_house_I: full_house
        port map(
            cards => cards,
            found => full_house_found,
            rank  => full_house_rank
        );

    flush_I: flush
        port map(
            cards  => cards,
            found  => flush_found,
            rank   => flush_rank
        );

    straight_I: straight
        port map(
            cards  => cards,
            found  => straight_found,
            rank   => straight_rank
        );

    three_of_a_kind_I: three_of_a_kind
        port map(
            cards    => cards,
            found    => three_of_a_kind_found,
            rank     => three_of_a_kind_rank,
            kicker_0 => three_of_a_kind_kicker_0,
            kicker_1 => three_of_a_kind_kicker_1
        );

    two_pair_I: two_pair
        port map(
            cards  => cards,
            found  => two_pair_found,
            rank   => two_pair_rank,
            kicker => two_pair_kicker
        );

    pair_I: pair
        port map(
            cards    => cards,
            found    => pair_found,
            rank     => pair_rank,
            kicker_0 => pair_kicker_0,
            kicker_1 => pair_kicker_1,
            kicker_2 => pair_kicker_2
        );
    
    high_card_I: high_card
        port map(
            cards => cards,
            rank  => high_card_rank
        );

    -------------------
    -- Hand selector --
    -------------------
    process(straight_flush_found , straight_flush_rank ,
            poker_found          , poker_rank          , poker_kicker,
            full_house_found     , full_house_rank     ,
            straight_found       , straight_rank       ,
            three_of_a_kind_found, three_of_a_kind_rank, three_of_a_kind_kicker_0, three_of_a_kind_kicker_1,
            two_pair_found       , two_pair_rank       , two_pair_kicker         ,
            pair_found           , pair_rank           , pair_kicker_0           , pair_kicker_1           , pair_kicker_2,
            high_card_rank)
    begin
        rank     <= (others => '0');
        kicker_0 <= (others => '0');
        kicker_1 <= (others => '0');
        kicker_2 <= (others => '0');

        if straight_flush_found = '1' then
            hand              <= STRAIGHT_FLUSH_HAND;
            rank( 3 downto 0) <= straight_flush_rank;
        elsif poker_found = '1' then
            hand              <= POKER_HAND;
            rank(12 downto 0) <= poker_rank;
            kicker_0          <= poker_kicker;
        elsif full_house_found = '1' then
            hand              <= FULL_HOUSE_HAND;
            rank( 7 downto 0) <= full_house_rank;
        elsif flush_found = '1' then
            hand              <= FLUSH_HAND;
            rank(12 downto 0) <= flush_rank;
        elsif straight_found = '1' then
            hand              <= STRAIGHT_HAND;
            rank( 3 downto 0) <= straight_rank;
        elsif three_of_a_kind_found = '1' then
            hand              <= THREE_OF_A_KIND_HAND;
            rank( 3 downto 0) <= three_of_a_kind_rank;
            kicker_0          <= three_of_a_kind_kicker_0;
            kicker_1          <= three_of_a_kind_kicker_1;
        elsif two_pair_found = '1' then
            hand              <= TWO_PAIR_HAND;
            rank( 7 downto 0) <= two_pair_rank;
            kicker_0          <= two_pair_kicker;
        elsif pair_found = '1' then
            hand              <= PAIR_HAND;
            rank( 3 downto 0) <= pair_rank;
            kicker_0          <= pair_kicker_0;
            kicker_1          <= pair_kicker_1;
            kicker_2          <= pair_kicker_2;
        -- High card
        else
            hand              <= HIGH_CARD_HAND;
            rank(12 downto 0) <= high_card_rank;
        end if;
    end process;

    kicker <= kicker_2 & kicker_1 & kicker_0;
end hand_strength_arch;