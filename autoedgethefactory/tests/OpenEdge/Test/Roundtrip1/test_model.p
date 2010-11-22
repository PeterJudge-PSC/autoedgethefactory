/*------------------------------------------------------------------------
    File        : test_model.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Nov 18 10:00:22 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule.
using OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.  
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.  
using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.

/** -- defs  -- **/  
define variable oInjectABLKernel as IKernel no-undo.
define variable oModules as IInjectionModuleCollection no-undo.
define variable oServiceManager as IServiceManager no-undo.
def var oBE as IServiceProvider no-undo.

/** -- main -- **/
oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oModules:Add(new OpenEdge.Test.Roundtrip1.BusinessComponents.InjectABLModule()).
oInjectABLKernel = new ComponentKernel(oModules).

ABLSession:Instance:SessionProperties:Put(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'), oInjectABLKernel).

oServiceManager = cast(oInjectABLKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager'), IServiceManager).
message
    'started servicemanager of type ' oServiceManager:GetClass():TypeName skip
view-as alert-box.

/* Run, app, run. See app run! 
oServiceManager:Initialize().
*/

def var omodel as OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.

omodel = oServiceManager:GetServiceProvider('EmployeeService').

message skip(2)

'omodel=' omodel
view-as alert-box error title '[PJ DEBUG]'.


catch oException as ApplicationError:
    oException:ShowError().
    
    oServiceManager = ?.
end catch.

catch oAppError as Progress.Lang.AppError:
    message
        oAppError:GetMessage(1)      skip
        oAppError:ReturnValue skip(2)
        oAppError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.AppError'.
end catch.

catch oError as Progress.Lang.Error:
    message
        oError:GetMessage(1)      skip
        '(' oError:GetMessageNum(1) ')'  skip(2)        
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error'.
end catch.

finally:
    if valid-object(oInjectABLKernel) then
        oInjectABLKernel:Release(oServiceManager).
    
    oInjectABLKernel:Clear(ABLSession:Instance).
    oInjectABLKernel = ?.
end finally.

/* ~E~O~F~ */


/** --  -- **/
/** --  -- **/
/** --  -- **/
/** --  -- **/