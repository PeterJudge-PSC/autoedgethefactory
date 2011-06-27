/** ------------------------------------------------------------------------
    File        : IProcessComponents
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:14:50 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Build.BusinessComponents.VehicleBuildStep.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Server.Build.BusinessComponents.ProcessComponents inherits VehicleBuildStep:

    constructor public ProcessComponents(input poServiceManager as IServiceManager,
                                         input poComponentInfo as IComponentInfo):
        super (input poServiceManager, input poComponentInfo).
    end constructor.
    
    /* step */
    method override public void PerformStep():
        AssembleSubcomponents().
    end method.
    
    /* substeps */
    method public void AssembleSubcomponents():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'AssembleSubcomponents').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'AssembleSubcomponents').
    end method.
    
end class.