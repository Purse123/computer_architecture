library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder2to4 is
end entity;

architecture behaviour of decoder2to4 is
    signal encoded_in : std_logic_vector(1 downto 0);
    signal data_out : std_logic_vector(3 downto 0);

begin
  process(encoded_in)
  begin
    data_out <= "0000";

    case encoded_in is
      when "00" => data_out <= "0001";
      when "01" => data_out <= "0010";
      when "10" => data_out <= "0100";
      when "11" => data_out <= "1000";
      when others => data_out <= "0000";
    end case;
  end process;

  process
  begin
    encoded_in <= "01";
    wait for 10 ns;
    wait;
  end process;
end behaviour;
