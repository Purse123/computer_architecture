library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder4to2 is
end entity;

architecture behaviour of encoder4to2 is
  signal data_in : std_logic_vector(3 downto 0);
  signal decoded : std_logic_vector(1 downto 0);

begin
  process(data_in)
  begin
    case data_in is
      when "0001" => decoded <= "00";
      when "0010" => decoded <= "01";
      when "0100" => decoded <= "10";
      when "1000" => decoded <= "11";
      when others => decoded <= "00";
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
