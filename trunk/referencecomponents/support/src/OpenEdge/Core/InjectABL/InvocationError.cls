/*------------------------------------------------------------------------
    File        : InvocationError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 12 15:06:24 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.Core.InjectABL.InvocationError inherits ApplicationError: 

    define override protected property ErrorText as character no-undo get. set. 
    define override protected property ErrorTitle as character no-undo get. set. 

    constructor public InvocationError(poInnerError as Error):
        super (poInnerError).        
                
        this-object:ErrorTitle = 'Invocation Error'.
        this-object:ErrorText = 'Cannot invoke &1 on class &2'.
    end constructor.
    
    constructor public InvocationError(poErr as Error,
                                       pcArgs1 as char,
                                       pcArgs2 as char):
        this-object(poErr).
        
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public InvocationError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).
    end constructor.
    
end class.