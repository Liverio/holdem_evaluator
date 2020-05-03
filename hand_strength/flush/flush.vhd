library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity flush is
    port(
        cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found : out STD_LOGIC;
        rank  : out STD_LOGIC_VECTOR(13 - 1 downto 0)
    );
end flush;

architecture flush_arch of flush is
    component tree_counter
        generic(input_width : positive := 32);
        port(
             input  : in  STD_LOGIC_VECTOR(           input_width - 1 downto 0);
             output : out STD_LOGIC_VECTOR(log_2(input_width + 1) - 1 downto 0)
        );
    end component;

    type tp_flush_count is array(0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal flush_count  : tp_flush_count;
begin
    flush_counters: for i in 0 to 3 generate
        flush_tree_counter: tree_counter
            generic map(
                input_width => 13
            )
            port map(
                cards(51 - i * 13 downto 39 - i * 13),
                flush_count(i)
            );
    end generate;

    found <= '1' when unsigned(flush_count(0)) >= 5 OR
                      unsigned(flush_count(1)) >= 5 OR
                      unsigned(flush_count(2)) >= 5 OR
                      unsigned(flush_count(3)) >= 5 else
             '0';

    rank <= cards(51 - 0 * 13 downto 39 - 0 * 13) when unsigned(flush_count(0)) >= 5 else
            cards(51 - 1 * 13 downto 39 - 1 * 13) when unsigned(flush_count(1)) >= 5 else
            cards(51 - 2 * 13 downto 39 - 2 * 13) when unsigned(flush_count(2)) >= 5 else
            cards(51 - 3 * 13 downto 39 - 3 * 13);
end flush_arch;