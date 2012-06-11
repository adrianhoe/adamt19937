--------------------------------------------------------------------------------
-- You will have different results each time you run this test.               --
--------------------------------------------------------------------------------
with Interfaces;              use Interfaces;
with AdaMT19937;              use AdaMT19937;
with Ada.Text_Io;             use Ada.Text_Io;

procedure Test3 is

   package Unsigned_32_Text_Io is new Modular_Io (Unsigned_32);
   use Unsigned_32_Text_Io;

   G    : AdaMT19937.Generator;

begin

   AdaMT19937.Reset (G);

   Put_Line ("1000 outputs of random");
   for I in 1 .. 1000 loop
      Put (Unsigned_32'(AdaMT19937.Random (G)), 10);
      New_Line;
   end loop;

end Test3;
