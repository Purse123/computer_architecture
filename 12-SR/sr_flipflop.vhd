library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Empty entity for testbench
entity Testbench is
end Testbench;

architecture Behavior of Testbench is
  -- Input signals
  signal S      : STD_LOGIC := '0';  -- Set input
  signal R      : STD_LOGIC := '0';  -- Reset input
  signal CLK    : STD_LOGIC := '0';  -- Clock input
  
  -- Output signals with initialization
  signal Q      : STD_LOGIC := '0';       -- Output (initialized to 0)
  signal Q_bar  : STD_LOGIC := '1';       -- Complementary output (initialized to 1)
  
begin
  -- SR flip-flop logic directly in the testbench
  process(CLK)
  begin
    if rising_edge(CLK) then
      -- SR flip-flop state table
      if (S = '0' and R = '0') then
        -- No change (maintain current state)
        null;
      elsif (S = '0' and R = '1') then
        -- Reset
        Q <= '0';
        Q_bar <= '1';
      elsif (S = '1' and R = '0') then
        -- Set
        Q <= '1';
        Q_bar <= '0';
      else  -- S = '1' and R = '1'
        -- Invalid state
        Q <= 'X';
        Q_bar <= 'X';
      end if;
    end if;
  end process;
  
  -- Ensure Q and Q_bar are always complementary (for better simulation stability)
  -- This is outside the clocked process to maintain this relationship even at startup
  -- Q_bar <= not Q when Q /= 'X' else 'X';
  
  -- Clock generation process
  clock_gen: process
  begin
    CLK <= '0';
    wait for 5 ns;
    CLK <= '1';
    wait for 5 ns;
  end process;
  
  -- Test process with just two sets of inputs
  stimulus: process
  begin
    -- Reset the flip-flop (to ensure known initial state)
    S <= '0'; R <= '1';
    wait for 20 ns;
    
    -- Set the flip-flop
    S <= '1'; R <= '0';
    wait for 20 ns;
    
    -- End simulation
    report "Simulation complete" severity note;
    wait;
  end process;
  
  -- Simple monitor for key state changes
  monitor: process(CLK)
  begin
    if rising_edge(CLK) then
      report "Time: " & time'image(now) & 
             ", Q = " & std_logic'image(Q) &
             ", Q_bar = " & std_logic'image(Q_bar);
    end if;
  end process;
  
end Behavior;
