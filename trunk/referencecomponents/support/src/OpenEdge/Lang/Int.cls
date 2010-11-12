@todo(task="implement", action="complete this shadow object").
/*------------------------------------------------------------------------
    File        : Int
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 08:22:29 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Int.
using OpenEdge.Lang.ABLPrimitive.

class OpenEdge.Lang.Int:
    define public property Value as int64 no-undo get. private set.
    
    constructor public Int(piValue as int64):
        super().
        this-object:Value = piValue.
    end constructor.

    constructor public Int(piValue as int):
        super().
        this-object:Value = piValue.
    end constructor.
    
end class.