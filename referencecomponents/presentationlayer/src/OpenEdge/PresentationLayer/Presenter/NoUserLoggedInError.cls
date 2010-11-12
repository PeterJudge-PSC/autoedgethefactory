/*------------------------------------------------------------------------
    File        : NoUserLoggedInError
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jul 08 11:04:30 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.NoUserLoggedInError.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Error.

class OpenEdge.PresentationLayer.Presenter.NoUserLoggedInError inherits ApplicationError: 
    
    define override protected property ErrorText as character no-undo get. set.
    define override protected property ErrorTitle as character no-undo get. set.

    constructor public NoUserLoggedInError (poErr as Error):
        super (poErr).
        
        this-object:ErrorTitle = 'No User Logged In Error'.
        this-object:ErrorText = 'No user currently logged in'.      
    end constructor.
            
    constructor public NoUserLoggedInError (  ):
        define variable oUnknown as Error no-undo.
        this-object(oUnknown).  
    end constructor.
    
end class.