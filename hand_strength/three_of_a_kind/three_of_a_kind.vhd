library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity three_of_a_kind is
    port(
        cards    : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found    : out STD_LOGIC;
        rank     : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
        kicker_0 : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
        kicker_1 : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
    );
end three_of_a_kind;

architecture three_of_a_kind_arch of three_of_a_kind is
    component priority_encoder
        generic(input_width : natural := 2);
        port(
             input    : in  STD_LOGIC_VECTOR(       input_width - 1 downto 0);
             found    : out STD_LOGIC;
             position : out STD_LOGIC_VECTOR(log_2(input_width) - 1 downto 0)
        );
    end component;

    component masker
        port(
            cards        : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            rank         : in  STD_LOGIC_VECTOR( 4 - 1 downto 0);
            cards_masked : out STD_LOGIC_VECTOR(52 - 1 downto 0)
        );
    end component;
    
    -----------------------------
    -- Three of kind detection --
    -----------------------------
    type tp_rank_group is array(12 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
    signal rank_group            : tp_rank_group;
    signal three_of_a_kind_found : STD_LOGIC_VECTOR(12 downto 0);
    signal rank_int              : STD_LOGIC_VECTOR( 3 downto 0);

    -------------------------
    -- Kicker #0 detection --
    -------------------------
    signal cards_masked_0 : STD_LOGIC_VECTOR(51 downto 0);
    signal cards_rank_0   : STD_LOGIC_VECTOR(12 downto 0);
    signal kicker_0_int   : STD_LOGIC_VECTOR( 3 downto 0);

    -------------------------
    -- Kicker #1 detection --
    -------------------------
    signal cards_masked_1 : STD_LOGIC_VECTOR(51 downto 0);
    signal cards_rank_1   : STD_LOGIC_VECTOR(12 downto 0);
begin
    -----------------------------
    -- Three of kind detection --
    -----------------------------
    -- {Ac, Ad, Ah, As}
    -- {Kc, Kd, Kh, Ks}
    -- ...
    -- {2c, 2d, 2h, 2s}
    rank_grouping: for i in 0 to 12 generate
        rank_group(12 - i) <= cards(51 - i - 13 * 0) &
                              cards(51 - i - 13 * 1) &
                              cards(51 - i - 13 * 2) &
                              cards(51 - i - 13 * 3);
    end generate;

    hand_search: for i in 0 to 12 generate
        three_of_a_kind_found(i) <= '1' when rank_group(i) = "1110" OR
                                             rank_group(i) = "1101" OR
                                             rank_group(i) = "1011" OR
                                             rank_group(i) = "0111" else
                                    '0';
    end generate;                                

    rank_selector: priority_encoder 
        generic map(
            input_width => 13
        )
        port map(
            input    => three_of_a_kind_found,
            found    => found,
            position => rank_int
        );
    
    rank <= rank_int;
    
    -------------------------
    -- Kicker #0 detection --
    -------------------------
    -- Mask three of kind cards
    masker_0: masker
        port map(
            cards        => cards,
            rank         => rank_int,
            cards_masked => cards_masked_0
        );

    -- Identify the highest kicker
    cards_rank_0_gen: for i in 0 to 12 generate
        cards_rank_0(12 - i) <= cards_masked_0(51 - i) OR
                                cards_masked_0(38 - i) OR
                                cards_masked_0(25 - i) OR
                                cards_masked_0(12 - i);
    end generate;

    kicker_0_int <= x"C" when cards_rank_0(12) = '1' else
                    x"B" when cards_rank_0(11) = '1' else
                    x"A" when cards_rank_0(10) = '1' else
                    x"9" when cards_rank_0( 9) = '1' else
                    x"8" when cards_rank_0( 8) = '1' else
                    x"7" when cards_rank_0( 7) = '1' else
                    x"6" when cards_rank_0( 6) = '1' else
                    x"5" when cards_rank_0( 5) = '1' else
                    x"4" when cards_rank_0( 4) = '1' else
                    x"3" when cards_rank_0( 3) = '1' else
                    x"2" when cards_rank_0( 2) = '1' else
                    x"1" when cards_rank_0( 1) = '1' else
                    x"0";
    
    kicker_0 <= kicker_0_int;

    -------------------------
    -- Kicker #1 detection --
    -------------------------
    -- Mask kicker #0 card
    masker_1: masker
        port map(
            cards        => cards_masked_0,
            rank         => kicker_0_int,
            cards_masked => cards_masked_1
        );

    -- Identify the highest kicker
    cards_rank_1_gen: for i in 0 to 12 generate
        cards_rank_1(12 - i) <= cards_masked_1(51 - i) OR
                                cards_masked_1(38 - i) OR
                                cards_masked_1(25 - i) OR
                                cards_masked_1(12 - i);
    end generate;

    kicker_1 <= x"C" when cards_rank_1(12) = '1' else
                x"B" when cards_rank_1(11) = '1' else
                x"A" when cards_rank_1(10) = '1' else
                x"9" when cards_rank_1( 9) = '1' else
                x"8" when cards_rank_1( 8) = '1' else
                x"7" when cards_rank_1( 7) = '1' else
                x"6" when cards_rank_1( 6) = '1' else
                x"5" when cards_rank_1( 5) = '1' else
                x"4" when cards_rank_1( 4) = '1' else
                x"3" when cards_rank_1( 3) = '1' else
                x"2" when cards_rank_1( 2) = '1' else
                x"1" when cards_rank_1( 1) = '1' else
                x"0";
end three_of_a_kind_arch;