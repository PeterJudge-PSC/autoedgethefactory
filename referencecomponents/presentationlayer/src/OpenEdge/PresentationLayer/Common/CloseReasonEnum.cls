/** ------------------------------------------------------------------------
    File        : CloseReasonEnum
    Purpose     : Form/window close reason enumeration
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu May 21 15:08:33 EDT 2009
    Notes       : * Based on System.Windows.Forms.CloseReason
                  * We have an ABL implementation because not all of the UI we
                    work with will be .NET-based.  
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.Common.CloseReasonEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.Common.CloseReasonEnum final inherits EnumMember: 

    /* The cause of the closure was not defined or could not be determined.*/
    define public static property None                as CloseReasonEnum no-undo get. private set.
    /* The operating system is closing all applications before shutting down.*/
    define public static property WindowsShutDown     as CloseReasonEnum no-undo get. private set.
    /* The parent form of this multiple document interface (MDI) form is closing.*/
    define public static property MdiFormClosing      as CloseReasonEnum no-undo get. private set.
    /* The user is closing the form through the user interface (UI), for example 
       by clicking the Close button on the form window, selecting Close from the
       window's control menu, or pressing ALT+F4.*/
    define public static property UserClosing         as CloseReasonEnum no-undo get. private set.
    /* The Microsoft Windows Task Manager is closing the application. */
    define public static property TaskManagerClosing  as CloseReasonEnum no-undo get. private set.
    /* The owner form is closing.*/
    define public static property FormOwnerClosing    as CloseReasonEnum no-undo get. private set.
    /* The Exit method of the Application class was invoked.*/
    define public static property ApplicationExitCall as CloseReasonEnum no-undo get. private set.
    
    constructor static CloseReasonEnum():
        CloseReasonEnum:None = new CloseReasonEnum('None').
        CloseReasonEnum:WindowsShutDown = new CloseReasonEnum('WindowsShutDown').
        CloseReasonEnum:MdiFormClosing = new CloseReasonEnum('MdiFormClosing').
        CloseReasonEnum:UserClosing = new CloseReasonEnum('UserClosing').
        CloseReasonEnum:TaskManagerClosing = new CloseReasonEnum('TaskManagerClosing').
        CloseReasonEnum:FormOwnerClosing = new CloseReasonEnum('FormOwnerClosing').
        CloseReasonEnum:ApplicationExitCall = new CloseReasonEnum('ApplicationExitCall').
    end constructor.

    constructor public CloseReasonEnum ( input pcName as character ):
        super (input pcName).
    end constructor.


end class.