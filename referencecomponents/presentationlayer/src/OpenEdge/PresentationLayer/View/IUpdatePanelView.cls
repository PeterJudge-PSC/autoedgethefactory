/*------------------------------------------------------------------------
    File        : IUpdatePanelView
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon May 18 15:07:59 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Lang.*.
using Progress.Lang.*.

interface OpenEdge.PresentationLayer.View.IUpdatePanelView:  
    
    method public void UpdateStateChange (piActions as EnumMember extent,
                                          piStates as EnumMember extent).
    method public void TableNameChange (pcTableName as char).
      
end interface.