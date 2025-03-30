--
-- Author: Pierce Neupane
--
-- ##########################
--
-- STILL ON GOING
-- SOME ERROR STILL IN VARIABLE I SUPPOSE
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity StandaloneCPU is
end StandaloneCPU;

architecture Behavioral of StandaloneCPU is
    -- Clock and reset signals
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '1';
    
    -- Memory signals
    signal mem_addr  : STD_LOGIC_VECTOR(7 downto 0);
    signal mem_data  : STD_LOGIC_VECTOR(15 downto 0);
    signal mem_write : STD_LOGIC;
    
    -- Memory implementation (256 x 16-bit)
    type memory_type is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
    signal memory : memory_type := (others => (others => '0'));
    
    -- Instruction format:
    -- 15-12: Opcode
    -- 11-8: Destination Register (Rd)
    -- 7-4: Source Register 1 (Rs1)
    -- 3-0: Source Register 2 (Rs2) or Immediate value
    
    -- Opcodes
    constant OP_NOP   : STD_LOGIC_VECTOR(3 downto 0) := "0000"; -- No operation
    constant OP_LOAD  : STD_LOGIC_VECTOR(3 downto 0) := "0001"; -- Load from memory
    constant OP_STORE : STD_LOGIC_VECTOR(3 downto 0) := "0010"; -- Store to memory
    constant OP_ADD   : STD_LOGIC_VECTOR(3 downto 0) := "0011"; -- Addition
    constant OP_SUB   : STD_LOGIC_VECTOR(3 downto 0) := "0100"; -- Subtraction
    constant OP_AND   : STD_LOGIC_VECTOR(3 downto 0) := "0101"; -- Logical AND
    constant OP_OR    : STD_LOGIC_VECTOR(3 downto 0) := "0110"; -- Logical OR
    constant OP_XOR   : STD_LOGIC_VECTOR(3 downto 0) := "0111"; -- Logical XOR
    constant OP_JUMP  : STD_LOGIC_VECTOR(3 downto 0) := "1000"; -- Jump
    constant OP_BEQ   : STD_LOGIC_VECTOR(3 downto 0) := "1001"; -- Branch if equal
    constant OP_ADDI  : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- Add immediate
    
    -- CPU States
    type state_type is (FETCH, DECODE, EXECUTE, MEMORY_ACCESS, WRITE_BACK);
    signal current_state : state_type;
    
    -- Registers
    type register_file_type is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal register_file : register_file_type := (others => (others => '0'));
    
    -- Internal signals
    signal pc          : unsigned(7 downto 0) := (others => '0'); -- Program counter
    signal instruction : STD_LOGIC_VECTOR(15 downto 0);           -- Current instruction
    signal opcode      : STD_LOGIC_VECTOR(3 downto 0);            -- Operation code
    signal rd_addr     : STD_LOGIC_VECTOR(3 downto 0);            -- Destination register address
    signal rs1_addr    : STD_LOGIC_VECTOR(3 downto 0);            -- Source register 1 address
    signal rs2_addr    : STD_LOGIC_VECTOR(3 downto 0);            -- Source register 2 address
    signal rs1_data    : STD_LOGIC_VECTOR(15 downto 0);           -- Source register 1 data
    signal rs2_data    : STD_LOGIC_VECTOR(15 downto 0);           -- Source register 2 data
    signal alu_result  : STD_LOGIC_VECTOR(15 downto 0);           -- ALU result
    signal immediate   : STD_LOGIC_VECTOR(3 downto 0);            -- Immediate value
    signal load_data   : STD_LOGIC_VECTOR(15 downto 0);           -- Data to be loaded from memory
    
    -- Simulation control
    signal simulation_running : BOOLEAN := true;
    signal cycle_count : INTEGER := 0;
    
