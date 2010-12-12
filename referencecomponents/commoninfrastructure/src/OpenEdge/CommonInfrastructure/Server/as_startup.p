/*------------------------------------------------------------------------
    File        : as_startup.p
    Purpose     : AppServer startup procedure 
    
    Syntax      :

    Description : 

    @author pjudge
    Created     : Fri Jun 04 13:54:27 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel.
using OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.

define variable oInjectABLKernel as IKernel no-undo.
define variable oModules as IInjectionModuleCollection no-undo.
define variable oServiceManager as IServiceManager no-undo.
define variable oSession as ABLSession no-undo. 

/* start the session object */
oSession = ABLSession:Instance.

oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oInjectABLKernel = new ComponentKernel(oModules).

oServiceManager = cast(oInjectABLKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager'), IServiceManager).
oSession:SessionProperties:Put(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'), oServiceManager).

catch oApplicationError as ApplicationError:
    oApplicationError:ShowError().
    
    oServiceManager = ?.
    
    undo, throw oApplicationError.
end catch.

catch oError as Progress.Lang.Error:
    message
        oError:GetMessage(1)      skip
        '(' oError:GetMessageNum(1) ')' skip(2)        
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error'.
    undo, throw oError.        
end catch.

/** eof **/