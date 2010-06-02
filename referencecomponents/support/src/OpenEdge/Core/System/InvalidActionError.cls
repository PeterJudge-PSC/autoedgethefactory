/*------------------------------------------------------------------------
    File        : InvalidActionError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 19 13:15:14 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.


class OpenEdge.Core.System.InvalidActionError inherits ApplicationError: 
    define override protected property ErrorText as character no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
            
    constructor public InvalidActionError(pcArgs1 as char):
        this-object(?, pcArgs1).
    end constructor.
    
    constructor public InvalidActionError (poErr as Error, pcArgs1 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public InvalidActionError (poErr as Error):
        super(poErr).

        ErrorText = 'Invalid action: &1'.
        ErrorTitle = 'Invalid Action Error'.
    end constructor.
    
    constructor public InvalidActionError ():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class.