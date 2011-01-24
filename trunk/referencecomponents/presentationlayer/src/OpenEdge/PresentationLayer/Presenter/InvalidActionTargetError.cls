/*------------------------------------------------------------------------
    File        : InvalidActionTargetError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:05:05 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.PresentationLayer.Presenter.InvalidActionTargetError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.PresentationLayer.Presenter.InvalidActionTargetError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public InvalidActionTargetError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).        
    end constructor.
    
    constructor public InvalidActionTargetError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).          
    end constructor.
    
    constructor public InvalidActionTargetError(poErr as Error):
        super (poErr).
        this-object:ErrorTitle = 'Presenter Error'.
        this-object:ErrorText = 'Action Target &1 does not implement &2'. 
    end constructor.

    constructor public InvalidActionTargetError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).  
    end constructor.
    
end class.