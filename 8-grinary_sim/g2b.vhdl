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

entity gray2bin is
end entity;

architecture behaviour of gray2bin is
  signal n : std_logic_vector(3 downto 0);
  signal gray_n : std_logic_vector(3 downto 0);

  BEGIN
    process
    BEGIN
        -- gray_n = 1111, n = 1010
        gray_n <= "1111"; -- input here
        wait for 10 ns;
    end process;

    process(gray_n, n)
      begin
        n(3) <= gray_n(3);
        -- wait for 10 ns;

        n(2) <= n(3) xor gray_n(2);
        -- wait for 10 ns;

        n(1) <= n(2) xor gray_n(1);
        -- wait for 10 ns;

        n(0) <= n(1) xor gray_n(0);
        -- wait for 10 ns;

    end process;
end behaviour;
