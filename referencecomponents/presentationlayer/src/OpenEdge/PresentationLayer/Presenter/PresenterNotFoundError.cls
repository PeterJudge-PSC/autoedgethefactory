@deprecated(version="0.0").
/*------------------------------------------------------------------------
    File        : PresenterNotFoundError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 10:03:41 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.PresenterNotFoundError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.PresentationLayer.Presenter.PresenterNotFoundError inherits ApplicationError: 

    define override protected property ErrorText as character no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.
        
    constructor public PresenterNotFoundError(poErr as Error, pcArgs1 as char, pcArgs2 as char):
        this-object(poErr).
        AddMessage(pcArgs1, 1).
        AddMessage(pcArgs2, 2).        
    end constructor.
    
    constructor public PresenterNotFoundError(pcArgs1 as char, pcArgs2 as char):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown,pcArgs1,pcArgs2).        
    end constructor.
    
    constructor public PresenterNotFoundError(poErr as Error):
        super(poErr).

        this-object:ErrorTitle = 'Presenter Error'.
        this-object:ErrorText = 'Child presenter &1 not found in Presenter &2'. 
    end constructor.
   
    constructor public PresenterNotFoundError():
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).  
    end constructor.
end class.