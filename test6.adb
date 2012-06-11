with Ada.Text_Io;                use Ada.Text_Io;
with Ada.Integer_Text_Io;        use Ada.Integer_Text_Io;
with AdaMT19937; use AdaMT19937;
with Interfaces; use Interfaces;

procedure Test6 is
   G    : AdaMT19937.Generator;
   Keys : AdaMT19937.Access_Vector := new AdaMT19937.Vector (1 .. 4);
begin
   Keys.all := (16#123#, 16#234#, 16#345#, 16#456#);
   Reset (G, Keys);
   declare
      S2     : String := Save (G);
      G1, G2 : AdaMT19937.Generator;
   begin
      New_Line;
      Put_Line ("Random of G");
      Put_Line ("-----------");
      for N in 1 .. 10 loop
         Put_Line (Unsigned_32'Image (Random (G)));
      end loop;

      -- G1 and G2 should generate same random as G at G's initial state.
      Reset (G1, S2);
      New_Line (2);
      Put_Line ("Random of G1");
      Put_Line ("------------");
      for N in 1 .. 10 loop
         Put_Line (Unsigned_32'Image (Random (G1)));
      end loop;
      Reset (G2, S2);
      New_Line (2);
      Put_Line ("Random of G2");
      Put_Line ("------------");
      for N in 1 .. 10 loop
         Put_Line (Unsigned_32'Image (Random (G2)));
      end loop;
   end;
   New_Line;
end Test6;
