/*------------------------------------------------------------------------
    File        : IView
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Oct 31 14:04:42 EDT 2008
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Presenter.IPresenter.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.PresentationLayer.Common.ModelActionEnum.                                

using Progress.Lang.Class.

interface OpenEdge.PresentationLayer.View.IView     /* inherits IComponent */ :
    define public property Presenter as IPresenter no-undo get. set.
    
    method public void ShowView().
    method public void HideView().
    method public void CloseView().
    
    method public void DataRefreshed(poModelService as IComponentInfo,
                                     pcQuery as char,
                                     poModelAction as ModelActionEnum).
    
    method public void DataFetched(poModelService as IComponentInfo, plNewData as logical).
    
    method public void SaveData(poModelService as IComponentInfo, pcBuffer as char).
    
end interface.