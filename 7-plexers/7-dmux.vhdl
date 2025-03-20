LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- 1:4 DEMUX
ENTITY dmux1to4 IS
END dmux1to4;

ARCHITECTURE behavior OF dmux1to4 IS
    SIGNAL D : STD_LOGIC;
    SIGNAL Sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL Y0, Y1, Y2, Y3 : STD_LOGIC;
BEGIN
    PROCESS(D, Sel)
    BEGIN
        Y0 <= '0';
        Y1 <= '0';
        Y2 <= '0';
        Y3 <= '0';

        CASE Sel IS
            WHEN "00" => Y0 <= D;
            WHEN "01" => Y1 <= D;
            WHEN "10" => Y2 <= D;
            WHEN "11" => Y3 <= D;
            WHEN OTHERS => NULL;
        END CASE;
    END PROCESS;

    --inputs
    D <= '1';
    Sel <= "01";
END behavior;
