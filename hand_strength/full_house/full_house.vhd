library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity full_house is
    port(
        cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found : out STD_LOGIC;
        rank  : out STD_LOGIC_VECTOR( 8 - 1 downto 0)
    );
end full_house;

architecture full_house_arch of full_house is
    component three_of_a_kind
        port(
            cards    : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
            found    : out STD_LOGIC;
            rank     : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_0 : out STD_LOGIC_VECTOR( 4 - 1 downto 0);
            kicker_1 : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
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

    ---------------------
    -- three_of_a_kind --
    ---------------------
    signal found_three_of_a_kind : STD_LOGIC;
    signal rank_three_of_a_kind  : STD_LOGIC_VECTOR(3 downto 0);

    ----------
    -- pair --
    ----------
    signal found_pair : STD_LOGIC;
    signal rank_pair  : STD_LOGIC_VECTOR(3 downto 0);
begin
    three_of_a_kind_I: three_of_a_kind
        port map(
            cards    => cards,
            found    => found_three_of_a_kind,
            rank     => rank_three_of_a_kind,
            kicker_0 => open,
            kicker_1 => open
        );

    pair_I: pair
        port map(
            cards    => cards,
            found    => found_pair,
            rank     => rank_pair,
            kicker_0 => open,
            kicker_1 => open,
            kicker_2 => open
        );

    found <= found_three_of_a_kind AND found_pair;
    rank  <= rank_three_of_a_kind & rank_pair;
end full_house_arch;