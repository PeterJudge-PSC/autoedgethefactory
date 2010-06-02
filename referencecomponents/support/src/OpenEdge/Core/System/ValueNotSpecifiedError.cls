/*------------------------------------------------------------------------
    File        : ValueNotSpecifiedError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 07 16:46:43 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ValueNotSpecifiedError.
using Progress.Lang.Error.

class OpenEdge.Core.System.ValueNotSpecifiedError inherits ApplicationError: 

    define override protected property ErrorText as character no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public ValueNotSpecifiedError ():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public ValueNotSpecifiedError (poErr as Error):
        super(poErr).
        ErrorText = 'No &1 specified for &2'.
        ErrorTitle = 'Value Not Specified Error'.        
    end constructor.
    
    constructor public ValueNotSpecifiedError (pcArgs1 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1).
    end constructor.
    
    constructor public ValueNotSpecifiedError (poErr as Error,pcArgs1 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public ValueNotSpecifiedError (pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs2,pcArgs2).
    end constructor.    
    
    constructor public ValueNotSpecifiedError (poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
end class.