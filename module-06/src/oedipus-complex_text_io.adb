-- FILE: oedipus-complex_text_io.adb LICENSE: MIT © 2021 Mae Morella

with Oedipus, Ada.Float_Text_IO, Ada.Text_IO;
use Oedipus, Ada.Float_Text_IO, Ada.Text_IO;

package body Oedipus.Complex_Text_IO is

   subtype Field is Ada.Text_IO.Field;

   procedure Put
     (Item : in Complex; Fore : in Field := Default_Fore;
      Aft  : in Field := Default_Aft; Exp : in Field := Default_Exp)
   is
   begin
      Put (Get_Real (Item), Fore, Aft, Exp);
      Put (" + ");
      Put (Get_Imaginary (Item), Fore, Aft, Exp);
      Put ("i");
   end Put;

   procedure Get (Item : out Complex) is
      A : Float;
      B : Float;
   begin
      Put ("Enter real component: ");
      Get (A);
      Put ("Enter imaginary component: ");
      Get (B);
      Item := Create_Complex (A, B);
   end Get;

end Oedipus.Complex_Text_IO;
