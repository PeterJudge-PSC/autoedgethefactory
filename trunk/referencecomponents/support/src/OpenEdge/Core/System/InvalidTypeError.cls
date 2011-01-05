/*------------------------------------------------------------------------
    File        : InvalidTypeError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:10:06 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidTypeError.
using Progress.Lang.Error.

class OpenEdge.Core.System.InvalidTypeError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public InvalidTypeError(pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        define variable oUnknown as Error no-undo.
        this-object(?,pcArgs1,pcArgs2,pcArgs3).
    end constructor.
    
    constructor public InvalidTypeError(poErr as Error, pcArgs1 as char, pcArgs2 as char, pcArgs3 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
        AddMessage(pcArgs3, 3).
    end constructor.
    
    constructor public InvalidTypeError(poErr as Error):
        super(poErr).

        ErrorText = 'The &1 &2 does not implement &3'.
        ErrorTitle = 'Invalid Type Error'.
    end constructor.
    
    constructor public InvalidTypeError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class.