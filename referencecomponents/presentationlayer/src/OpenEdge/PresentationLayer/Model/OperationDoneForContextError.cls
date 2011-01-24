/*------------------------------------------------------------------------
    File        : OperationDoneForContextError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jul 07 17:02:23 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.PresentationLayer.Model.OperationDoneForContextError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ErrorSeverityEnum.
using Progress.Lang.Error.

class OpenEdge.PresentationLayer.Model.OperationDoneForContextError inherits ApplicationError: 

    define override protected property ErrorText as longchar no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
    
    constructor public OperationDoneForContextError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).    
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
    
    constructor public OperationDoneForContextError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).
    end constructor.
        
    constructor public OperationDoneForContextError(poErr as Error):
        super(poErr).            
        this-object:Severity = (ErrorSeverityEnum:Debug:Value + ErrorSeverityEnum:Warning:Value).
        this-object:ErrorTitle = 'Model Error'.
        this-object:ErrorText = 'Operation &1 has already been called for the current context on &2'.
    end constructor.

    constructor public OperationDoneForContextError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).            
    end constructor.
    
end class.