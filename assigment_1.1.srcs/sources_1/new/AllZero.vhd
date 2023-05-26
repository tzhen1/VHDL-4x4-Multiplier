entity AllZero is
        generic (TPD : TIME := 1 ns);
        port (X : BIT_VECTOR;
              F : out BIT );
end;
architecture Behave of AllZero is
begin process (X) begin F <= '1' after TPD;
        for j in X'RANGE loop
                if X(j) = '1' then
                       F <= '0' after TPD; end if;

        end loop;
end process;
end;