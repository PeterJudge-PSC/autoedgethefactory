/** ------------------------------------------------------------------------
    File        : ServerBuildModule
    Purpose     : Server-side Build bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class AutoEdge.Factory.Server.InjectABL.BuildModule inherits BusinessComponentModule:
     
    constructor public BuildModule():
        super ().
    end constructor.

    /** BUSINESS WORKFLOWS **/
    method public void LoadWorkflows():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oArgs as IParameter extent no-undo.

        /* binding for webservices exposure */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named("BuildVehicle")
            :To("AutoEdge.Factory.Server.Build.BusinessComponents.StandardBuild")
            :WithConstructorArgument(oArgs)
            :Using(InjectABLServiceProviderType).
        
        /* internal binding (for sub-IWorkFlow exposure) */
        oBindingSyntax = Bind(IWorkStepType).
        oBindingSyntax
            :Named("BuildVehicle")
            :To("AutoEdge.Factory.Server.Build.BusinessComponents.StandardBuild")
            :WithConstructorArgument(oArgs)
            :Using(InjectABLServiceProviderType). 
        
        /** BUSINESS WORKSTEPS **/
        /*BindWorkStep(workstepname, concrete type, is bizlogic step)*/
        BindWorkStep("BuildVehicle::ProcessComponents", "AutoEdge.Factory.Server.Build.BusinessComponents.ProcessComponents", false).
        BindWorkStep("BuildVehicle::AssembleChassis", "AutoEdge.Factory.Server.Build.BusinessComponents.AssembleChassis", false).
        BindWorkStep("BuildVehicle::AssembleBody", "AutoEdge.Factory.Server.Build.BusinessComponents.AssembleBody", false).
        BindWorkStep("BuildVehicle::PaintVehicle", "AutoEdge.Factory.Server.Build.BusinessComponents.PaintVehicle", false).
        BindWorkStep("BuildVehicle::AssembleInterior", "AutoEdge.Factory.Server.Build.BusinessComponents.AssembleInterior", false).
        BindWorkStep("BuildVehicle::MateAssembledComponents", "AutoEdge.Factory.Server.Build.BusinessComponents.MateAssembledComponents", false).
        BindWorkStep("BuildVehicle::CompleteVehicleBuild", "AutoEdge.Factory.Server.Build.BusinessComponents.CompleteVehicleBuild", true).
    end method.
    
    method override public void Load(  ):
        LoadWorkflows().
    end method.
    
end class.