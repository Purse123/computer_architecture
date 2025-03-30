LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY basic_gates IS
--   port (
--     A, B: IN STD_LOGIC;
--     AND_OUT, OR_OUT, NOT_OUT, NAND_OUT, NOR_OUT, XOR_OUT, XNOR_OUT: OUT STD_LOGIC
--   );
END basic_gates;

ARCHITECTURE test OF basic_gates IS
    SIGNAL A, B: STD_LOGIC := '0';
    SIGNAL AND_OUT, OR_OUT, NOT_OUT, NAND_OUT, NOR_OUT, XOR_OUT, XNOR_OUT: STD_LOGIC;

BEGIN
    AND_OUT <= A AND B;
    OR_OUT <= A OR B;
    NOT_OUT <= NOT A;
    NAND_OUT <= A NAND B;
    NOR_OUT <= A NOR B;
    XOR_OUT <= A XOR B;
    XNOR_OUT <= A XNOR B;

    PROCESS
    BEGIN
        A <= '0'; B <= '0'; WAIT FOR 10 ns;
        A <= '0'; B <= '1'; WAIT FOR 10 ns;
        A <= '1'; B <= '0'; WAIT FOR 10 ns;
        A <= '1'; B <= '1'; WAIT FOR 10 ns;

        WAIT;
    END PROCESS;
END test;
