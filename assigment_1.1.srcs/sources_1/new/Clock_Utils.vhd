package Clock_Utils is
procedure Clock (signal C: out Bit; HT, LT:TIME);
end Clock_Utils;
package body Clock_Utils is
procedure Clock (signal C: out Bit; HT, LT:TIME) is
begin
        loop C<='1' after LT, '0' after LT + HT; wait for LT + HT;
        end loop;
end;
end Clock_Utils;