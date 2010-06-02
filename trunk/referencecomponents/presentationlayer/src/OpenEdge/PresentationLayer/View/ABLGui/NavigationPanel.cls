/*------------------------------------------------------------------------
    File        : NavigationPanel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 20 14:38:47 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.View.INavigationPanelView.
using OpenEdge.PresentationLayer.View.ABLGui.ContainedObject.
using OpenEdge.Lang.EnumMember.

class OpenEdge.PresentationLayer.View.ABLGui.NavigationPanel 
        inherits ContainedObject
        implements INavigationPanelView: 
    
    define public property ModelName as char no-undo get. set. 
    define public property QueryName as char no-undo get. set.
    
    constructor public NavigationPanel():
        super().
        
        PresenterName = 'OpenEdge.PresentationLayer.Presenter.NavigationPanelPresenter'.
                               
        /* Connect this class to the running .W */
        WindowHandle = GetRunningObject('OpenEdge/PresentationLayer/View/ABLGui/navpanel.w').

        /* Associate this wrapper with the .W its managing */
        dynamic-function('SetView' in WindowHandle, this-object).
    end constructor.
        
    method public void NavigationStateChange (piActions as integer extent, piStates as integer extent):
        run SetActionState in WindowHandle (piActions, piStates).
    end method.
            
    
    method override public void DataFetched (pcModel as char, plNewData as logical):
        run DataFetched in WindowHandle (pcModel, plNewData).
    end method.   

    method public void NavigationStateChange(piActions as EnumMember extent, piStates as EnumMember extent):

    end method.

    method override public void SetBindings(  ):
        
    end method.

    method override public void DataRefreshed(pcModel as character, pcQuery as character, poModelAction as EnumMember):

    end method.

    method override public void SaveData( pcModel as character, pcTable as character):

    end method.

end class.