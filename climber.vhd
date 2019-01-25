library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.types.all;

entity climber is
    port (
        clk  : in  std_logic := '0';
        go   : in  std_logic := '0';
        root : in  std_logic_vector(9 downto 0) := (others => '0');
        peak : out std_logic_vector(17 downto 0) := (others => '0');
        len  : out std_logic_vector(7 downto 0) := (others => '0');
        done : out std_logic := '0'
    );
end climber;

architecture RTL of climber is

    signal root_reg : std_logic_vector(17 downto 0) := (others => '0');
    signal peak_reg : std_logic_vector(17 downto 0) := (others => '0');
    signal len_reg  : std_logic_vector(7 downto 0) := (others => '0');

begin

    peak <= peak_reg;
    len  <= len_reg;
    done <= '1' when root_reg = 1 else '0';

    process(clk)

        variable root_var : std_logic_vector(17 downto 0) := (others => '0');
        variable peak_var : std_logic_vector(17 downto 0) := (others => '0');
        variable len_var  : std_logic_vector(7 downto 0) := (others => '0');

    begin
        if rising_edge(clk) then
            if go = '1' then
                root_var := "00000000" & root;
                peak_var := (others => '0');
                len_var  := (others => '0');
            else
                root_var := root_reg;
                peak_var := peak_reg;
                len_var  := len_reg;

                if root_var(15 downto 0) = "0000000000000000" then
                  root_var := "0000000000000000" & root_var(17 downto 16);
                  len_var := len_var + 15;
                elsif root_var(14 downto 0) = "000000000000000" then
                  root_var := "000000000000000" & root_var(17 downto 15);
                  len_var := len_var + 14;
                elsif root_var(13 downto 0) = "00000000000000" then
                  root_var := "00000000000000" & root_var(17 downto 14);
                  len_var := len_var + 13;
                elsif root_var(12 downto 0) = "0000000000000" then
                  root_var := "0000000000000" & root_var(17 downto 13);
                  len_var := len_var + 12;
                elsif root_var(11 downto 0) = "000000000000" then
                  root_var := "000000000000" & root_var(17 downto 12);
                  len_var := len_var + 11;
                elsif root_var(10 downto 0) = "00000000000" then
                  root_var := "00000000000" & root_var(17 downto 11);
                  len_var := len_var + 10;
                elsif root_var(9 downto 0) = "0000000000" then
                  root_var := "0000000000" & root_var(17 downto 10);
                  len_var := len_var + 9;
                elsif root_var(8 downto 0) = "000000000" then
                  root_var := "000000000" & root_var(17 downto 9);
                  len_var := len_var + 8;
                elsif root_var(7 downto 0) = "00000000" then
                  root_var := "00000000" & root_var(17 downto 8);
                  len_var := len_var + 7;
                elsif root_var(6 downto 0) = "0000000" then
                  root_var := "0000000" & root_var(17 downto 7);
                  len_var := len_var + 6;
                elsif root_var(5 downto 0) = "000000" then
                  root_var := "000000" & root_var(17 downto 6);
                   len_var := len_var + 5;
                elsif root_var(4 downto 0) = "00000" then
                  root_var := "00000" & root_var(17 downto 5);
                  len_var := len_var + 4;
                elsif root_var(3 downto 0) = "0000" then
                  root_var := "0000" & root_var(17 downto 4);
                  len_var := len_var + 3;
                elsif root_var(2 downto 0) = "000" then
                  root_var := "000" & root_var(17 downto 3);
                  len_var := len_var + 2;
                elsif root_var(1 downto 0) = "00" then
                  root_var := "00" & root_var(17 downto 2);
                  len_var := len_var + 1;
                
                elsif root_var(0) = '1' then
                    root_var := (root_var(16 downto 0) & '1') + root_var;

                    if peak_var < root_var then
                        peak_var := root_var;
                    end if;
                    root_var := '0' & root_var(17 downto 1);
                    len_var := len_var + 1;
                else
                    root_var := '0' & root_var(17 downto 1);
                end if;

                len_var  := len_var + 1;
            end if;
        end if;

        root_reg <= root_var;
        peak_reg <= peak_var;
        len_reg  <= len_var;
    end process;

end RTL;
