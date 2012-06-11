--------------------------------------------------------------------------------
--|                            A D A M T 1 9 9 3 7                           |--
--|                                                                          |--
--|                                  S p e c                                 |--
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
with Interfaces;   use Interfaces;

package AdaMT19937 is

   -- Basic facilities

   type Generator     is limited private;

   type Vector        is array (Integer range <>) of Unsigned_32;
   type Access_Vector is access Vector;

   type Flt is digits 14;

   -- Now MT allows zero for the seed:
   subtype Seed_Type is Unsigned_32;


   function  Random  (G        : in     Generator) return Unsigned_32;

   procedure Restart (G        : in     Generator);

   procedure Restore (G        : in     Generator;
                      From_Gen : in     Generator);

   procedure Save    (G        : in     Generator;
                      To_Gen   :    out Generator);

   function  Save    (G        : in     Generator) return String;

   procedure Reset   (G        : in     Generator);

   procedure Reset   (G        : in     Generator;
                      From_Gen : in     Generator);

   procedure Reset   (G        : in     Generator;
                      New_Seed : in     Seed_Type);

   procedure Reset   (G        : in     Generator;
                      New_Seed : in     Seed_Type;
                      New_Keys : in     Access_Vector);

   procedure Reset   (G        : in     Generator;
                      New_Keys : in     Access_Vector);

   procedure Reset   (G        : in     Generator;
                      G_String : in     String);

private

   N            : constant := 624;                   -- Length of state vector
   M            : constant := 397;                   -- Period parameter

   Invalid      : constant := N + 1;

   Default_Seed : constant Seed_Type := 19_650_218;

   Upper_Mask   : constant := 16#80000000#;          -- Most significant w-r bits
   Lower_Mask   : constant := 16#7FFFFFFF#;          -- Least significant r bits

   ---------------------------------------------------------------------------
   --| DO NOT CHANGE THE STRING OF GEN_TAG. You will VIOLATE the copyright |--
   --| if you change it.                                                   |--
   ---------------------------------------------------------------------------
   -- This text appears at the front of any saved state created by Save
   Gen_Tag      : constant String := "AdaMT19937 Generator State: ";


   type State_Record is record
      Vector_N  : Vector (0 .. N);
      Condition : Integer := Invalid;
   end record;

   type Generator_Record is record
      State  : State_Record;
      Seed   : Seed_Type := Default_Seed;
      Keys   : Access_Vector;
   end record;

   type Generator        is new Generator_Record;

   type Access_Generator is access all Generator;
   type Access_State     is access all State_Record;

   function Magic  (S : in Unsigned_32) return Unsigned_32;

   procedure Init_By_Seed (G : in Generator);
   procedure Init_By_Keys (G : in Generator);

end AdaMT19937;
