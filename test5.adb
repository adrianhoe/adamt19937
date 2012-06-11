with Interfaces;              use Interfaces;
with AdaMT19937;              use AdaMT19937;
with Ada.Text_Io;             use Ada.Text_Io;

procedure Test5 is

   package Unsigned_32_Text_Io is new Modular_Io (Unsigned_32);
   use Unsigned_32_Text_Io;

   G    : AdaMT19937.Generator;

begin
   
   -- Reset with time seed
   AdaMT19937.Reset (G);

   Put_Line ("10 outputs of random");
   for I in 1 .. 10 loop
      Put (Unsigned_32'(AdaMT19937.Random (G)), 10);
      New_Line;
   end loop;
   
   -- Restart again
   AdaMT19937.Restart (G);
   
   New_Line;
   Put_Line ("Another 10 outputs of random and should be ");
   Put_Line ("Identical after restore to initial state.");
   for I in 1 .. 10 loop
      Put (Unsigned_32'(AdaMT19937.Random (G)), 10);
      New_Line;
   end loop;
   
end Test5;
