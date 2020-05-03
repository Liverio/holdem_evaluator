library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity kicker_evaluator is
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
end kicker_evaluator;

architecture kicker_evaluator_arch of kicker_evaluator is
    signal first_kicker_0   : STD_LOGIC_VECTOR(3 downto 0);
    signal first_kicker_1   : STD_LOGIC_VECTOR(3 downto 0);
    signal second_kicker_0  : STD_LOGIC_VECTOR(3 downto 0);
    signal second_kicker_1  : STD_LOGIC_VECTOR(3 downto 0);
    signal third_kicker_0   : STD_LOGIC_VECTOR(3 downto 0);
    signal third_kicker_1   : STD_LOGIC_VECTOR(3 downto 0);
    
    signal first_kicker_higher  : STD_LOGIC;
    signal first_kicker_equal   : STD_LOGIC;
    signal second_kicker_higher : STD_LOGIC;
    signal second_kicker_equal  : STD_LOGIC;
    signal third_kicker_higher  : STD_LOGIC;
    signal third_kicker_equal   : STD_LOGIC;

    signal hand_0_won   : STD_LOGIC;
    signal hand_0_split : STD_LOGIC;
begin
    first_kicker_0  <= kicker_0(3  downto 0);
    second_kicker_0 <= kicker_0(7  downto 4);
    third_kicker_0  <= kicker_0(11 downto 8);

    first_kicker_1  <= kicker_1(3  downto 0);
    second_kicker_1 <= kicker_1(7  downto 4);
    third_kicker_1  <= kicker_1(11 downto 8);

    first_kicker_higher <= '1' when first_kicker_0 > first_kicker_1 else '0';
    first_kicker_equal  <= '1' when first_kicker_0 = first_kicker_1 else '0';

    second_kicker_higher <= '1' when second_kicker_0 > second_kicker_1 else '0';
    second_kicker_equal  <= '1' when second_kicker_0 = second_kicker_1 else '0';

    third_kicker_higher <= '1' when third_kicker_0 > third_kicker_1 else '0';
    third_kicker_equal  <= '1' when third_kicker_0 = third_kicker_1 else '0';

    process(hand_0,
            first_kicker_higher, second_kicker_higher, third_kicker_higher,
            first_kicker_equal , second_kicker_equal , third_kicker_equal)
    begin
        case hand_0 is
            when THREE_OF_A_KIND_HAND =>
                hand_0_won   <= (first_kicker_higher)                         OR
                                (first_kicker_equal AND second_kicker_higher);

                hand_0_split <= (first_kicker_equal)  AND
                                (second_kicker_equal);

            when TWO_PAIR_HAND =>
                hand_0_won   <= first_kicker_higher;
                hand_0_split <= first_kicker_equal;

            when PAIR_HAND =>
                hand_0_won <= (first_kicker_higher)                                                OR
                              (first_kicker_equal AND second_kicker_higher)                        OR
                              (first_kicker_equal AND second_kicker_equal AND third_kicker_higher);
                

                hand_0_split <= (first_kicker_equal)  AND
                                (second_kicker_equal) AND
                                (third_kicker_equal);
                                
            when others =>
                hand_0_won   <= '0';
                hand_0_split <= '0';
        end case;
    end process;

    kicker_eval <= hand_0_won & hand_0_split;
end kicker_evaluator_arch;