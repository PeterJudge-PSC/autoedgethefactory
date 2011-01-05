/*------------------------------------------------------------------------
    File        : AccessViolationError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 07 17:00:40 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.AccessViolationError.
using Progress.Lang.Error.

class OpenEdge.Core.System.AccessViolationError inherits ApplicationError: 
    define static public property READ_ONLY as character no-undo init 'read-only' get.
    
    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
            
    constructor public AccessViolationError(poErr as Error,pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public AccessViolationError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.     
        this-object(oUnknown,pcArgs1,pcArgs2).     
    end constructor.
    
    constructor public AccessViolationError(poErr as Error):
        super(poErr).
        this-object:ErrorTitle = 'Access Denied'.
        this-object:ErrorText = 'The &1 is marked as &2'.        
    end constructor.
    
    constructor public AccessViolationError():
        define variable oUnknown as Error no-undo.     
        this-object(oUnknown).        
    end constructor.
end class.