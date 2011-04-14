/*------------------------------------------------------------------------
    File        : start_ui.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Dec 16 10:42:00 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Client.Common.PresentationLayer.ITaskListManager.
using OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using Progress.Lang.Error.
using Progress.Lang.AppError.
using Progress.Windows.Form.
using Progress.Lang.Object.
using Progress.Lang.Class.

/** -- defs  -- **/
define variable oTasks as Object no-undo.
define variable oServiceManager as IServiceManager no-undo.

/** -- main -- **/
run OpenEdge/CommonInfrastructure/Common/start_session.p('').

oServiceManager = cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:IServiceManagerType), IServiceManager).
oTasks = oServiceManager:Kernel:Get('AutoEdge.Factory.Client.Common.PresentationLayer.ITaskListManager').

wait-for System.Windows.Forms.Application:Run(cast(oTasks, Form)). 

/** ----------------- **/
catch oException as ApplicationError:
    oException:LogError().
    oException:ShowError().
end catch.

catch oAppError as AppError:
    message
        oAppError:ReturnValue skip(2)
        oAppError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.AppError'.
end catch.

catch oError as Error:
    message
        oError:GetMessage(1) skip(2)
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error' + ' (' + string(oError:GetMessageNum(1)) + ')'.
end catch.

finally:
    run OpenEdge/CommonInfrastructure/Common/stop_session.p.
end finally.
