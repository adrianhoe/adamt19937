--------------------------------------------------------------------------------
--|          A D A M T 1 9 9 3 7 . I N T E G E R _ U T I L I T I E S         |--
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
package body AdaMT19937.Integer_Utilities is

   -----------------------------------------------------------------------------
   --| Generates random numbers on [0, 0x7fffffff]-interval |--
   function Random_Long_Integer (G : in Generator) return Long_Integer is
   begin
      return Long_Integer (Shift_Right (Random (G), 1));
   end Random_Long_Integer;
   
   -----------------------------------------------------------------------------
   --| Generate positive short_integer random numbers |--
   function Random_Short_Integer (G : in Generator) return Short_Integer is
      Mask : constant Unsigned_32 := 2#111111111111111#; -- 15 bits
   begin
      return Short_Integer (Random (G) and Mask);
   end Random_Short_Integer;

   -----------------------------------------------------------------------------
   --| Generate positive short integer in the range of 0 .. 9999 |--
   function Random_4_Digit (G : in Generator ) return Short_Integer is
      Mask : constant Unsigned_32 := 2#11111111111111#;   -- 14 bits
      Num  : Unsigned_32;
   begin
      loop
	 Num := Random (G);
	 Num := Num and Mask;
         exit when Num in 0 .. 9999;
      end loop;
      return Short_Integer (Num);
   end Random_4_Digit;

   -----------------------------------------------------------------------------

end Adamt19937.Integer_Utilities;
