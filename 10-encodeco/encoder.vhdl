library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder4to2 is
end entity;

architecture behaviour of encoder4to2 is
  signal data_in : std_logic_vector(3 downto 0);
  signal encoded_out : std_logic_vector(1 downto 0);

begin
  process(data_in)
  begin
    case data_in is
      when "0001" => encoded_out <= "00";
      when "0010" => encoded_out <= "01";
      when "0100" => encoded_out <= "10";
      when "1000" => encoded_out <= "11";
      when others => encoded_out <= "00";
    end case;
  end process;

  process
  begin
    data_in <= "0010";
    wait for 10 ns;

    data_in <= "1000";
    wait for 10 ns;

    wait;
  end process;
end behaviour;
