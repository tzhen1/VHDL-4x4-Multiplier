entity Mux8 is
        generic (TPD : TIME := 1 ns);
        port (A, B : in BIT_VECTOR (7 downto 0);
                Sel : in BIT := '0';
                Y : out BIT_VECTOR (7 downto 0));
end;
architecture Behave of Mux8 is
begin
        Y <= A after TPD when Sel = '1' else B
         after TPD;
end;