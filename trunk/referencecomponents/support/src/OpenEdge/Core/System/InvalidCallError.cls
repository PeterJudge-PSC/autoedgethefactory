/*------------------------------------------------------------------------
    File        : InvalidCallError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:38:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.ApplicationError.

class OpenEdge.Core.System.InvalidCallError inherits ApplicationError:
        
    define override protected property ErrorTitle as character no-undo get. set.
    define override protected property ErrorText as longchar no-undo get. set.
    
    constructor public InvalidCallError():
        super().
        
        ErrorTitle = 'Invalid Call Error'.
        ErrorText = 'Invalid &1 call: &2'.
    end constructor.
    
    constructor public InvalidCallError(pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class.