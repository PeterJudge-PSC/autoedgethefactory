/** ------------------------------------------------------------------------
   File        : DialogResultEnum
   Purpose     : Enumeration of dialog close results.
   Syntax      :  
   Description : 
   @author pjudge
   Created     : Tue Dec 23 16:07:44 EST 2008
   Notes       : * Based on System.Windows.Forms.DialogResult
                 * We have an ABL implementation because not all of the UI we
                   work with will be .NET-based.  
 ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.DialogResultEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Common.DialogResultEnum final inherits EnumMember: 

    define public static property Abort     as DialogResultEnum no-undo get. private set.
    define public static property Cancel    as DialogResultEnum no-undo get. private set.
    define public static property Ignore    as DialogResultEnum no-undo get. private set.
    define public static property ResultNo  as DialogResultEnum no-undo get. private set.
    define public static property None      as DialogResultEnum no-undo get. private set.
    define public static property OK        as DialogResultEnum no-undo get. private set.
    define public static property Retry     as DialogResultEnum no-undo get. private set.
    define public static property ResultYes as DialogResultEnum no-undo get. private set.
    
    constructor static DialogResultEnum():
        DialogResultEnum:Abort = new DialogResultEnum('Abort').
        DialogResultEnum:Cancel = new DialogResultEnum('Cancel').
        DialogResultEnum:Ignore = new DialogResultEnum('Ignore').
        DialogResultEnum:ResultNo = new DialogResultEnum('No').
        DialogResultEnum:None = new DialogResultEnum('None').
        DialogResultEnum:OK = new DialogResultEnum('OK').
        DialogResultEnum:Retry = new DialogResultEnum('Retry').
        DialogResultEnum:ResultYes = new DialogResultEnum('Yes').
    end constructor.

	constructor public DialogResultEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
    
end class.