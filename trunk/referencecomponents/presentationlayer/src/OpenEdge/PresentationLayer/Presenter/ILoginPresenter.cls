/*------------------------------------------------------------------------
    File        : ILoginPresenter
    Purpose     : Window-specific events. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 17 15:17:01 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Presenter.ILoginPresenter.
using OpenEdge.Core.System.ILoginData.

interface OpenEdge.PresentationLayer.Presenter.ILoginPresenter /* inherits IPResenter */:
    
    method public void ValidateLogin(poLoginData as ILoginData).
    
end interface.