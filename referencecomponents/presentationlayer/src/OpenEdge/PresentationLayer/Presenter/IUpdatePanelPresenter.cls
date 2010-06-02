/*------------------------------------------------------------------------
    File        : IUpdatePanelPresenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 15 11:18:40 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
  
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.Lang.EnumMember.

interface OpenEdge.PresentationLayer.Presenter.IUpdatePanelPresenter:  
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as char no-undo get. set.
    define public property TableName as char no-undo get. set.
    define public property CommitAction as EnumMember no-undo get. set. /* OpenEdge.PresentationLayer.Presenter.CommitActionEnum */
    define public property DeleteAction as EnumMember no-undo get. set. /* OpenEdge.PresentationLayer.Presenter.DeleteActionEnum */  
end interface.