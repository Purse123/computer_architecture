LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY basic_gates IS
--   port (
--     A, B: IN STD_LOGIC;
--     AND_OUT, OR_OUT, NOT_OUT, NAND_OUT, NOR_OUT, XOR_OUT, XNOR_OUT: OUT STD_LOGIC
--   );
END basic_gates;

ARCHITECTURE test OF basic_gates IS
    SIGNAL A_sig, B_sig: STD_LOGIC := '0';
    SIGNAL AND_OUT_sig, OR_OUT_sig, NOT_OUT_sig, NAND_OUT_sig, NOR_OUT_sig, XOR_OUT_sig, XNOR_OUT_sig: STD_LOGIC;

BEGIN
    AND_OUT_sig <= A_sig AND B_sig;
    OR_OUT_sig <= A_sig OR B_sig;
    NOT_OUT_sig <= NOT A_sig;
    NAND_OUT_sig <= A_sig NAND B_sig;
    NOR_OUT_sig <= A_sig NOR B_sig;
    XOR_OUT_sig <= A_sig XOR B_sig;
    XNOR_OUT_sig <= A_sig XNOR B_sig;

    PROCESS
    BEGIN
        A_sig <= '0'; B_sig <= '0'; WAIT FOR 10 ns;
        A_sig <= '0'; B_sig <= '1'; WAIT FOR 10 ns;
        A_sig <= '1'; B_sig <= '0'; WAIT FOR 10 ns;
        A_sig <= '1'; B_sig <= '1'; WAIT FOR 10 ns;

        WAIT;
    END PROCESS;
END test;
