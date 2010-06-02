/*------------------------------------------------------------------------
    File        : INavigationPanelPresenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 15 11:18:04 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

interface OpenEdge.PresentationLayer.Presenter.INavigationPanelPresenter:  
    
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as char no-undo get. set.
  
end interface.