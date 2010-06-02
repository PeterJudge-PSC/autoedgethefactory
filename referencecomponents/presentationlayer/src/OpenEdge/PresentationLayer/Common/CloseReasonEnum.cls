/*------------------------------------------------------------------------
    File        : CloseReasonEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 21 15:08:33 EDT 2009
    Notes       : *Based on System.Windows.Forms.CloseReason
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Common.CloseReasonEnum final: 

    /* The cause of the closure was not defined or could not be determined.*/
    define public static property None                as EnumMember no-undo get. private set.
    /* The operating system is closing all applications before shutting down.*/
    define public static property WindowsShutDown     as EnumMember no-undo get. private set.
    /* The parent form of this multiple document interface (MDI) form is closing.*/
    define public static property MdiFormClosing      as EnumMember no-undo get. private set.
    /* The user is closing the form through the user interface (UI), for example 
       by clicking the Close button on the form window, selecting Close from the
       window's control menu, or pressing ALT+F4.*/
    define public static property UserClosing         as EnumMember no-undo get. private set.
    /* The Microsoft Windows Task Manager is closing the application. */
    define public static property TaskManagerClosing  as EnumMember no-undo get. private set.
    /* The owner form is closing.*/
    define public static property FormOwnerClosing    as EnumMember no-undo get. private set.
    /* The Exit method of the Application class was invoked.*/
    define public static property ApplicationExitCall as EnumMember no-undo get. private set.
    
    constructor static CloseReasonEnum():
        CloseReasonEnum:None = new EnumMember(1, 'None').
        CloseReasonEnum:WindowsShutDown = new EnumMember(2, 'WindowsShutDown').
        CloseReasonEnum:MdiFormClosing = new EnumMember(3, 'MdiFormClosing').
        CloseReasonEnum:UserClosing = new EnumMember(4, 'UserClosing').
        CloseReasonEnum:TaskManagerClosing = new EnumMember(5, 'TaskManagerClosing').
        CloseReasonEnum:FormOwnerClosing = new EnumMember(6, 'FormOwnerClosing').
        CloseReasonEnum:ApplicationExitCall = new EnumMember(7, 'ApplicationExitCall').
        
    end constructor.

end class.