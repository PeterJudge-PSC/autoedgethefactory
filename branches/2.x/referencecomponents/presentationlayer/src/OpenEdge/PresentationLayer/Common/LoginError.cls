/*------------------------------------------------------------------------
    File        : LoginError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:58:56 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.LoginError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.PresentationLayer.Common.LoginError inherits ApplicationError: 
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.

    constructor public LoginError(poErr as Error, pcArgs1 as char):
        this-object(poErr).    
        AddMessage(pcArgs1, 1).
    end constructor.
    
    constructor public LoginError(pcArgs1 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown, pcArgs1).
    end constructor.
    
    constructor public LoginError(poErr as Error):
        super(poErr).
        
        this-object:ErrorTitle = 'Login Error'.
        this-object:ErrorText  = 'Login &1'.
    end constructor.
    
    constructor public LoginError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).  
    end constructor.


end class.