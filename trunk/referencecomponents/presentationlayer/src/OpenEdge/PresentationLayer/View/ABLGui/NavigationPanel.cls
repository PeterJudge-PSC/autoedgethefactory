/** ------------------------------------------------------------------------
    File        : NavigationPanel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Feb 20 14:38:47 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.View.INavigationPanelView.
using OpenEdge.PresentationLayer.View.ABLGui.ContainedObject.
using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.PresentationLayer.Common.NavigationActionEnum.
using OpenEdge.PresentationLayer.Common.ActionStateEnum.

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
        
    method public void NavigationStateChange (poActions as NavigationActionEnum extent,
                                              poStates as ActionStateEnum extent):
        run SetActionState in WindowHandle (poActions, poStates).
    end method.
            
    
    method override public void DataFetched (pcModel as char, plNewData as logical):
        run DataFetched in WindowHandle (pcModel, plNewData).
    end method.   

    method override public void SetBindings(  ):
        
    end method.


    method override public void DataRefreshed(pcModel as character, pcQuery as character, poModelAction as ModelActionEnum):

    end method.

    method override public void SaveData( pcModel as character, pcTable as character):

    end method.

end class.