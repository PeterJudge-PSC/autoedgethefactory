/*------------------------------------------------------------------------
    File        : INavigationPanelView
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 18 15:01:17 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.View.*.
using OpenEdge.Lang.*.

interface OpenEdge.PresentationLayer.View.INavigationPanelView:
    
    method public void NavigationStateChange (poActions as EnumMember extent,
                                              poStates as EnumMember extent).
    
end interface.