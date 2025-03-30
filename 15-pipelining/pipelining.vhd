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
use STD.TEXTIO.ALL;

entity PipelinedCPU is
end PipelinedCPU;

architecture Behavioral of PipelinedCPU is
    -- Clock and reset signals
    signal clk           : STD_LOGIC := '0';
    signal reset         : STD_LOGIC := '1';
    
    -- Memory signals
    signal mem_addr      : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal mem_data_out  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal mem_data_in   : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal mem_write     : STD_LOGIC := '0';
    
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
    
    -- Registers
    type register_file_type is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal register_file : register_file_type := (others => (others => '0'));
    
    -- Pipeline registers
    -- Fetch stage registers
    signal F_pc          : unsigned(7 downto 0) := (others => '0'); -- Program counter
    
    -- Decode stage registers
    signal D_instruction : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- Current instruction
    signal D_pc          : unsigned(7 downto 0) := (others => '0');          -- PC in decode stage
    signal D_valid       : STD_LOGIC := '0';                                 -- Valid instruction in decode stage
    
    -- Execute stage registers
    signal E_opcode      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');  -- Operation code
    signal E_rd_addr     : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');  -- Destination register address
    signal E_rs1_addr    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');  -- Source register 1 address
    signal E_rs2_addr    : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');  -- Source register 2 address
    signal E_rs1_data    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- Source register 1 data
    signal E_rs2_data    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); -- Source register 2 data
    signal E_immediate   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');  -- Immediate value
    signal E_pc          : unsigned(7 downto 0) := (others => '0');          -- PC in execute stage
    signal E_valid       : STD_LOGIC := '0';                                 -- Valid instruction in execute stage
    
    -- Control signals
    signal stall_pipeline : STD_LOGIC := '0';                                -- Stall the pipeline
    signal flush_pipeline : STD_LOGIC := '0';                                -- Flush the pipeline
    signal branch_taken   : STD_LOGIC := '0';                                -- Branch taken flag
    signal branch_target  : unsigned(7 downto 0) := (others => '0');         -- Branch target address
    
    -- Hazard detection signals
    signal data_hazard    : STD_LOGIC := '0';                                -- Data hazard detected
    
    -- Debug signals - explicitly named for GTKWave
    signal debug_fetch_pc : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal debug_decode_pc : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal debug_execute_pc : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal debug_current_opcode : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal debug_r1_value : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal debug_r2_value : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal debug_r3_value : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal debug_r4_value : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal debug_r5_value : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    -- Simulation control
    signal simulation_running : BOOLEAN := true;
    signal cycle_count : INTEGER := 0;
    signal instruction_count : INTEGER := 0;
    
