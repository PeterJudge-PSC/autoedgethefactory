/*------------------------------------------------------------------------
    File        : ObjectStack
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.
using Progress.Lang.*.

class OpenEdge.Lang.ObjectStack inherits Stack:
        
    constructor public ObjectStack (poArray as Object extent):
        super(poArray).
    end constructor.
    
    constructor public ObjectStack (piDepth as integer):
        super(piDepth).
    end constructor.

    constructor public ObjectStack():
    end constructor.
    
    method public void Push(poValue as Object):
        super:ObjectPush(poValue).
    end method.
    
    method public Object Peek():
        return super:ObjectPeek().
    end method.
    
    method public Object Pop():
        return super:ObjectPop().
    end method.
    
    method public Object extent ToArray():
        return super:ObjectToArray().
    end method.
    
end class.