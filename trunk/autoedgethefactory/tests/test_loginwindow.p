/*------------------------------------------------------------------------
    File        : test_loginwindow.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Mon Apr 12 14:53:12 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.Test.TestPresenterModule.

using OpenEdge.PresentationLayer.Presenter.IPresenter.
using OpenEdge.CommonInfrastructure.Common.IServiceManager. 
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponent.
 
using OpenEdge.CommonInfrastructure.PInject.CommonInfrastructureModule.
using OpenEdge.CommonInfrastructure.PInject.ComponentKernel.
using OpenEdge.Core.PInject.IKernel.
using OpenEdge.Core.PInject.StandardKernel.
using OpenEdge.Core.PInject.Binding.Modules.IInjectionModuleCollection.  
using OpenEdge.Core.PInject.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.PInject.Binding.Parameters.MethodArgument. 
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.Class.
  
define variable oPInjectKernel as IKernel no-undo.
define variable oModules as IInjectionModuleCollection no-undo.
define variable oServiceManager as IServiceManager no-undo.
define variable oParams as IParameterCollection no-undo.
define variable oLoginWindow as IPresenter no-undo. 

session:suppress-warnings = true.

oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oModules:Add(new TestPresenterModule()).
oPInjectKernel = new ComponentKernel(oModules).

oServiceManager = cast(oPInjectKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager')
                    , IServiceManager).

oLoginWindow = cast(oServiceManager:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IApplicationLogin'))
                , IPresenter).
cast(oLoginWindow, IComponent):Initialize().

/* begins event loop */
oLoginWindow:ShowModal().

message  skip(2)
'done with modal wait-for'
view-as alert-box error title '[PJ DEBUG]'.

oServiceManager:StopService(cast(oLoginWindow, IService)).
oLoginWindow = ?.

catch oException as ApplicationError:
    oException:ShowError().
end catch.

catch oAppError as Progress.Lang.AppError:
    message
        oAppError:GetMessage(1)      skip
        '(' oAppError:ReturnValue ')' skip
        '(' oAppError:GetMessageNum(1) ')' skip(2)
        oAppError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.AppError'.
end catch.

catch oError as Progress.Lang.Error:
    message
        oError:GetMessage(1)      skip
        '(' oError:GetMessageNum(1) ')' skip(2)
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error'.
end catch.

finally:
    /* Release() deactivates the service manager, which will run DestroyComponent 
       and clean up nicely. */
    if valid-object(oPInjectKernel) then
        oPInjectKernel:Release(oServiceManager).
    
    oServiceManager = ?.
    oPInjectKernel = ?.
end finally.

/* ~E~O~F~ */



/* ***************************  OEF *************************** */
