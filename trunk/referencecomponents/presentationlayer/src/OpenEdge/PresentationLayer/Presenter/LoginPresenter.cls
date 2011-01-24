/** ------------------------------------------------------------------------
    File        : LoginPresenter
    Purpose     : Presenter to handle login functionality
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 10 16:50:29 EST 2007
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}
  
using OpenEdge.PresentationLayer.Presenter.Presenter.
using OpenEdge.PresentationLayer.Presenter.IPresenter.
using OpenEdge.PresentationLayer.Presenter.ILoginPresenter.
using OpenEdge.PresentationLayer.Common.LoginError.

using OpenEdge.CommonInfrastructure.IApplicationLogin.
using OpenEdge.CommonInfrastructure.IServiceManager. 
using OpenEdge.CommonInfrastructure.IComponentInfo.

using OpenEdge.Core.System.ILoginData.
using OpenEdge.Core.System.ApplicationError.

class OpenEdge.PresentationLayer.Presenter.LoginPresenter
        inherits Presenter
        implements ILoginPresenter, IApplicationLogin:
    
    constructor public LoginPresenter(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    /* ILoginPresenter methods below */
    method public void ValidateLogin(poLoginData as ILoginData).
        /* authenticate & authorise
         
        define private variable moAuthenticationService as ISecurityManager no-undo.
        moAuthenticationService = cast(ServiceManager:StartService(CommonSecurityManager:SecurityManagerType)
                    , ISecurityManager).
        */
        
        /* If we get here, then login has succeeded and we can close the login window down. */
        CloseView().
        
        catch oAuthError as ApplicationError:
            oAuthError:ShowError().
            undo, throw new LoginError(oAuthError, 'failed').
        end catch.
    end method.

end class.