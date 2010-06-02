/*------------------------------------------------------------------------
   File        : DialogResultEnum
   Purpose     : 
   Syntax      :  
   Description : 
   Author(s)   : pjudge
   Created     : Tue Dec 23 16:07:44 EST 2008
   Notes       : * Based on System.Windows.Forms.DialogResult 
 ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.DialogResultEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Common.DialogResultEnum final: 

    define public static property Abort     as EnumMember no-undo get. private set.
    define public static property Cancel    as EnumMember no-undo get. private set.
    define public static property Ignore    as EnumMember no-undo get. private set.
    define public static property ResultNo  as EnumMember no-undo get. private set.
    define public static property None      as EnumMember no-undo get. private set.
    define public static property OK        as EnumMember no-undo get. private set.
    define public static property Retry     as EnumMember no-undo get. private set.
    define public static property ResultYes as EnumMember no-undo get. private set.
    
    constructor static DialogResultEnum():
        DialogResultEnum:Abort = new EnumMember('Abort').
        DialogResultEnum:Cancel = new EnumMember('Cancel').
        DialogResultEnum:Ignore = new EnumMember('Ignore').
        DialogResultEnum:ResultNo = new EnumMember('No').
        DialogResultEnum:None = new EnumMember('None').
        DialogResultEnum:OK = new EnumMember('OK').
        DialogResultEnum:Retry = new EnumMember('Retry').
        DialogResultEnum:ResultYes = new EnumMember('Yes').
    end constructor.
    
end class.