LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY basic_gates IS
  -- port (
    -- A, B: IN STD_LOGIC;
    -- AND_OUT, OR_OUT, NOT_OUT, NAND_OUT, NOR_OUT, XOR_OUT, XNOR_OUT: OUT STD_LOGIC
  -- );
end basic_gates;

architecture gate_imp of basic_gates IS
  begin
    AND_OUT <= A and B;
    OR_OUT <= A or B;
    NOT_OUT <= not A;
    NAND_OUT <= A nand B;
    NOR_OUT <= A nor B;
    XOR_OUT <= A xor B;
    XNOR_OUT <= A xnor B;
end gate_imp;

-- Sumulating without testbench file
ARCHITECTURE test OF basic_gates IS
    SIGNAL A_sig, B_sig: STD_LOGIC := '0';
    SIGNAL AND_OUT_sig, OR_OUT_sig, NOT_OUT_sig, NAND_OUT_sig, NOR_OUT_sig, XOR_OUT_sig, XNOR_OUT_sig: STD_LOGIC;

    BEGIN
      UUT: entity work.basic_gates
        PORT MAP (
          A => A_sig,
          B => B_sig,
          AND_OUT => AND_OUT_sig,
          OR_OUT => OR_OUT_sig,
          NOT_OUT => NOT_OUT_sig,
          NAND_OUT => NAND_OUT_sig,
          NOR_OUT => NOR_OUT_sig,
          XOR_OUT => XOR_OUT_sig,
          XNOR_OUT => XNOR_OUT_sig
        );

      PROCESS
    BEGIN
        A_sig <= '0'; B_sig <= '0'; WAIT FOR 10 ns;
        A_sig <= '0'; B_sig <= '1'; WAIT FOR 10 ns;
        A_sig <= '1'; B_sig <= '0'; WAIT FOR 10 ns;
        A_sig <= '1'; B_sig <= '1'; WAIT FOR 10 ns;
        WAIT;
    END PROCESS;
END test;
