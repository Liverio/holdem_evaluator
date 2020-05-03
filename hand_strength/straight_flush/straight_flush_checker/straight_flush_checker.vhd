library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity straight_flush_checker is
    port(
        cards : in  STD_LOGIC_VECTOR(13 - 1 downto 0);
        found : out STD_LOGIC;
        rank  : out STD_LOGIC_VECTOR(4 - 1 downto 0)
    );
end straight_flush_checker;

architecture straight_flush_checker_arch of straight_flush_checker is
    component priority_encoder
        generic(input_width : natural := 2);
        port(
             input    : in  STD_LOGIC_VECTOR(       input_width - 1 downto 0);
             found    : out STD_LOGIC;
             position : out STD_LOGIC_VECTOR(log_2(input_width) - 1 downto 0)
        );
    end component;

    -- Checkers
    signal sf_found : STD_LOGIC_VECTOR(9 downto 0);

    -- Straight flush combinations:
    --     {A:T}{K:9}{Q:8}{J:7}{T:6}{9:5}{8:4}{7:3}{6:2}{5:A}
    signal cards_extended : STD_LOGIC_VECTOR(13 downto 0);
begin
    -- Add the Ace bit below the deuce
    cards_extended(13 downto 1) <= cards(12 downto 0);
    cards_extended(0)           <= cards(12);

    checkers: for i in 0 to 9 generate
        sf_found(9 - i) <= '1' when cards_extended(13 - i downto 9 - i) = "11111" else '0';
    end generate;
    
    rank_selector: priority_encoder 
        generic map(
            input_width => 10
        )
        port map(
            input    => sf_found,
            found    => found,
            position => rank
        );
end straight_flush_checker_arch;