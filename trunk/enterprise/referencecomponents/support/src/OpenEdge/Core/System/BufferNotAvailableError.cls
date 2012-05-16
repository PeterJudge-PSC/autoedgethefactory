/*------------------------------------------------------------------------
    File        : BufferNotAvailableError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:27:18 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.BufferNotAvailableError.
using Progress.Lang.Error.

class OpenEdge.Core.System.BufferNotAvailableError inherits ApplicationError: 
    
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public BufferNotAvailableError(poErr as Error):
        super(poErr).
        ErrorText = 'Buffer Not Available Error'.
        ErrorTitle = 'Buffer &1 not available'.        
    end constructor.
    
    constructor public BufferNotAvailableError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
    constructor public BufferNotAvailableError(poErr as Error,pcArgs1 as character):
        this-object(poErr).   
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public BufferNotAvailableError(pcArgs1 as character):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1).
    end constructor.
    
    
end class.