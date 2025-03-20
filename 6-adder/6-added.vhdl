LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY half_adder IS
END half_adder;

ARCHITECTURE behavior OF half_adder IS
    SIGNAL A, B : STD_LOGIC := '0';
    SIGNAL SUM, CARRY : STD_LOGIC;
BEGIN

    SUM <= A XOR B;
    CARRY <= A AND B;

    PROCESS
    BEGIN

        A <= '0'; B <= '0';
        WAIT FOR 5 sec;

        A <= '0'; B <= '1';
        WAIT FOR 5 sec;

        A <= '1'; B <= '0';
        WAIT FOR 5 sec;

        A <= '1'; B <= '1';
        WAIT FOR 5 sec;

        WAIT;
    END PROCESS;
END behavior;
