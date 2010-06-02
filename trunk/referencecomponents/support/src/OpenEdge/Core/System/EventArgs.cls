/*------------------------------------------------------------------------
    File        : EventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 27 11:45:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.EventArgs.

class OpenEdge.Core.System.EventArgs:

    define static public property Empty as EventArgs 
        get():
            if not valid-object(EventArgs:Empty) then
                EventArgs:Empty = new EventArgs().
             
             return EventArgs:Empty.
        end.
        private set.
    
    constructor public EventArgs():
    end constructor.

end class.