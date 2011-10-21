/** ------------------------------------------------------------------------
    File        : INavigationPanelView
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon May 18 15:01:17 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Common.ActionStateEnum.
using OpenEdge.PresentationLayer.Common.NavigationActionEnum.

interface OpenEdge.PresentationLayer.View.INavigationPanelView:
    
    method public void NavigationStateChange (poActions as NavigationActionEnum extent,
                                              poStates as ActionStateEnum extent).
    
end interface.