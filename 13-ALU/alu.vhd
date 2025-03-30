library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aluTB is
end aluTB;

architecture Behavior of aluTB is
  -- ALU Inputs
  signal A         : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- 4-bit input A
  signal B         : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- 4-bit input B
  signal ALU_Sel   : STD_LOGIC_VECTOR(2 downto 0) := "000";   -- 3-bit operation select
  
  -- ALU Outputs
  signal ALU_Out   : STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit output result
  signal Carry_Out : STD_LOGIC;                      -- Carry out flag
  
begin
  -- ALU process
  alu_process: process(A, B, ALU_Sel)
    variable temp : STD_LOGIC_VECTOR(4 downto 0);
  begin
    -- Default values
    temp := (others => '0');
    
    -- Perform operation based on ALU_Sel
    case ALU_Sel is
      when "000" =>  -- Addition
        temp := std_logic_vector(resize(unsigned(A), 5) + resize(unsigned(B), 5));
      
      when "001" =>  -- Subtraction (A - B)
        temp := std_logic_vector(resize(unsigned(A), 5) - resize(unsigned(B), 5));
      
      when "010" =>  -- AND operation
        temp := '0' & (A and B);
      
      when "011" =>  -- OR operation
        temp := '0' & (A or B);
      
      when "100" =>  -- XOR operation
        temp := '0' & (A xor B);
      
      when "101" =>  -- Invert A (NOT A)
        temp := '0' & (not A);
      
      when "110" =>  -- Return B
        temp := '0' & B;
      
      when "111" =>  -- Return A
        temp := '0' & A;
      
      when others =>
        temp := (others => '0');
    end case;
    
    -- Set outputs
    Carry_Out <= temp(4);      -- MSB is carry out
    ALU_Out <= temp(3 downto 0);  -- 4-bit result
  end process;
  
  -- Test process
  stimulus: process
  begin
    -- Test all operations with sample inputs
    A <= "1010";  -- A = 10 in decimal
    B <= "0011";  -- B = 3 in decimal
    
    -- Test Addition: 10 + 3 = 13 (carry = 0, result = 1101)
    ALU_Sel <= "000";
    wait for 10 ns;
    
    -- Test Subtraction: 10 - 3 = 7 (carry = 0, result = 0111)
    ALU_Sel <= "001";
    wait for 10 ns;
    
    -- Test AND: 1010 AND 0011 = 0010
    ALU_Sel <= "010";
    wait for 10 ns;
    
    -- Test OR: 1010 OR 0011 = 1011
    ALU_Sel <= "011";
    wait for 10 ns;
    
    -- Test XOR: 1010 XOR 0011 = 1001
    ALU_Sel <= "100";
    wait for 10 ns;
    
    -- Test Invert A: NOT 1010 = 0101
    ALU_Sel <= "101";
    wait for 10 ns;
    
    -- Test Return B: B = 0011
    ALU_Sel <= "110";
    wait for 10 ns;
    
    -- Test Return A: A = 1010
    ALU_Sel <= "111";
    wait for 10 ns;
    
    -- Test overflow with Addition: 15 + 3 = 18 (result = 0010, carry = 1)
    A <= "1111";  -- A = 15 in decimal
    B <= "0011";  -- B = 3 in decimal
    ALU_Sel <= "000";
    wait for 10 ns;
    
    -- End simulation
    report "Simulation complete" severity note;
    wait;
  end process;
  
  -- Monitor process to display results
  monitor: process(A, B, ALU_Sel, ALU_Out, Carry_Out)
  begin
    if now > 0 ns then
      report "Time: " & time'image(now) & 
             ", A = " & integer'image(to_integer(unsigned(A))) &
             ", B = " & integer'image(to_integer(unsigned(B))) &
             ", ALU_Sel = " & integer'image(to_integer(unsigned(ALU_Sel))) &
             ", ALU_Out = " & integer'image(to_integer(unsigned(ALU_Out))) &
             ", Carry_Out = " & std_logic'image(Carry_Out);
    end if;
  end process;
  
end Behavior;
