/*------------------------------------------------------------------------
    File        : IContainerView
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 06 14:12:26 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.View.IView.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.View.IContainerView /*inherits IView */ :
    method public void ShowModal().
    
    method public void BeginEventLoop(poShowMode as EnumMember).
    method public void EndEventLoop().
    
end interface.