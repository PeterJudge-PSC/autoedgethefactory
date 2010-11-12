/*------------------------------------------------------------------------
    File        : IUpdatePanel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 02 15:32:47 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using Progress.Lang.Class.

interface OpenEdge.PresentationLayer.Presenter.IUpdatePanel:
        
    method public void SetUpdatePanelContext(poModelService as IComponentInfo, pcQuery as char, pcTable as char).
    
end interface.