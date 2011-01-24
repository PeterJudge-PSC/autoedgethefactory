/** ------------------------------------------------------------------------
    File        : EventLoopModeEnum
    Purpose     : Enumeration of event loop modes (modal etc) 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 14 16:55:02 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.View.EventLoopModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.View.EventLoopModeEnum final inherits EnumMember:
    /** Form/view/page not currently shown  */
    define public static property None     as EventLoopModeEnum no-undo get. private set.     
    /** Show a form/view/page as modal  */
    define public static property Modal        as EventLoopModeEnum no-undo get. private set.
    /** Show a form/view/page as non-modal, with event blocking for a particular form/view/page  */
    define public static property NonModalView as EventLoopModeEnum no-undo get. private set.
    /** Show a form/view/page as non-modal, with event blocking for no particular form/view/page  */
    define public static property NonModalNone as EventLoopModeEnum no-undo get. private set.
    /** Show a form/view/page as embedded in another */
    define public static property Embedded     as EventLoopModeEnum no-undo get. private set.
    
    constructor static EventLoopModeEnum():
        EventLoopModeEnum:None = new EventLoopModeEnum('None').
        EventLoopModeEnum:Modal = new EventLoopModeEnum('Modal').
        EventLoopModeEnum:NonModalView = new EventLoopModeEnum('NonModalView').
        EventLoopModeEnum:NonModalNone = new EventLoopModeEnum('NonModalNone').
        EventLoopModeEnum:Embedded = new EventLoopModeEnum('Embedded').
    end constructor.

    constructor public EventLoopModeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.