/*------------------------------------------------------------------------
    File        : LoginPresenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 10 16:50:29 EST 2007
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using OpenEdge.PresentationLayer.Presenter.Presenter.
using OpenEdge.PresentationLayer.Presenter.IPresenter.
using OpenEdge.PresentationLayer.Presenter.ILoginPresenter.
using OpenEdge.PresentationLayer.Common.LoginError.
using OpenEdge.PresentationLayer.Common.DialogResultEnum.

using OpenEdge.CommonInfrastructure.Common.IApplicationLogin.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager. 
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.ILoginData.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.Error.

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
        moAuthenticationService = cast(ServiceManager:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
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