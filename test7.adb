with Interfaces;                   use Interfaces;
with AdaMT19937.Integer_Utilities; use AdaMT19937.Integer_Utilities;
with Ada.Text_Io;                  use Ada.Text_Io;
with Ada.Long_Float_Text_Io;       use Ada.Long_Float_Text_Io;

procedure Test7 is

   package Unsigned_32_Text_Io is new Modular_Io (Unsigned_32);
   use Unsigned_32_Text_Io;

   G    : AdaMT19937.Generator;
   Keys : AdaMT19937.Access_Vector := new AdaMT19937.Vector (1 .. 4);

begin

   Keys.all := (16#123#, 16#234#, 16#345#, 16#456#);

   AdaMT19937.Reset (G, Keys);

   Put_Line ("Generates 10 long_integers.");
   for I in 1 .. 10 loop
      Put (Long_Integer'Image (Random_Long_Integer (G)));
      New_Line;
   end loop;

   New_Line;
   Put_Line ("Generates 10 short_integers.");
   for I in 1 .. 10 loop
      Put (Short_Integer'Image (Random_Short_Integer (G)));
      New_Line;
   end loop;

end Test7;
