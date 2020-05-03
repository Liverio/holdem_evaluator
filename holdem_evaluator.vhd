library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity holdem_evaluator is
    port(
        board   : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        hand_0  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        hand_1  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        outcome : out STD_LOGIC_VECTOR( 2 - 1 downto 0)
    );
end holdem_evaluator;

architecture holdem_evaluator_arch of holdem_evaluator is
    component hand_strength
        port(
            cards  : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            hand   : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            rank   : out STD_LOGIC_VECTOR(13 - 1 downto 0);
            kicker : out STD_LOGIC_VECTOR(12 - 1 downto 0)
        );
    end component;

    component strength_evaluator
        port(
            -------------
            -- Hand #0 --
            -------------
            hand_0   : in STD_LOGIC_VECTOR( 4 - 1 downto 0);
            rank_0   : in STD_LOGIC_VECTOR(13 - 1 downto 0);
            kicker_0 : in STD_LOGIC_VECTOR(12 - 1 downto 0);
            -------------
            -- Hand #1 --
            -------------
            hand_1   : in STD_LOGIC_VECTOR( 4 - 1 downto 0);
            rank_1   : in STD_LOGIC_VECTOR(13 - 1 downto 0);
            kicker_1 : in STD_LOGIC_VECTOR(12 - 1 downto 0);
            ----------------
            -- Evaluation --
            ----------------
            hand_0_outcome : out STD_LOGIC_VECTOR(2 - 1 downto 0)
        );
    end component;

    ---------------------
    -- hand_strength_0 --
    ---------------------
    signal cards_0         : STD_LOGIC_VECTOR(51 downto 0);
    signal hand_strength_0 : STD_LOGIC_VECTOR( 4 - 1 downto 0);
    signal hand_rank_0     : STD_LOGIC_VECTOR(13 - 1 downto 0);
    signal hand_kicker_0   : STD_LOGIC_VECTOR(12 - 1 downto 0);

    ---------------------
    -- hand_strength_1 --
    ---------------------
    signal cards_1         : STD_LOGIC_VECTOR(51 downto 0);
    signal hand_strength_1 : STD_LOGIC_VECTOR( 4 - 1 downto 0);
    signal hand_rank_1     : STD_LOGIC_VECTOR(13 - 1 downto 0);
    signal hand_kicker_1   : STD_LOGIC_VECTOR(12 - 1 downto 0);
begin
    ---------------------
    -- hand_strength_0 --
    ---------------------
    cards_0 <= board OR hand_0;

    hand_strength_0_I: hand_strength
        port map(
            cards  => cards_0,
            hand   => hand_strength_0,
            rank   => hand_rank_0,
            kicker => hand_kicker_0
        );
    
    ---------------------
    -- hand_strength_1 --
    ---------------------
    cards_1 <= board OR hand_1;

    hand_strength_1_I: hand_strength
        port map(
            cards  => cards_1,
            hand   => hand_strength_1,
            rank   => hand_rank_1,
            kicker => hand_kicker_1
        );

    ------------------------
    -- strength_evaluator --
    ------------------------
    strength_evaluator_I: strength_evaluator
        port map(
            -------------
            -- Hand #0 --
            -------------
            hand_0   => hand_strength_0,
            rank_0   => hand_rank_0,
            kicker_0 => hand_kicker_0,
            -------------
            -- Hand #1 --
            -------------
            hand_1   => hand_strength_1,
            rank_1   => hand_rank_1,
            kicker_1 => hand_kicker_1,
            ----------------
            -- Evaluation --
            ----------------
            hand_0_outcome => outcome
        );
end holdem_evaluator_arch;