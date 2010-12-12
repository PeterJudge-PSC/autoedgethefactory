/*------------------------------------------------------------------------
    File        : test_buildvehicle.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Dec 03 09:55:00 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.InjectABL.FactoryModule.
using OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule.
using OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.  
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.  
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.Class.
using OpenEdge.Core.System.ApplicationError.
using Progress.Lang.AppError.
using Progress.Lang.Error.

/** -- defs  -- **/  
define variable cOrderId as character no-undo.
define variable iProcessInstanceId as int64 no-undo.
define variable cContextId as longchar no-undo.
define variable oInjectABLKernel as IKernel no-undo.
define variable oModules as IInjectionModuleCollection no-undo.
define variable oServiceManager as IServiceManager no-undo.

/** -- main -- **/
oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oModules:Add(new FactoryModule()).
oInjectABLKernel = new ComponentKernel(oModules).

oServiceManager = cast(oInjectABLKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager'), IServiceManager).
oServiceManager:Initialize().

ABLSession:Instance:SessionProperties:Put(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'), oServiceManager).

cOrderId = '0008-00001'.
iProcessInstanceId = -1.
cContextId  = guid(generate-uuid).
run AutoEdge/Factory/Build/service_buildvehicle.p (cOrderId, iProcessInstanceId, cContextId).

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
        oError:GetMessage(1)      skip
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error' + ' (' + string(oError:GetMessageNum(1)) + ')'.
end catch.