/*------------------------------------------------------------------------
    File        : InvalidValueSpecifiedError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:06:54 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvalidValueSpecifiedError inherits ApplicationError: 

    define override protected property ErrorTitle as character no-undo get. set.
    define override protected property ErrorText as longchar no-undo get. set.
    
    constructor public InvalidValueSpecifiedError (e as Error):
        super(e).
        
        ErrorTitle = 'Invalid Value Specified Error'.
        ErrorText = 'Invalid &1 specified &2'.
    end constructor.
    
    constructor protected InvalidValueSpecifiedError ():
        define variable oNullError as Error no-undo.
        this-object(oNullError).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char, pcArgs2 as char):
        this-object().
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (e as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(e).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvalidValueSpecifiedError (pcArgs1 as char):
        this-object().
        AddMessage(pcArgs1, 1).
    end constructor.
    
end class.