/*------------------------------------------------------------------------
    File        : CharacterStack
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 05 13:50:43 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.CharacterStack.
using OpenEdge.Lang.Collections.Stack.

class OpenEdge.Lang.Collections.CharacterStack inherits Stack:
    
    constructor public CharacterStack(pcArray as character extent):
        super(pcArray).
    end constructor.
    
    constructor public CharacterStack(piDepth as integer):
        super(piDepth).
    end constructor.
        
    constructor public CharacterStack():
        super().
    end constructor.
    
    method public void Push(pcValue as character):
        PrimitivePush(pcValue).
    end method.
    
    method public character Peek():
        return PrimitivePeek().
    end method.
    
    method public character Pop():
        return PrimitivePop().
    end method.
    
    method public character extent ToArray():
        return PrimitiveToArray().
    end method.
    
end class.