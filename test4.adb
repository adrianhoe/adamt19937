with Interfaces;                 use Interfaces;
with AdaMT19937.Float_Utilities; use AdaMT19937.Float_Utilities;
with Ada.Text_Io;                use Ada.Text_Io;
with Ada.Long_Float_Text_Io;     use Ada.Long_Float_Text_Io;

procedure Test4 is
   G    : AdaMT19937.Generator;
   Keys : AdaMT19937.Access_Vector := new AdaMT19937.Vector (1 .. 4);
begin

   Keys.all := (16#123#, 16#234#, 16#345#, 16#456#);

   AdaMT19937.Reset (G, Keys);

   Put_Line ("10 outputs of random_1");
   for I in 1 .. 10 loop
      Put (Random_1 (G), 1, 8, 0);
      New_Line;
   end loop;

   New_Line;
   Put_Line ("10 outputs of random_2");
   for I in 1 .. 10 loop
      Put (Random_2 (G), 1, 8, 0);
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

end Test4;
