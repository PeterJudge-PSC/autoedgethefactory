/*------------------------------------------------------------------------
    File        : test_buildvehicle_steps.p
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
define variable iPiid as int64 no-undo.
define variable cOrderId as character no-undo.
define variable cWorkstepName as character no-undo.
define variable cContextId as longchar no-undo.
define variable cStatus as longchar no-undo.
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
/* emulate appserver agent */
run OpenEdge/CommonInfrastructure/Server/as_activate.p.

iPiid = 10101.
cOrderId = '0008-00001'.
cOrderId = '454f8c3ff70d56f4:-5510034f:12ccc37938f:-8000'.
cContextId  = guid(generate-uuid).
cWorkstepName =  'ProcessComponents'.
cWorkstepName =  'CompleteVehicleBuild'.

run AutoEdge/Factory/Build/service_buildvehicle_performworkstep.p (cWorkstepName, iPiid, cOrderId, cContextId, output cStatus).

message
    'workstep ' cWorkstepName ' status is ' string(cStatus)
view-as alert-box error title '[PJ DEBUG]'.

/* emulate appserver agent */
run OpenEdge/CommonInfrastructure/Server/as_deactivate.p.

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
    if valid-object(oInjectABLKernel) then
    do:
        oServiceManager = cast(oInjectABLKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager')
                            , IServiceManager).
        
        /* done with the service manager */
        oInjectABLKernel:Release(oServiceManager).
        
        /* done with this session */
        oInjectABLKernel:Clear(ABLSession:Instance).
    end.
    
    oInjectABLKernel = ?.
end finally.