begin
    -- Instruction decoding
    opcode    <= instruction(15 downto 12);
    rd_addr   <= instruction(11 downto 8);
    rs1_addr  <= instruction(7 downto 4);
    rs2_addr  <= instruction(3 downto 0);
    immediate <= instruction(3 downto 0);
    
    -- Register file read
    rs1_data <= register_file(to_integer(unsigned(rs1_addr)));
    rs2_data <= register_file(to_integer(unsigned(rs2_addr)));
    
    -- Memory interface (simplified memory model)
    load_data <= memory(to_integer(unsigned(mem_addr)));
    
    -- Memory write process
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                memory(to_integer(unsigned(mem_addr))) <= mem_data;
            end if;
        end if;
    end process;
    
    -- CPU process
    cpu_process: process(clk, reset)
    begin
        if reset = '1' then
            -- Reset CPU state
            pc <= (others => '0');
            mem_write <= '0';
            current_state <= FETCH;
            register_file <= (others => (others => '0'));
            
        elsif rising_edge(clk) then
            case current_state is
                -- Fetch instruction from memory
                when FETCH =>
                    mem_addr <= std_logic_vector(pc);
                    mem_write <= '0';
                    instruction <= memory(to_integer(pc));
                    current_state <= DECODE;
                
                -- Decode instruction
                when DECODE =>
                    current_state <= EXECUTE;
                
                -- Execute instruction
                when EXECUTE =>
                    case opcode is
                        when OP_NOP =>
                            -- No operation
                            pc <= pc + 1;
                            current_state <= FETCH;
                            
                        when OP_LOAD =>
                            -- Load from memory (address in Rs1)
                            mem_addr <= rs1_data(7 downto 0);
                            mem_write <= '0';
                            current_state <= MEMORY_ACCESS;
                            
                        when OP_STORE =>
                            -- Store to memory (address in Rd, data in Rs1)
                            mem_addr <= register_file(to_integer(unsigned(rd_addr)))(7 downto 0);
                            mem_data <= rs1_data;
                            mem_write <= '1';
                            pc <= pc + 1;
                            current_state <= FETCH;
                            
                        when OP_ADD =>
                            -- Add Rs1 and Rs2, store in Rd
                            alu_result <= std_logic_vector(unsigned(rs1_data) + unsigned(rs2_data));
                            current_state <= WRITE_BACK;
                            
                        when OP_SUB =>
                            -- Subtract Rs2 from Rs1, store in Rd
                            alu_result <= std_logic_vector(unsigned(rs1_data) - unsigned(rs2_data));
                            current_state <= WRITE_BACK;
                            
                        when OP_AND =>
                            -- Logical AND of Rs1 and Rs2, store in Rd
                            alu_result <= rs1_data and rs2_data;
                            current_state <= WRITE_BACK;
                            
                        when OP_OR =>
                            -- Logical OR of Rs1 and Rs2, store in Rd
                            alu_result <= rs1_data or rs2_data;
                            current_state <= WRITE_BACK;
                            
                        when OP_XOR =>
                            -- Logical XOR of Rs1 and Rs2, store in Rd
                            alu_result <= rs1_data xor rs2_data;
                            current_state <= WRITE_BACK;
                            
                        when OP_JUMP =>
                            -- Jump to address in Rs1
                            pc <= unsigned(rs1_data(7 downto 0));
                            current_state <= FETCH;
                            
                        when OP_BEQ =>
                            -- Branch if Rs1 equals Rs2
                            if rs1_data = rs2_data then
                                pc <= pc + unsigned(resize(signed(immediate), 8));
                            else
                                pc <= pc + 1;
                            end if;
                            current_state <= FETCH;
                            
                        when OP_ADDI =>
                            -- Add immediate value to Rs1, store in Rd
                            alu_result <= std_logic_vector(unsigned(rs1_data) + unsigned(resize(unsigned(immediate), 16)));
                            current_state <= WRITE_BACK;
                            
                        when others =>
                            -- Unknown opcode, skip
                            pc <= pc + 1;
                            current_state <= FETCH;
                    end case;
                
                -- Memory access stage
                when MEMORY_ACCESS =>
                    alu_result <= load_data;
                    current_state <= WRITE_BACK;
                
                -- Write back stage
                when WRITE_BACK =>
                    register_file(to_integer(unsigned(rd_addr))) <= alu_result;
                    pc <= pc + 1;
                    current_state <= FETCH;
            end case;
        end if;
    end process;
    
    -- Clock generation
    process
    begin
        if simulation_running then
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            cycle_count <= cycle_count + 1;
        else
            wait;
        end if;
    end process;
    
    -- Test program initialization and simulation control
    process
    begin
        -- Initialize reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        
        -- Load test program into memory
        -- Program: Calculate Fibonacci sequence in registers
        -- R1 = 1, R2 = 1, then R3 = R1 + R2, R1 = R2, R2 = R3, and repeat
        memory(0) <= OP_ADDI & "0001" & "0000" & "0001";  -- ADDI R1, R0, 1 (Set R1 = 1)
        memory(1) <= OP_ADDI & "0010" & "0000" & "0001";  -- ADDI R2, R0, 1 (Set R2 = 1)
        memory(2) <= OP_ADD  & "0011" & "0001" & "0010";  -- ADD R3, R1, R2 (R3 = R1 + R2)
        memory(3) <= OP_ADD  & "0001" & "0010" & "0000";  -- ADD R1, R2, R0 (R1 = R2)
        memory(4) <= OP_ADD  & "0010" & "0011" & "0000";  -- ADD R2, R3, R0 (R2 = R3)
        memory(5) <= OP_JUMP & "0000" & "0000" & "0010";  -- JUMP to address 2 (loop)
        
        -- Let the program run for a number of cycles to generate Fibonacci sequence
        wait for 400 ns; -- Run for 40 clock cycles
        
        -- Stop simulation
        simulation_running <= false;
        
        -- Report results
        report "Simulation completed. Fibonacci sequence generated:";
        report "R1 = " & integer'image(to_integer(unsigned(register_file(1)))) &
               ", R2 = " & integer'image(to_integer(unsigned(register_file(2)))) &
               ", R3 = " & integer'image(to_integer(unsigned(register_file(3))));
               
        wait;
    end process;
    
    -- Monitor process to display CPU state during execution
    process(clk)
    begin
        if rising_edge(clk) and cycle_count > 0 and cycle_count mod 4 = 0 then
            report "Cycle: " & integer'image(cycle_count) &
                   ", PC: " & integer'image(to_integer(pc)) &
                   ", State: " & state_type'image(current_state) &
                   ", R1: " & integer'image(to_integer(unsigned(register_file(1)))) &
                   ", R2: " & integer'image(to_integer(unsigned(register_file(2)))) &
                   ", R3: " & integer'image(to_integer(unsigned(register_file(3))));
        end if;
    end process;
    
end Behavioral;
