/** ------------------------------------------------------------------------
    File        : IUpdatePanelPresenter
    Purpose     : Standard interface for (data) update functionality. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri May 15 11:18:40 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
  
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.UpdateActionEnum.

interface OpenEdge.PresentationLayer.Presenter.IUpdatePanelPresenter:  
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as char no-undo get. set.
    define public property TableName as char no-undo get. set.
    define public property CommitAction as UpdateActionEnum no-undo get. set.
    define public property DeleteAction as UpdateActionEnum no-undo get. set.  
end interface.