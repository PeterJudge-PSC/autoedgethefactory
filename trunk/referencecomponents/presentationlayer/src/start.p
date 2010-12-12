/*------------------------------------------------------------------------
    File        : start.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Feb 17 10:14:49 EST 2009
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
  
define variable oInjectABLKernel as IKernel no-undo.
define variable oModules as IInjectionModuleCollection no-undo.
define variable oServiceManager as IServiceManager no-undo.
define variable cModulePaths as character extent no-undo.

oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oInjectABLKernel = new ComponentKernel(oModules).

cModulePaths[1] = 'OpenEdge/CommonInfrastructure/InjectABL'.
cModulePaths[1] = 'OpenEdge/PresentationLayer/InjectABL'.

oInjectABLKernel:Load(cModulePaths).

oServiceManager = cast(oInjectABLKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager'), IServiceManager).
/* Run, app, run. See app run! */ 
oServiceManager:Initialize().

ABLSession:Instance:SessionProperties:Put(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'), oServiceManager).

catch oException as ApplicationError:
    oException:ShowError().
    
    oServiceManager = ?.
end catch.

catch oError as Progress.Lang.Error:
    message
        oError:GetMessage(1)      skip
        '(' oError:GetMessageNum(1) ')' skip(2)        
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