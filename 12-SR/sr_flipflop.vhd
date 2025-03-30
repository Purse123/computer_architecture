library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sr is
end sr;

architecture Behavior of sr is
  signal S      : STD_LOGIC := '0';  -- Set input
  signal R      : STD_LOGIC := '0';  -- Reset input
  signal CLK    : STD_LOGIC := '0';  -- Clock input
  signal Q      : STD_LOGIC := '0';       -- Output (initialized to 0)
  signal Q_bar  : STD_LOGIC := '1';       -- Complementary output (initialized to 1)
  
begin
  process(CLK)
  begin
    if rising_edge(CLK) then
      if (S = '0' and R = '0') then
        null;
      elsif (S = '0' and R = '1') then
        Q <= '0';
        Q_bar <= '1';
      elsif (S = '1' and R = '0') then
        Q <= '1';
        Q_bar <= '0';
      else
        Q <= 'X';
        Q_bar <= 'X';
      end if;
    end if;
  end process;
  
  clock_gen: process
  begin
    CLK <= '0';
    wait for 5 ns;
    CLK <= '1';
    wait for 5 ns;
  end process;
  
  stimulus: process
  begin
    S <= '0'; R <= '1';
    wait for 20 ns;
    
    S <= '1'; R <= '0';
    wait for 20 ns;
    
    report "Simulation complete" severity note;
    wait;
  end process;
  
  monitor: process(CLK)
  begin
    if rising_edge(CLK) then
      report "Time: " & time'image(now) & 
             ", Q = " & std_logic'image(Q) &
             ", Q_bar = " & std_logic'image(Q_bar);
    end if;
  end process;
  
end Behavior;
