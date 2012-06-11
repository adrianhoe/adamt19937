with Interfaces;                   use Interfaces;
with AdaMT19937;                   use AdaMT19937;
with AdaMT19937.Integer_Utilities; use AdaMT19937.Integer_Utilities;
with AdaMT19937.Float_Utilities;   use AdaMT19937.Float_Utilities;
with Ada.Text_Io;                  use Ada.Text_Io;
with Ada.Long_Float_Text_Io;       use Ada.Long_Float_Text_Io;

procedure Test1 is

   package Unsigned_32_Text_Io is new Modular_Io (Unsigned_32);
   use Unsigned_32_Text_Io;

   G    : AdaMT19937.Generator;
   Keys : AdaMT19937.Access_Vector := new AdaMT19937.Vector (1 .. 4);

begin

   Keys.all := (16#123#, 16#234#, 16#345#, 16#456#);

   AdaMT19937.Reset (G, Keys);

   Put_Line ("1000 outputs of random");
   for I in 1 .. 1000 loop
      Put (Unsigned_32'(Random (G)), 10);
      New_Line;
   end loop;

   New_Line;
   Put_Line ("1000 outputs of random_2");
   for I in 1 .. 1000 loop
      Put (Random_2 (G), 1, 8, 0);
      New_Line;
   end loop;

   New_Line;
   Put_Line ("10 outputs of random_1");
   for I in 1 .. 10 loop
      Put (Random_1 (G), 1, 8, 0);
      New_Line;
   end loop;

   New_Line;
   Put_Line ("10 outputs of random_3");
   for I in 1 .. 10 loop
      Put (Random_3 (G), 1, 8, 0);
      New_Line;
   end loop;

   New_Line;
   Put_Line ("10 outputs of random_53");
   for I in 1 .. 10 loop
      Put (Random_53 (G), 1, 8, 0);
      New_Line;
   end loop;

   Put_Line ("1000 outputs of random_long_integer");
   for I in 1 .. 1000 loop
      Put (Long_Integer'Image (Random_Long_Integer (G)));
      New_Line;
   end loop;

end Test1;