begin
    -- Connect debug signals
    debug_fetch_pc <= std_logic_vector(F_pc);
    debug_decode_pc <= std_logic_vector(D_pc);
    debug_execute_pc <= std_logic_vector(E_pc);
    debug_current_opcode <= E_opcode;
    debug_r1_value <= register_file(1);
    debug_r2_value <= register_file(2);
    debug_r3_value <= register_file(3);
    debug_r4_value <= register_file(4);
    debug_r5_value <= register_file(5);
    
    -- Memory interface (read)
    mem_data_out <= memory(to_integer(unsigned(mem_addr))) when (unsigned(mem_addr) < 256) else (others => '0');
    
    -- Memory write process
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                if unsigned(mem_addr) < 256 then  -- Bounds check to prevent undefined accesses
                    memory(to_integer(unsigned(mem_addr))) <= mem_data_in;
                end if;
            end if;
        end if;
    end process;
    
    -- Fetch Stage
    fetch_stage: process(clk, reset)
    begin
        if reset = '1' then
            F_pc <= (others => '0');
            D_valid <= '0';
            D_instruction <= (others => '0');
            D_pc <= (others => '0');
            
        elsif rising_edge(clk) then
            if stall_pipeline = '0' then
                -- Update PC based on branch or normal flow
                if branch_taken = '1' then
                    F_pc <= branch_target;
                else
                    F_pc <= F_pc + 1;
                end if;
                
                -- Update decode stage registers
                if flush_pipeline = '1' then
                    D_valid <= '0';
                    D_instruction <= (others => '0');  -- Clear instruction on flush
                else
                    mem_addr <= std_logic_vector(F_pc);
                    D_instruction <= memory(to_integer(F_pc)) when (F_pc < 256) else (others => '0');
                    D_pc <= F_pc;
                    D_valid <= '1';
                    if D_valid = '1' then
                        instruction_count <= instruction_count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Decode Stage
    decode_stage: process(clk, reset)
    begin
        if reset = '1' then
            E_opcode <= (others => '0');
            E_rd_addr <= (others => '0');
            E_rs1_addr <= (others => '0');
            E_rs2_addr <= (others => '0');
            E_immediate <= (others => '0');
            E_rs1_data <= (others => '0');
            E_rs2_data <= (others => '0');
            E_pc <= (others => '0');
            E_valid <= '0';
            
        elsif rising_edge(clk) then
            if stall_pipeline = '0' then
                if flush_pipeline = '1' then
                    E_valid <= '0';
                    E_opcode <= (others => '0');  -- Clear on flush
                elsif D_valid = '1' then
                    -- Decode instruction
                    E_opcode <= D_instruction(15 downto 12);
                    E_rd_addr <= D_instruction(11 downto 8);
                    E_rs1_addr <= D_instruction(7 downto 4);
                    E_rs2_addr <= D_instruction(3 downto 0);
                    E_immediate <= D_instruction(3 downto 0);
                    E_pc <= D_pc;
                    E_valid <= '1';
                    
                    -- Read register file - with bounds checking to avoid red signals
                    if unsigned(D_instruction(7 downto 4)) < 16 then
                        E_rs1_data <= register_file(to_integer(unsigned(D_instruction(7 downto 4))));
                    else
                        E_rs1_data <= (others => '0');
                    end if;
                    
                    if unsigned(D_instruction(3 downto 0)) < 16 then
                        E_rs2_data <= register_file(to_integer(unsigned(D_instruction(3 downto 0))));
                    else
                        E_rs2_data <= (others => '0');
                    end if;
                else
                    E_valid <= '0';
                    E_opcode <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    -- Execute Stage
    execute_stage: process(clk, reset)
        variable alu_result : STD_LOGIC_VECTOR(15 downto 0);
        variable reg_idx : integer;
    begin
        if reset = '1' then
            branch_taken <= '0';
            branch_target <= (others => '0');
            mem_write <= '0';
            
        elsif rising_edge(clk) then
            -- Default values
            branch_taken <= '0';
            mem_write <= '0';
            flush_pipeline <= '0';
            alu_result := (others => '0');
            
            -- Execute instruction
            if E_valid = '1' then
                case E_opcode is
                    when OP_NOP =>
                        -- No operation
                        null;
                        
                    when OP_LOAD =>
                        -- Load from memory (address in Rs1)
                        mem_addr <= E_rs1_data(7 downto 0);
                        mem_write <= '0';
                        -- Write back to register file in the same cycle for simplicity
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= mem_data_out;
                        end if;
                        
                    when OP_STORE =>
                        -- Store to memory (address in Rd, data in Rs1)
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            mem_addr <= register_file(reg_idx)(7 downto 0);
                            mem_data_in <= E_rs1_data;
                            mem_write <= '1';
                        end if;
                        
                    when OP_ADD =>
                        -- Add Rs1 and Rs2, store in Rd
                        alu_result := std_logic_vector(unsigned(E_rs1_data) + unsigned(E_rs2_data));
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when OP_SUB =>
                        -- Subtract Rs2 from Rs1, store in Rd
                        alu_result := std_logic_vector(unsigned(E_rs1_data) - unsigned(E_rs2_data));
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when OP_AND =>
                        -- Logical AND of Rs1 and Rs2, store in Rd
                        alu_result := E_rs1_data and E_rs2_data;
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when OP_OR =>
                        -- Logical OR of Rs1 and Rs2, store in Rd
                        alu_result := E_rs1_data or E_rs2_data;
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when OP_XOR =>
                        -- Logical XOR of Rs1 and Rs2, store in Rd
                        alu_result := E_rs1_data xor E_rs2_data;
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when OP_JUMP =>
                        -- Jump to address in Rs1
                        branch_target <= unsigned(E_rs1_data(7 downto 0));
                        branch_taken <= '1';
                        flush_pipeline <= '1';
                        
                    when OP_BEQ =>
                        -- Branch if Rs1 equals Rs2
                        if E_rs1_data = E_rs2_data then
                            branch_target <= E_pc + unsigned(resize(signed(E_immediate), 8));
                            branch_taken <= '1';
                            flush_pipeline <= '1';
                        end if;
                        
                    when OP_ADDI =>
                        -- Add immediate value to Rs1, store in Rd
                        alu_result := std_logic_vector(unsigned(E_rs1_data) + unsigned(resize(unsigned(E_immediate), 16)));
                        reg_idx := to_integer(unsigned(E_rd_addr));
                        if reg_idx < 16 and reg_idx >= 0 then
                            register_file(reg_idx) <= alu_result;
                        end if;
                        
                    when others =>
                        -- Unknown opcode
                        null;
                end case;
            end if;
        end if;
    end process;
    
    -- Hazard detection
    -- Simplified data hazard detection (bounds checking added)
    hazard_detect: process(E_valid, E_opcode, E_rd_addr, D_instruction, D_valid)
        variable D_rs1_addr : STD_LOGIC_VECTOR(3 downto 0);
        variable D_rs2_addr : STD_LOGIC_VECTOR(3 downto 0);
    begin
        data_hazard <= '0';
        
        if D_valid = '1' then
            D_rs1_addr := D_instruction(7 downto 4);
            D_rs2_addr := D_instruction(3 downto 0);
            
            -- Check if executing instruction writes to a register needed by decoding instruction
            if E_valid = '1' then
                if (E_opcode = OP_ADD or E_opcode = OP_SUB or E_opcode = OP_AND or 
                    E_opcode = OP_OR or E_opcode = OP_XOR or E_opcode = OP_ADDI or 
                    E_opcode = OP_LOAD) then
                    
                    if E_rd_addr = D_rs1_addr or E_rd_addr = D_rs2_addr then
                        data_hazard <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Pipeline control based on hazards
    stall_pipeline <= data_hazard;
    
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
        file outfile : text;
        variable outline : line;
    begin
        -- Open output file for writing simulation results
        file_open(outfile, "simulation_results.txt", write_mode);
        
        -- Initialize reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Load test program into memory
        -- Program: Compute sum of values 1 to 5
        -- R1: loop counter, R2: sum accumulator
        memory(0) <= OP_ADDI & "0001" & "0000" & "0001";  -- ADDI R1, R0, 1 (R1 = 1)
        memory(1) <= OP_ADDI & "0010" & "0000" & "0000";  -- ADDI R2, R0, 0 (R2 = 0)
        memory(2) <= OP_ADD  & "0010" & "0010" & "0001";  -- ADD R2, R2, R1 (R2 += R1)
        memory(3) <= OP_ADDI & "0001" & "0001" & "0001";  -- ADDI R1, R1, 1 (R1++)
        memory(4) <= OP_ADDI & "0011" & "0000" & "0110";  -- ADDI R3, R0, 6 (R3 = 6)
        memory(5) <= OP_SUB  & "0100" & "0011" & "0001";  -- SUB R4, R3, R1 (R4 = R3 - R1)
        memory(6) <= OP_BEQ  & "0000" & "0100" & "0000";  -- BEQ R0, R4, 0 (if R4 == 0, finished)
        memory(7) <= OP_JUMP & "0000" & "0000" & "0010";  -- JUMP 2 (go to loop)
        memory(8) <= OP_ADDI & "0101" & "0010" & "0000";  -- ADDI R5, R2, 0 (copy result to R5)
        
        -- Let the program run for a fixed number of cycles
        wait for 300 ns; -- Run for 30 clock cycles
        
        -- Stop simulation
        simulation_running <= false;
        
        -- Write results to file
        write(outline, string'("Simulation completed after "));
        write(outline, cycle_count);
        write(outline, string'(" cycles"));
        writeline(outfile, outline);
        
        write(outline, string'("Instructions executed: "));
        write(outline, instruction_count);
        writeline(outfile, outline);
        
        write(outline, string'("Final register values:"));
        writeline(outfile, outline);
        
        write(outline, string'("R1 = "));
        write(outline, to_integer(unsigned(register_file(1))));
        writeline(outfile, outline);
        
        write(outline, string'("R2 = "));
        write(outline, to_integer(unsigned(register_file(2))));
        writeline(outfile, outline);
        
        write(outline, string'("R5 = "));
        write(outline, to_integer(unsigned(register_file(5))));
        writeline(outfile, outline);
        
        -- Verify result
        if to_integer(unsigned(register_file(2))) = 15 then
            write(outline, string'("Test PASSED! Sum = 15"));
        else
            write(outline, string'("Test FAILED! Expected sum = 15, got "));
            write(outline, to_integer(unsigned(register_file(2))));
        end if;
        writeline(outfile, outline);
        
        file_close(outfile);
        
        -- Print to console as well
        report "Simulation completed after " & integer'image(cycle_count) & " cycles";
        report "Instructions executed: " & integer'image(instruction_count);
        report "Final register values:";
        report "R1 = " & integer'image(to_integer(unsigned(register_file(1)))) & 
               ", R2 = " & integer'image(to_integer(unsigned(register_file(2)))) &
               ", R5 = " & integer'image(to_integer(unsigned(register_file(5))));
        
        -- Verify result (sum of 1 to 5 = 15)
        assert to_integer(unsigned(register_file(2))) = 15
            report "Test failed! Expected sum = 15, got " & 
                   integer'image(to_integer(unsigned(register_file(2))))
            severity error;
        
        wait;
    end process;
    
    -- Simple process to dump pipeline state to a VCD-compatible format
    -- This helps GTKWave display clear and consistent signals
    process(clk)
        file vcdfile : text;
        variable vcdline : line;
        variable first_time : boolean := true;
    begin
        if rising_edge(clk) then
            if first_time then
                file_open(vcdfile, "pipeline_state.vcd", write_mode);
                write(vcdline, string'("$date"));
                writeline(vcdfile, vcdline);
                write(vcdline, string'("  Current time"));
                writeline(vcdfile, vcdline);
                write(vcdline, string'("$end"));
                writeline(vcdfile, vcdline);
                file_close(vcdfile);
                first_time := false;
            end if;
            
            file_open(vcdfile, "pipeline_state.vcd", append_mode);
            
            write(vcdline, string'("# Cycle "));
            write(vcdline, cycle_count);
            write(vcdline, string'(": "));
            
            if D_valid = '1' then
                write(vcdline, string'("D="));
                write(vcdline, to_integer(D_pc));
                write(vcdline, string'(" "));
            else
                write(vcdline, string'("D=INVALID "));
            end if;
            
            if E_valid = '1' then
                write(vcdline, string'("E="));
                write(vcdline, to_integer(E_pc));
                write(vcdline, string'(" Op="));
                write(vcdline, to_integer(unsigned(E_opcode)));
            else
                write(vcdline, string'("E=INVALID"));
            end if;
            
            writeline(vcdfile, vcdline);
            file_close(vcdfile);
        end if;
    end process;
    
end Behavioral;
