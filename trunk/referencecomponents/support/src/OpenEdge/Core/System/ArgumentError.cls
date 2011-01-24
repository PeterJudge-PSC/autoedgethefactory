/*------------------------------------------------------------------------
    File        : ArgumentError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 13 12:43:45 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ArgumentError inherits ApplicationError: 

    define override protected property ErrorTitle as character no-undo get. private set. 
    define override protected property ErrorText as longchar no-undo get. private set.

    constructor public ArgumentError(poInnerError as Error):
        super(poInnerError).
        
        ErrorTitle = 'Argument Error'.
        ErrorText = '&1 (name &2)'.
    end constructor.
    
    constructor public ArgumentError(pcArgs1 as char, pcArgs2 as char):
        this-object(?, pcArgs1, pcArgs2).
    end constructor.
    
    constructor public ArgumentError(poInnerError as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poInnerError).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.

end class.