library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity straight_flush is
    port(
        cards : in  STD_LOGIC_VECTOR(52 - 1 downto 0);
        found : out STD_LOGIC;
        rank  : out STD_LOGIC_VECTOR( 4 - 1 downto 0)
    );
end straight_flush;

architecture straight_flush_arch of straight_flush is
    component straight_flush_checker
        port(
            cards : in  STD_LOGIC_VECTOR(13 - 1 downto 0);
            found : out STD_LOGIC;
            rank  : out STD_LOGIC_VECTOR(4 - 1 downto 0)
        );
    end component;
    
    signal found_int : STD_LOGIC_VECTOR(3 downto 0);
    type tp_rank is array(0 to 3) of STD_LOGIC_VECTOR(3 downto 0);
    signal rank_int  : tp_rank;
begin
    cards_sf_suit: for i in 0 to 3 generate
        straight_flush_checker_I: straight_flush_checker
            port map(
                cards => cards(51 - 13 * i downto 39 - 13 * i),
                found => found_int(i),
                rank  => rank_int(i)
            );
    end generate;

    found <= found_int(3) OR found_int(2) OR found_int(1) OR found_int(0);

    process(found_int, rank_int)
    begin
        case found_int is
            when "1000" =>
                rank <= rank_int(3);
            
            when "0100" =>
                rank <= rank_int(2);

            when "0010" =>
                rank <= rank_int(1);
            
            when "0001" =>
                rank <= rank_int(0);
            
            when others =>
                rank <= rank_int(0);
        end case;
    end process;
end straight_flush_arch;