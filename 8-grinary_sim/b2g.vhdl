--
--
-- AUTHOR: Pierce Neupane
---------------------------
-- NOTE:
-- Need process interupt for some reason (CTRL+C)
--                            After 20ns ^^^^^^^^
-- when ghdl -r ***
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin2gray is
end entity;

architecture behaviour of bin2gray is
  signal n : std_logic_vector(3 downto 0);
  signal gray_n : std_logic_vector(3 downto 0);

  BEGIN
    process
    BEGIN
        -- n = 1010, gray_n = 1111
        n <= "1010"; -- input here
        wait for 10 ns;
    end process;

    process(n)
      begin
        gray_n(3) <= n(3);
        gray_n(2) <= n(3) xor n(2);
        gray_n(1) <= n(2) xor n(1);
        gray_n(0) <= n(1) xor n(0);
    end process;
end behaviour;
