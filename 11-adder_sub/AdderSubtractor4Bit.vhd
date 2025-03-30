library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Empty entity for testbench
entity Testbench is
end Testbench;

architecture Behavior of Testbench is
  -- Input signals
  signal A      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
  signal B      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
  signal AddSub : STD_LOGIC := '0';
  
  -- Output signals
  signal Result : STD_LOGIC_VECTOR(3 downto 0);
  signal Cout   : STD_LOGIC;
  
  -- Internal signals (equivalent to those in the original design)
  signal B_mod  : STD_LOGIC_VECTOR(3 downto 0);
  signal Cin    : STD_LOGIC;
  signal Sum    : STD_LOGIC_VECTOR(4 downto 0);
  
begin
  -- AdderSubtractor4Bit logic directly in the testbench
  
  -- Complement B and set Carry-in for subtraction
  B_mod <= not B when AddSub = '1' else B;
  Cin   <= AddSub;
  
  -- Perform addition (A + B_mod + Cin)
  Sum <= std_logic_vector(resize(unsigned(A), 5) + resize(unsigned(B_mod), 5) + 
         ("0000" & Cin));
  
  -- Assign outputs
  Result <= Sum(3 downto 0);
  Cout   <= Sum(4);
  
  -- Test process
  stimulus: process
  begin
    -- Test cases for addition
    A <= "0100"; B <= "0011"; AddSub <= '0'; wait for 10 ns; -- 4 + 3 = 7
    A <= "1100"; B <= "0100"; AddSub <= '0'; wait for 10 ns; -- 12 + 4 = 16 (overflow)
    
    -- Test cases for subtraction
    A <= "0100"; B <= "0011"; AddSub <= '1'; wait for 10 ns; -- 4 - 3 = 1
    A <= "0011"; B <= "0100"; AddSub <= '1'; wait for 10 ns; -- 3 - 4 = -1 (in 2's complement)
    
    -- Display results (for simulators with text output)
    report "Simulation complete" severity note;
    
    -- End simulation
    wait;
  end process;
  
  -- Optional: Monitor process to display results during simulation
  monitor: process(A, B, AddSub, Result, Cout)
  begin
    if now > 0 ns then  -- Skip initial undefined state
      report "Time: " & time'image(now) & 
             ", A = " & integer'image(to_integer(unsigned(A))) &
             ", B = " & integer'image(to_integer(unsigned(B))) &
             ", AddSub = " & std_logic'image(AddSub) &
             ", Result = " & integer'image(to_integer(unsigned(Result))) &
             ", Cout = " & std_logic'image(Cout);
    end if;
  end process;
  
end Behavior;
