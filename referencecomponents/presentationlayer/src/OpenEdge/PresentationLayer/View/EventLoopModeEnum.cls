 /*------------------------------------------------------------------------
    File        : EventLoopModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Apr 14 16:55:02 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.View.EventLoopModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.View.EventLoopModeEnum final:
    /** Form/view/page not currently shown  */
    define public static property None     as EnumMember no-undo get. private set.     
    /** Show a form/view/page as modal  */
    define public static property Modal        as EnumMember no-undo get. private set.
    /** Show a form/view/page as non-modal, with event blocking for a particular form/view/page  */
    define public static property NonModalView as EnumMember no-undo get. private set.
    /** Show a form/view/page as non-modal, with event blocking for no particular form/view/page  */
    define public static property NonModalNone as EnumMember no-undo get. private set.
    /** Show a form/view/page as embedded in another */
    define public static property Embedded     as EnumMember no-undo get. private set.
    
    constructor static EventLoopModeEnum():
        EventLoopModeEnum:None = new EnumMember('None').
        EventLoopModeEnum:Modal = new EnumMember('Modal').
        EventLoopModeEnum:NonModalView = new EnumMember('NonModalView').
        EventLoopModeEnum:NonModalNone = new EnumMember('NonModalNone').
        EventLoopModeEnum:Embedded = new EnumMember('Embedded').
    end method.
    
end class.