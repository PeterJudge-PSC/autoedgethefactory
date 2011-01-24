/*------------------------------------------------------------------------
    File        : NotFoundError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Feb 22 12:56:33 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.NotFoundError.
using Progress.Lang.Error.

class OpenEdge.Core.System.NotFoundError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public NotFoundError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public NotFoundError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        
        this-object(oUnknown,pcArgs1, pcArgs2).
    end constructor.
        
    constructor public NotFoundError(poErr as Error):
        super (poErr).
        
        this-object:ErrorTitle = 'Not Found Error'.
        this-object:ErrorText = '&1 not found in &2'.
    end constructor.
    
end class.