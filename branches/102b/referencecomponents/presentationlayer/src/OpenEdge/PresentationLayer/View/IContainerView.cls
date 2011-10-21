/** ------------------------------------------------------------------------
    File        : IContainerView
    Purpose     : Interface for views that are containers and can be shown (viewed).
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Feb 06 14:12:26 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.PresentationLayer.View.IView.
using OpenEdge.PresentationLayer.View.EventLoopModeEnum.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.View.IContainerView /*inherits IView */ :

    method public void ShowModal().

    method public void BeginEventLoop(poShowMode as EventLoopModeEnum).
    method public void EndEventLoop().
    
end interface.