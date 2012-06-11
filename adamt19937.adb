--------------------------------------------------------------------------------
--|                            A D A M T 1 9 9 3 7                           |--
--|                                                                          |--
--|                                  B o d y                                 |--
--|                                                                          |--
--|                              $Revision 1.2 $                             |--
--|                                                                          |--
--| AdaMT19937 Pseudo Random Number Generator version 1.2                    |--
--| Copyright 2002, Adrian Hoe, byhoe@greenlime.com.                         |--
--|                                                                          |--
--| This is an Ada implementation  of  improved  initialization  (2002/1/26) |--
--| revision by Makoto Matsumoto and Takuji Nishimura  of `Mersenne Twister' |--
--| random number generator MT19937.  The state vector is  initialized by an |--
--| array. Makoto Matsumoto and Takuji Nishimura implemented their algorithm |--
--| in C.  This is an Ada implementation by Adrian Hoe (byhoe@greenlime.com) |--
--| on Jan 28, 2002.  Lexical Integration (M) Sdn Bhd disclaimed  all rights |--
--| of Adrian's work. This copyright message header is not to be removed.    |--
--|                                                                          |--
--| Bobby D.  Bryant  <bdbryant@mail.utexas.edu>  of  University  of  Texas, |--
--| Austin has been contributing to this latest revision of AdaMT19937.      |--
--|                                                                          |--
--| This library is free software;  you can redistribute it and/or modify it |--
--| under  the terms of the  GNU Library General Public License as published |--
--| by the  Free Software Foundation (either version 2 of the License or, at |--
--| your option, any later version). This library is distributed in the hope |--
--| that  it will be useful,  but  WITHOUT ANY WARRANTY,  without  even  the |--
--| implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. |--
--| See the GNU Library General Public License for more details.  You should |--
--| have  received  a copy of the  GNU Library General Public License  along |--
--| with this library;  if not, write to the Free Software Foundation, Inc., |--
--| 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.                  |--
--|                                                                          |--
--| As  a special exception,  if other files instantiate generics from  this |--
--| unit,  or you link this unit with other files to produce an  executable, |--
--| this  unit does  not by  itself cause  the  resulting  executable to  be |--
--| covered  by the  GNU General Public License.  This  exception  does  not |--
--| however  invalidate any other reasons  why the executable file might  be |--
--| covered by the GNU Public License.                                       |--
--|                                                                          |--
--| The code as Adrian received it included the following notice:            |--
--|                                                                          |--
--|   Copyright (C) 1997, 2002 Makoto Matsumoto  and Takuji Nishimura.  When |--
--|   you  use this,  send an e-mail to <matumoto@math.keio.ac.jp>  with  an |--
--|   appropriate reference to your work.                                    |--
--|                                                                          |--
--| It would be nice to CC: <byhoe@greenlime.com> when you write.            |--
--------------------------------------------------------------------------------
with Unchecked_Deallocation;
with Ada.Calendar;

package body AdaMT19937 is

   -----------------------------------------------------------------------------
   function Magic (S : in Unsigned_32) return Unsigned_32 is
      SS : Unsigned_32 := S and 16#1#;
   begin
      if SS = 1 then
         return 16#9908B0DF#;
      else
         return 0;
      end if;
   end Magic;

   -----------------------------------------------------------------------------
   --| Generates random numbers on [0, 0xffffffff]-interval |--
   function Random (G : in Generator) return Unsigned_32 is
      State : Access_State := G.State'Unrestricted_Access;
      S     : Unsigned_32;
   begin
      if State.Condition >= N then

         if State.Condition = Invalid then
            Reset (G);
         end if;

         for J in 0 .. (N - M - 1) loop

            S := (State.Vector_N (J) and Upper_Mask) or
              (State.Vector_N (J + 1) and Lower_Mask);

            State.Vector_N (J) := State.Vector_N (J + M) xor
              Shift_Right (S, 1) xor Magic (S);

         end loop;

         for J in 227 .. (N - 2) loop

            S := (State.Vector_N (J) and Upper_Mask) or
              (State.Vector_N (J + 1) and Lower_Mask);

            State.Vector_N (J) := State.Vector_N (J + (M - N)) xor
              Shift_Right (S, 1) xor Magic (S);

         end loop;

         S := (State.Vector_N (N - 1) and Upper_Mask) or
           (State.Vector_N (0) and Lower_Mask);

         State.Vector_N (N - 1) := State.Vector_N (M - 1) xor
           Shift_Right (S, 1) xor Magic (S);

         State.Condition := 0;
      end if;

      -----------------
      --| Tempering |--
      -----------------
      S := State.Vector_N (State.Condition);

      State.Condition := State.Condition + 1;

      S := S xor Shift_Right (S, 11);
      S := S xor (Shift_Left (S,  7) and 16#9D2C5680#);
      S := S xor (Shift_Left (S, 15) and 16#EFC60000#);
      S := S xor Shift_Right (S, 18);

      return S;

   end Random;

   -----------------------------------------------------------------------------
   procedure Init_By_Seed (G : in Generator) is
      State : Access_State   := G.State'Unrestricted_Access;
   begin
      State.Vector_N (0) := G.Seed and 16#FFFFFFFF#;

      for I in 1 .. N loop
         State.Vector_N (I) := (1_812_433_253 *
                                (State.Vector_N (I - 1) xor
                                 Shift_Right (State.Vector_N (I - 1), 30)) +
                                Unsigned_32 (I));
         State.Vector_N (I) := State.Vector_N (I) and 16#FFFFFFFF#;
         State.Condition := I;
      end loop;
   end Init_By_Seed;

   -----------------------------------------------------------------------------
   procedure Init_By_Keys (G : in Generator) is
      State      : Access_State := G.State'Unrestricted_Access;
      I          : Integer := 1;
      J          : Integer := 0;
      K, L       : Integer;
      Key_Length : Integer;
   begin
      Init_By_Seed (G);

      if G.Keys /= null then

         ---------------------------------------------------------------
         --| Allow allocation of Keys (0 .. X) and Keys (1 .. X).    |--
         --| Otherwise both Keys will generate different results     |--
         --| even though the values of Keys are identical. This is   |--
         --| because the index of the array is used to generate      |--
         --| State Vector as in G.Keys (J + K).                      |--
         ---------------------------------------------------------------
         K := G.Keys'First;

         if G.Keys'First = 0 then
            Key_Length := G.Keys'Last + 1;
         elsif G.Keys'First > 0 then
            Key_Length := G.Keys'Last;
         end if;
         ---------------------------------------------------------------

         if N > Key_Length then
            L := N;
         else
            L := Key_Length;
         end if;

         for X in reverse 1 .. L loop
            State.Vector_N (I) := (State.Vector_N (I) xor
                                   ((State.Vector_N (I - 1) xor
                                     Shift_Right (State.Vector_N (I - 1), 30)) *
                                    1_664_525)) + G.Keys (J + K) + Unsigned_32 (J);

            State.Vector_N (I) := State.Vector_N (I) and 16#FFFFFFFF#;
            I := I + 1;
            J := J + 1;
            if I >= N then
               State.Vector_N (0) := State.Vector_N (N - 1);
               I := 1;
            end if;
            if J >= Key_Length then
               J := 0;
            end if;
         end loop;

         for X in reverse 1 .. N - 1 loop
            State.Vector_N (I) := (State.Vector_N (I) xor
                                   ((State.Vector_N (I - 1) xor
                                     Shift_Right (State.Vector_N (I - 1), 30)) *
                                    1_566_083_941)) - Unsigned_32 (I);
            I := I + 1;
            if I >= N then
               State.Vector_N (0) := State.Vector_N (N - 1);
               I := 1;
            end if;
         end loop;

         State.Vector_N (0) := Upper_Mask;
      end if;           --  G.Keys /= null
   end Init_By_Keys;

   -----------------------------------------------------------------------------
   --| Restart initial state of generator |--
   procedure Restart (G : in Generator) is
   begin
      Init_By_Keys (G);
   end Restart;

   -----------------------------------------------------------------------------
   --| Restore from other generator |--
   procedure Restore (G        : in Generator;
                      From_Gen : in Generator)
   is
      Gen : Access_Generator := G'Unrestricted_Access;
   begin
      Gen.all := Generator (From_Gen);
   end Restore;

   -----------------------------------------------------------------------------
   --| Save the state of generator |--
   procedure Save (G      : in     Generator;
                   To_Gen :    out Generator)
   is
   begin
      To_Gen := Generator (G);
   end Save;

   -----------------------------------------------------------------------------
   --| Save the state of generator to string buffer |--
   function Save (G : in Generator) return String is
      State_Length : Positive := G.State'Size / Standard.Character'Size;
      State_Buffer : String (1 .. State_Length);
      for State_Buffer use at G.State'Address;

      Seed_Length  : Positive := G.Seed'Size / Standard.Character'Size;
      Seed_Buffer  : String (1 .. Seed_Length);
      for Seed_Buffer use at G.Seed'Address;

      Total_Length : Positive := Gen_Tag'Length + State_Length + Seed_Length;
      Keys_Length  : Integer := 0;
   begin
      if G.Keys /= null then
         Keys_Length := G.Keys.all'Size / Standard.Character'Size;
         Total_Length := Total_Length + Keys_Length;
         declare
            Keys_Buffer : String (1 .. Positive (Keys_Length));
            for Keys_Buffer use at G.Keys.all'Address;
         begin
            return (Gen_Tag
                    & "<"
                    & Integer'Image (Keys_Length)
                    & ">"
                    & State_Buffer
                    & Seed_Buffer
                    & Keys_Buffer);
         end;
      else
            return (Gen_Tag
                    & "<"
                    & Integer'Image (Keys_Length)
                    & ">"
                    & State_Buffer
                    & Seed_Buffer);
      end if;
   end Save;

   -----------------------------------------------------------------------------
   --| Reset with time as seed |--
   procedure Reset (G : in Generator) is

      package Calendar renames Ada.Calendar;

      --------------------------------------------------------------
      --| The following code in this Reset procedure is adapted  |--
      --| from GNAT Run-Time Component Package                   |--
      --| Ada.Numerics.Float_Random (a-nuflra.adb). This package |--
      --| is originally contributed by Robert Eachus. For more   |--
      --| copyright statement, please refer to a-nuflra.adb      |--
      --------------------------------------------------------------
      function Square_Mod_N (X, N : Integer_32) return Integer_32 is
         Temp : Flt := Flt (X) * Flt (X);
         Div  : Integer_32 := Integer_32 (Temp / Flt (N));
      begin
         Div := Integer_32 (Temp - Flt (Div) * Flt (N));

         if Div < 0 then
            return Div + N;
         else
            return Div;
         end if;
      end Square_Mod_N;

      K1        : constant := 94_833_359;
      K2        : constant := 47_416_679;
      Now       : constant Calendar.Time := Calendar.Clock;

      Time_Seed : Seed_Type;
      X1, X2    : Integer_32;
   begin
      X1 := Integer_32 (Calendar.Year  (Now)) * 12 * 31 +
        Integer_32 (Calendar.Month (Now)) * 31 +
        Integer_32 (Calendar.Day   (Now));

      X2 := Integer_32 (Calendar.Seconds (Now) * Duration (1000.0));

      X1 := 2 + X1 mod (K1 - 3);
      X2 := 2 + X2 mod (K2 - 3);

      --| Eliminate visible effects of same day starts |--

      for J in 1 .. 5 loop
         X1 := Square_Mod_N (X1, K1);
         X2 := Square_Mod_N (X2, K2);
      end loop;

      --| Adrian's modification |--
      Time_Seed := Unsigned_32 (X1) or Unsigned_32 (X2);
      Reset (G, Time_Seed);
   end Reset;

   -----------------------------------------------------------------------------
   --| Reset from other generator|--
   procedure Reset (G        : in Generator;
                    From_Gen : in Generator)
   is
      Gen : Access_Generator := G'Unrestricted_Access;
   begin
      Gen.all := Generator (From_Gen);
      Init_By_Keys (G);
   end Reset;

   -----------------------------------------------------------------------------
   --| Reset with new seed |--
   procedure Reset (G        : in Generator;
                    New_Seed : in Seed_Type)
   is
      Gen : Access_Generator := G'Unrestricted_Access;
   begin
      Gen.Seed := New_Seed;
      Init_By_Keys (G);
   end Reset;

   -----------------------------------------------------------------------------
   procedure Free is new Unchecked_Deallocation (Vector, Access_Vector);

   -----------------------------------------------------------------------------
   --| By calling the following Reset functions, it is user's responsibility |--
   --| to keep track of dynamically allocated Access_Vector to prevent       |--
   --| dangling memory space.                                                |--
   -----------------------------------------------------------------------------
   --| Reset with new seed and new keys |--
   --| Gen.Keys = null to remove Keys   |--
   procedure Reset (G        : in Generator;
                    New_Seed : in Seed_Type;
                    New_Keys : in Access_Vector)
   is
      Gen : Access_Generator := G'Unrestricted_Access;
   begin
      Gen.Seed := New_Seed;
      Free (Gen.Keys);
      Gen.Keys := New_Keys;
      Init_By_Keys (G);
   end Reset;

   -----------------------------------------------------------------------------
   --| Reset with new keys              |--
   --| Gen.Keys = null to remove Keys   |--
   procedure Reset (G        : in Generator;
                    New_Keys : in Access_Vector)
   is
      Gen : Access_Generator := G'Unrestricted_Access;
   begin
      Free (Gen.Keys);
      Gen.Keys := New_Keys;
      Init_By_Keys (G);
   end Reset;

   -----------------------------------------------------------------------------
   --| Reset with saved Generator in string buffer |--
   procedure Reset (G        : in Generator;
                    G_String : in String)
   is
      Gen          : Access_Generator := G'Unrestricted_Access;
      State_Length : Positive := G.State'Size / Standard.Character'Size;
      State_Buffer : String (1 .. State_Length);
      for State_Buffer use at G.State'Address;

      Seed_Length  : Positive := G.Seed'Size / Standard.Character'Size;
      Seed_Buffer  : String (1 .. Seed_Length);
      for Seed_Buffer use at G.Seed'Address;

      Keys_Length  : Integer := 0;
      Start, Stop  : Integer;
   begin
      --| Sanity check if G_String is saved state of generator |--
      if G_String (G_String'First .. G_String'First + Gen_Tag'Length - 1)
        /= Gen_Tag then
         raise Constraint_Error;
      end if;

      --| Get the number of keys saved, 0 if no keys |--
      --| Skip the tag and "<":                      |--
      Start := G_String'First + Gen_Tag'Length + 1;
      Stop  := Start;
      while G_String (Stop) /= '>' loop
         Stop := Stop + 1;
      end loop;
      Keys_Length := Integer'Value (G_String (Start .. (Stop - 1)));

      --| Get State |--
      Start := Stop + 1;
      declare
         Target : String (1 .. State_Length);
         for Target use at Gen.State'Address;
      begin
         Stop := Start + State_Length;
         Target := G_String (Start .. Stop - 1);
      end;

      --| Get Seed |--
      Start := Stop;
      declare
         Target : String (1 .. Seed_Length);
         for Target use at Gen.Seed'Address;
      begin
         Stop := Start + Seed_Length;
         Target := G_String ( Start .. Stop - 1);
      end;

      --| Get Keys |--
      Start := Stop;
      if Keys_Length > 0 then
         declare
            Keys   : Access_Vector := new Vector (1 .. Keys_Length / 4);
            Target : String ( 1 .. Keys_Length);
            for Target use at Keys'Address;
         begin
            Stop := Start + Keys_Length;
            Target := G_String (Start .. Stop - 1);
            Free (Gen.Keys);
            Gen.Keys := Keys;
         end;
      end if;
   end Reset;

   -----------------------------------------------------------------------------

end AdaMT19937;
