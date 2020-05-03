library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";
use ieee.math_real."floor";

package types is
    -- Signals size
    function log_2(n: natural) return natural;
    
    -- Type conversion
    function to_uint(vector: STD_LOGIC_VECTOR) return integer;   
    function vector_slice(vector : STD_LOGIC_VECTOR; element : natural; element_size : positive) return STD_LOGIC_VECTOR;
    -- Add two std_logic_vector loosing carry
    function add(a, b : std_logic_vector) return std_logic_vector;
    -- Add two std_logic_vector adding one bit to output size
    function c_add(a, b : std_logic_vector) return std_logic_vector;

    ------------------
    -- Hand ranking --
    ------------------
    constant STRAIGHT_FLUSH_HAND  : STD_LOGIC_VECTOR(4 - 1 downto 0) := "1000";
    constant POKER_HAND           : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0111";
    constant FULL_HOUSE_HAND      : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0110";
    constant FLUSH_HAND           : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0101";
    constant STRAIGHT_HAND        : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0100";
    constant THREE_OF_A_KIND_HAND : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0011";
    constant TWO_PAIR_HAND        : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0010";
    constant PAIR_HAND            : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0001";
    constant HIGH_CARD_HAND       : STD_LOGIC_VECTOR(4 - 1 downto 0) := "0000";
end package;
    
package body types is
    -- Signals size
    function log_2(n: natural) return natural is
    begin
        return integer(ceil(log2(real(n))));
    end function;
    
    -- Type conversion
    function to_uint(vector: STD_LOGIC_VECTOR) return integer is
    begin
        return to_integer(unsigned(vector));
    end function;    
    
    function vector_slice(vector : STD_LOGIC_VECTOR; element : natural; element_size : positive) return STD_LOGIC_VECTOR is
    begin
        return vector((element + 1) * element_size - 1 downto element * element_size);
    end function;

    -- Add two std_logic_vector loosing carry
    function add(a, b : std_logic_vector) return std_logic_vector is
    begin
        return std_logic_vector(unsigned(a) + unsigned(b));
    end function;
    
    -- Add two std_logic_vector adding one bit to output size
    function c_add(a, b : std_logic_vector) return std_logic_vector is
    begin
        if a'length > b'length then
            return std_logic_vector(resize(unsigned(a), a'length + 1)
                    + resize(unsigned(b), a'length + 1));
        else
            return std_logic_vector(resize(unsigned(a), b'length + 1)
                    + resize(unsigned(b), b'length + 1));
        end if;
    end function;

    
end types;
