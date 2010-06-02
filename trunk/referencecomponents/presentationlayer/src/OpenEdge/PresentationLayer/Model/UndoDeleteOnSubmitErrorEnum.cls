/*------------------------------------------------------------------------
    File        : UndoDeleteOnSubmitErrorEnum
    Purpose     : Decides whether to immediately undo deleted records after a failed submit 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 19 14:36:29 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Model.UndoDeleteOnSubmitErrorEnum final:
    define public static property Default as EnumMember get. private set.
    /* Only undo deletions that causes an error and keep deletions that was 
       rejected just because the transaction failed. Allows immediate 
       resubmit.  (Default) */
    define public static property Error as EnumMember get. private set.
     
    /* Undo all deleted records. */
    define public static property All as EnumMember get. private set.

    /* Keep all deletions. Fix the problem and resave */
    define public static property None as EnumMember get. private set.
    
    constructor static UndoDeleteOnSubmitErrorEnum ():
        UndoDeleteOnSubmitErrorEnum:Error = new EnumMember(1).
        UndoDeleteOnSubmitErrorEnum:All = new EnumMember(2).
        UndoDeleteOnSubmitErrorEnum:None = new EnumMember(3).
        
        UndoDeleteOnSubmitErrorEnum:Default = UndoDeleteOnSubmitErrorEnum:Error.
    end constructor.
end class.