--------------------------------------------------------------------------------
-- 167 seconds and 77 seconds has been recorded running this test on 300MHz   --
-- P2 / AMD-K6-2, Linux without -O switch and with -O3 switch respectively.   --
--------------------------------------------------------------------------------

with AdaMT19937;
with Interfaces; use Interfaces;
with Ada.Calendar; use Ada.Calendar;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

procedure Test2 is
   G      : AdaMT19937.Generator;
   Keys   : AdaMT19937.Access_Vector := new AdaMT19937.Vector (0 .. 3);
   N, R   : Unsigned_32;
   T1, T2 : Time;
   D      : Day_Duration;
begin

   Keys.all := (16#123#, 16#234#, 16#345#, 16#456#);
   AdaMT19937.Reset (G, Keys);

   N := 0;
   T1 := Clock;
   while N < 300_000_000 loop
      R := AdaMT19937.Random (G);
      N := N + 1;
   end loop;
   T2 := Clock;
   D  := Seconds (T2) - Seconds (T1);
   Put (Integer (D));

end Test2;

