/*------------------------------------------------------------------------
    File        : test_servicemanager.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Thu Mar 18 10:46:31 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IServiceManager.  
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

oModules = new IInjectionModuleCollection().
oModules:Add(new CommonInfrastructureModule()).
oPInjectKernel = new ComponentKernel(oModules).

oServiceManager = cast(oPInjectKernel:Get('OpenEdge.CommonInfrastructure.Common.IServiceManager')
                    , IServiceManager).
                    
/*
message
    oServiceManager:GetClass():TypeName skip
view-as alert-box.

params = new IParameterCollection().
params:Add(
    new MethodArgument('AddComponent',
            Class:GetClass('OpenEdge.Test.Shuriken'))).
           
params:Add(new PropertyValue('UseAlternate', 'true', DataTypeEnum:Logical)).

kernel:Inject(warrior, params).
*/


catch oException as ApplicationError:
    oException:ShowError().
    
    oServiceManager = ?.
end catch.

catch oAppError as Progress.Lang.AppError:
    message
        oAppError:GetMessage(1)      skip
        '(' oAppError:ReturnValue ')' skip
        '(' oAppError:GetMessageNum(1) ')' skip(2)
        oAppError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error'.
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
    
    oPInjectKernel = ?.
end finally.

/* ~E~O~F~ */



/* ***************************  OEF *************************** */
