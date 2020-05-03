library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity strength_evaluator is
    port(
        -------------
        -- Hand #0 --
        -------------
        hand_0   : in STD_LOGIC_VECTOR( 4 - 1 downto 0);
        rank_0   : in STD_LOGIC_VECTOR(13 - 1 downto 0);
        kicker_0 : in STD_LOGIC_VECTOR(3 * 4 - 1 downto 0);
        -------------
        -- Hand #1 --
        -------------
        hand_1   : in STD_LOGIC_VECTOR( 4 - 1 downto 0);
        rank_1   : in STD_LOGIC_VECTOR(13 - 1 downto 0);
        kicker_1 : in STD_LOGIC_VECTOR(3 * 4 - 1 downto 0);
        ----------------
        -- Evaluation --
        ----------------
        hand_0_outcome : out STD_LOGIC_VECTOR(2 - 1 downto 0)
    );
end strength_evaluator;

architecture strength_evaluator_arch of strength_evaluator is
    component kicker_evaluator
        port(
            -------------
            -- Hand #0 --
            -------------
            hand_0   : in STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_0 : in STD_LOGIC_VECTOR(12 - 1 downto 0);
            -------------
            -- Hand #1 --
            -------------
            kicker_1 : in STD_LOGIC_VECTOR(12 - 1 downto 0);
            ----------------
            -- Evaluation --
            ----------------
            kicker_eval : out STD_LOGIC_VECTOR(2 - 1 downto 0)
        );
    end component;

    ----------------------
    -- kicker_evaluator --
    ----------------------
    signal kicker_eval : STD_LOGIC_VECTOR(2 - 1 downto 0);

    constant POT_WON   : STD_LOGIC_VECTOR(1 downto 0) := "10";
    constant POT_SPLIT : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant POT_LOST  : STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
    kicker_evaluator_I: kicker_evaluator
        port map(
            -------------
            -- Hand #0 --
            -------------
            hand_0   => hand_0,
            kicker_0 => kicker_0,
            -------------
            -- Hand #1 --
            -------------
            kicker_1 => kicker_1,
            ----------------
            -- Evaluation --
            ----------------
            kicker_eval => kicker_eval
        );


    process(hand_0, hand_1,
            rank_0, rank_1,
            kicker_eval)
    begin
        --------------------
        -- Hand cathegory --
        --------------------
        if hand_0 > hand_1 then
            hand_0_outcome <= POT_WON;
        elsif hand_0 < hand_1 then
            hand_0_outcome <= POT_LOST;
        else
            ---------------
            -- Hand rank --
            ---------------
            if rank_0 > rank_1 then
                hand_0_outcome <= POT_WON;
            elsif rank_0 < rank_1 then
                hand_0_outcome <= POT_LOST;
            else
                ---------------------------
                -- Kicker discrimination --
                ---------------------------
                -- Hands with no kicker
                if hand_0 = STRAIGHT_FLUSH_HAND OR
                   hand_0 = POKER_HAND          OR
                   hand_0 = FULL_HOUSE_HAND     OR
                   hand_0 = FLUSH_HAND          OR
                   hand_0 = STRAIGHT_HAND       OR
                   hand_0 = HIGH_CARD_HAND      then
                    hand_0_outcome <= POT_SPLIT;
                -- Hands with kicker
                else
                    hand_0_outcome <= kicker_eval;
                end if;
            end if;
        end if;
    end process;
end strength_evaluator_arch;