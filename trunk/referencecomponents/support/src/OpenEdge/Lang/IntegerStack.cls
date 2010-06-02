/*------------------------------------------------------------------------
    File        : IntegerStack
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.IntegerStack inherits Stack:
        
    constructor public IntegerStack(piDepth as integer):
        super (piDepth).
    end constructor.
    
    constructor public IntegerStack():
    end constructor.
    
    method public void Push(piValue as integer):
        PrimitivePush(string(piValue)).
    end method.
    
    method public integer Peek():
        return integer(PrimitivePeek()).
    end method.
    
    method public integer Pop():
        return integer(PrimitivePop()).
    end method.
    
end class.