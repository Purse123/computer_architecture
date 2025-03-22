LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder IS
END full_adder;

ARCHITECTURE behavior OF full_adder IS
    SIGNAL A, B, Cin : STD_LOGIC := '0';
    SIGNAL SUM, Cout : STD_LOGIC;
BEGIN

    SUM <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND (A XOR B));

    PROCESS
    BEGIN

      Cin <= '0';
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
