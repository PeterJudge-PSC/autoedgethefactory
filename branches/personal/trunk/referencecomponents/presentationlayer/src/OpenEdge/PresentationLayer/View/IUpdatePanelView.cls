/** ------------------------------------------------------------------------
    File        : IUpdatePanelView
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon May 18 15:07:59 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Common.ActionStateEnum.
using OpenEdge.CommonInfrastructure.Common.UpdateActionEnum.

interface OpenEdge.PresentationLayer.View.IUpdatePanelView:
      
    method public void UpdateStateChange (input poActions as UpdateActionEnum extent,
                                          input poStates as ActionStateEnum extent).
    
    method public void TableNameChange (input pcTableName as char).
    
end interface.