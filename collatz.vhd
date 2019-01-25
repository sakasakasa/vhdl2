library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.types.all;

entity collatz is
    port (
        clk       : in  std_logic := '0';
        clk_count : out std_logic_vector(31 downto 0) := (others => '0');
        top4      : out chains4_t := (others => ((others => '0'), (others => '0'), (others => '0')))
    );
end collatz;

architecture RTL of collatz is

    component climber is
        port (
            clk  : in  std_logic;
            go   : in  std_logic;
            root : in  std_logic_vector(9 downto 0);
            peak : out std_logic_vector(17 downto 0);
            len  : out std_logic_vector(7 downto 0);
            done : out std_logic
        );
    end component;

    component sorter is
        port (
            clk   : in  std_logic;
            chain : in  chain_t;
            top4  : out chains4_t
        );
    end component;

    signal clk_count_reg : std_logic_vector(31 downto 0) := (others => '0');

    signal alldone : std_logic := '0';
    signal alldone2 : std_logic := '0';

    signal go   : std_logic := '1';
    signal go2 : std_logic := '1';
    signal root : std_logic_vector(7 downto 0) := (others => '0');
    signal root2 : std_logic_vector(7 downto 0) := (others => '0');
    signal peak : std_logic_vector(17 downto 0) := (others => '0');
    signal peak2 : std_logic_vector(17 downto 0) := (others => '0');
    signal len  : std_logic_vector(7 downto 0) := (others => '0');
    signal len2 : std_logic_vector(7 downto 0) := (others => '0');
    signal done : std_logic := '0';
    signal done2 : std_logic := '0';

    signal root_chain : std_logic_vector(9 downto 0) := (others => '0');
    signal root_chain2 : std_logic_vector(9 downto 0) := (others => '0');

    signal chain_reg : chain_t := ((others => '0'), (others => '0'), (others => '0'));
    signal chain_reg2 : chain_t := ((others => '0'), (others => '0'), (others => '0'));

begin

    climber_p : climber port map(
        clk  => clk,
        go   => go,
        root => root_chain,
        peak => peak,
        len  => len,
        done => done
    );

    sorter_p : sorter port map(
        clk   => clk,
        chain => chain_reg,
        top4  => top4
    );

    clk_count <= clk_count_reg;
    root_chain <= root & "01";

    process(clk, alldone)
    begin
        if rising_edge(clk) and alldone2 = '0'  then
            clk_count_reg <= clk_count_reg + 1;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if done = '1' and alldone = '0' then
                chain_reg <= (root & "01", peak, len);
                root <= root + 1;

                if root >= 255 then
                    alldone <= '1';
                else
                    go <= '1';
                end if;
            else
                go <= '0';
            end if;
        end if;
    end process;

    climber_q : climber port map (
      clk  => clk,
      go   => go2,
      root => root_chain2,
      peak => peak2,
      len  => len2,
      done => done2);

    sorter_q : sorter port map (
      clk   => clk,
      chain => chain_reg2,
      top4  => top4);

    root_chain2 <= root2 & "11";

    process (clk)
    begin  -- process
      if rising_edge(clk) then
        if done2 = '1' and alldone2 = '0' then
          chain_reg2 <= (root2 & "11", peak2, len2);
          root2 <= root2 + 1;

          if root2 >= 255 then
            alldone2 <= '1';
          else
            go2 <= '1';
          end if;
          else
            go2 <= '0';
        end if;
      end if;
    end process;

end RTL;
