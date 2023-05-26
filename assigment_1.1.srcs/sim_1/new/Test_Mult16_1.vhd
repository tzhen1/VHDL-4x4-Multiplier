entity Test_Mult16_1 is
end; -- runs forever, use break

architecture Structure of Test_Mult16_1 is
use Work.Utils.all; 
use Work.Clock_Utils.all;
-- start starts from test bench, done from mult, if start not there, then its done (begin)
-- use assert to automate and check results
component Mult16 port
        (A, B : BIT_VECTOR(7 downto 0); 
        Start, CLK, Reset : BIT;
        Result : out BIT_VECTOR(15 downto 0); 
        Done : out BIT);
end component;

signal A, B : BIT_VECTOR(7 downto 0); -- inputs
signal Start, Done : BIT := '0'; -- init = 0
signal CLK, Reset : BIT;
signal Result : BIT_VECTOR(15 downto 0); --o/p
signal DA, DB, DR : INTEGER range 0 to 65536; --2^16

signal DR2 : INTEGER range 0 to 65536; -- check results

begin
C: Clock(CLK, 10 ns, 10 ns);
UUT: Mult16 port map (A, B, Start, CLK, Reset, Result, Done);
DR <= Convert(Result);
Reset <= '1', '0' after 1 ns;
DR2 <= Convert(Result); -- put result in here to check

process begin
        for i in 1 to 7 loop for j in 8 to 15 loop -- 8x8, 64 o/ps, 4x4 = 16 o/ps
                DA <= i; DB <= j;
                A <= Convert(i,A'Length); 
                B <= Convert(j,B'Length);
                wait until CLK'EVENT and CLK='1'; 
                wait for 1 ns;
                Start <= '1', '0' after 20 ns;
                wait until Done = '1';
                wait until CLK'EVENT and CLK='1';
        end loop; end loop;

        for i in 0 to 63 loop for j in 0 to 63 loop -- 8x8, 64 o/ps, 4x4 = 16 o/ps
                DA <= i; DB <= j;
                A <= Convert(i,A'Length); 
                B <= Convert(j,B'Length);
                wait until CLK'EVENT and CLK='1'; 
                wait for 1 ns;
                Start <= '1', '0' after 20 ns;
                wait until Done = '1';
                wait until CLK'EVENT and CLK='1';
        end loop; end loop;
        wait;
end process;

ASSERT DR = DR2
    REPORT "Difference found"
    SEVERITY NOTE;
    
end;