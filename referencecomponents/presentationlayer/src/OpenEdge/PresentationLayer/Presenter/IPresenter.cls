/** ------------------------------------------------------------------------
    File        : IPresenter
    Purpose     : Common Presenter interface (data bound or not) 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Nov 06 16:19:51 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.View.EventLoopModeEnum.
using OpenEdge.PresentationLayer.Presenter.IPresenter.
using OpenEdge.PresentationLayer.View.IView.
using OpenEdge.PresentationLayer.View.IContainedView.

using OpenEdge.PresentationLayer.Common.DialogResultEnum.
using OpenEdge.PresentationLayer.Common.CloseReasonEnum.

using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.CommonInfrastructure.IServiceCollection.
using OpenEdge.CommonInfrastructure.Component.
using OpenEdge.CommonInfrastructure.IService.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.Presenter.IPresenter /* inherits IService */ :
    define public property ParentPresenter as IPresenter no-undo get.
    
    /** Only a presenter can operate on a View; however, we can set the View 
        instance from 'the outside'. */
    define public property View as IView no-undo set.
    method public void SetView(poView as IView).
    
    /** Returns whether the Presenter has a View instance. */
    define public property HasView as logical no-undo get.
    
    method public void AddChildPresenter(poPresenter as IPresenter).
    method public void AddChildPresenter(poPresenter as IPresenter extent).
    
    /** Used by Views to register themselves with their Presenter.
       AssociateContainedView is basically a pass-through for the SetView call. */
    method public IPresenter AssociateContainedView (poView as IContainedView).
    
    /** Returns a reference to a child presenter, if any. The input param can 
        either be the type name of a presenter, or an interface the presenter
        implements.     */
    method public IPresenter GetChildPresenter(poPresenterService as class Class).
    method public IPresenter GetChildPresenter(poPresenterComponentInfo as IComponentInfo).
    
    method public void DestroyChildPresenter(poPresenter as IPresenter).
    
    method public void HideView().
    method public void ShowView().
    method public void ShowModal().    
    method public void ShowEmbedded(poParentView as Object).
    
    method public void BeginEventLoop(poShowMode as EventLoopModeEnum).
    method public void EndEventLoop().
    
    /** CanCloseView() call that's made from a View's event handlers/triggers. This method
        can be implemented/overridden to decide whether the closing should take place.
        
        @param piDialogResult OpenEdge.PresentationLayer.View.DialogResultEnum
        @param piCloseReason OpenEdge.PresentationLayer.System.CloseReasonEnum
        
        @return Whether the view can continue closing      */
    @method(virtual="true").
    method public logical CanCloseView(poDialogResult as DialogResultEnum, poCloseReason as CloseReasonEnum).
    
end interface.