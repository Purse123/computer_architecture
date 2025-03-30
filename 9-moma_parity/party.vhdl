library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parity_gen_check is
end entity;

architecture behaviour of parity_gen_check is
    signal data_in : std_logic_vector(7 downto 0);
    signal parity_type : std_logic; -- '0' for even parity, '1' for odd parity
    signal parity_bit : std_logic;
    signal received_parity : std_logic;
    signal error_flag : std_logic;
begin
    -- Parity Generator
    process(data_in, parity_type)
        variable parity_calc : std_logic;
    begin
        parity_calc := data_in(0) xor data_in(1) xor data_in(2) xor data_in(3) xor
                       data_in(4) xor data_in(5) xor data_in(6) xor data_in(7);
        
        if parity_type = '0' then
            parity_bit <= parity_calc;
        else
            parity_bit <= not parity_calc;
        end if;
    end process;

    -- Parity Checker
    process(data_in, received_parity)
        variable parity_check : std_logic;
    begin
        parity_check := data_in(0) xor data_in(1) xor data_in(2) xor data_in(3) xor
                        data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor received_parity;
        
        if parity_check = '1' then
            error_flag <= '1';
        else
            error_flag <= '0';
        end if;
    end process;

    -- Test values
    process
    begin
        data_in <= "11001100"; 
        parity_type <= '0'; 
        received_parity <= '1'; 
        wait for 10 ns;
        
        wait;
    end process;
end behaviour;
