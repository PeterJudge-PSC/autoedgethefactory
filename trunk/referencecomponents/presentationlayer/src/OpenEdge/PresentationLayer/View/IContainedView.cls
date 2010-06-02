/*------------------------------------------------------------------------
    File        : IContainedView
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 09 11:55:24 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.View.IContainedView /*inherits IView */ :
    /** Stores the Presenter service for a contained view, so that we can  
        associate this View with its Presenter
        
        We use a Set method, since we cannot reflect on properties yet 
        (as of 10.2B) and we want to be able to set this value via InjectABL */
    define public property PresenterService as class Class no-undo get.
    method public void SetPresenterService(poService as class Class).
    
    /* Show as MDI child */
    method public void ShowEmbedded(poParentView as Object).
    
end interface.