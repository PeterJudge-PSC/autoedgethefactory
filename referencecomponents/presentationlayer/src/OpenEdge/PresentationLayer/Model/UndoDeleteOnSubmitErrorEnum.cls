/** ------------------------------------------------------------------------
    File        : UndoDeleteOnSubmitErrorEnum
    Purpose     : Decides whether to immediately undo deleted records after a failed submit 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 19 14:36:29 EDT 2009
    Notes       : * These values taken from ADM2 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.Model.UndoDeleteOnSubmitErrorEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Model.UndoDeleteOnSubmitErrorEnum final inherits EnumMember:
    
    define public static property Default as UndoDeleteOnSubmitErrorEnum get. private set.
    
    /** Only undo deletions that causes an error and keep deletions that was 
       rejected just because the transaction failed. Allows immediate resubmit. */
    define public static property Error as UndoDeleteOnSubmitErrorEnum get. private set.
     
    /** Undo all deleted records. */
    define public static property All as UndoDeleteOnSubmitErrorEnum get. private set.

    /** Keep all deletions. Fix the problem and resave */
    define public static property None as UndoDeleteOnSubmitErrorEnum get. private set.
    
    constructor static UndoDeleteOnSubmitErrorEnum ():
        UndoDeleteOnSubmitErrorEnum:Error = new UndoDeleteOnSubmitErrorEnum('Error').
        UndoDeleteOnSubmitErrorEnum:All = new UndoDeleteOnSubmitErrorEnum('All').
        UndoDeleteOnSubmitErrorEnum:None = new UndoDeleteOnSubmitErrorEnum('None').
        
        UndoDeleteOnSubmitErrorEnum:Default = UndoDeleteOnSubmitErrorEnum:Error.
    end constructor.

    constructor public UndoDeleteOnSubmitErrorEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.