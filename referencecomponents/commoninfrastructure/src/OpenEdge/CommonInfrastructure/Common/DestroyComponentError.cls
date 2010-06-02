/*------------------------------------------------------------------------
    File        : DestroyComponentError
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 08 10:01:28 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.DestroyComponentError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.Common.DestroyComponentError inherits ApplicationError: 

    define override protected property ErrorText as character no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public DestroyComponentError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).
    end constructor.
                
    constructor public DestroyComponentError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).
    end constructor.                
    
    constructor public DestroyComponentError(poErr as Error):
        super(poErr).
        this-object:ErrorTitle = 'Component Destruction Error'.
        this-object:ErrorText = 'Destruction of &1 failed: &2'. 
    end constructor.
    
    constructor public DestroyComponentError():
       define variable oUnknown as Error no-undo.
       this-object(oUnknown).  
    end constructor.
end class.