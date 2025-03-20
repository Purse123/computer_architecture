LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- 4:1 MUX
ENTITY mux4to1 IS
END mux4to1;

ARCHITECTURE behavior OF mux4to1 IS
    SIGNAL A, B, C, D : STD_LOGIC;
    SIGNAL S : STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2-bit selection line
    SIGNAL Y : STD_LOGIC;
BEGIN
    PROCESS(A, B, C, D, S)
    BEGIN
        CASE S IS
            WHEN "00" => Y <= A;
            WHEN "01" => Y <= B;
            WHEN "10" => Y <= C;
            WHEN "11" => Y <= D;
            WHEN OTHERS => Y <= '0';
        END CASE;
    END PROCESS;

    --inputs
    A <= '0';
    B <= '1';
    C <= '0';
    D <= '1';

    S <= "01";
END behavior;
