library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 4-bit Adder-Subtractor Entity
entity AdderSubtractor4Bit is
end AdderSubtractor4Bit;

architecture Behavioral of AdderSubtractor4Bit is
  signal A      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal B      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal AddSub : STD_LOGIC := '0';
  signal Result : STD_LOGIC_VECTOR(3 downto 0);
  signal Cout   : STD_LOGIC;
  signal B_mod  : STD_LOGIC_VECTOR(3 downto 0);
  signal Cin    : STD_LOGIC;
  signal Sum    : STD_LOGIC_VECTOR(4 downto 0);
begin
  -- Complement B and set Carry-in for subtraction
  B_mod <= not B when AddSub = '1' else B;
  Cin   <= AddSub;

  -- Perform addition (A + B_mod + Cin)
  Sum   <= ('0' & A) + ('0' & B_mod) + ("0000" & Cin);

  -- Assign outputs
  Result <= Sum(3 downto 0);
  Cout   <= Sum(4);
end Behavioral;
