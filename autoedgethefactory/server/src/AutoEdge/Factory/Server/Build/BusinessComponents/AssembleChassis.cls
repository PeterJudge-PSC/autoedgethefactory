/** ------------------------------------------------------------------------
    File        : AssembleChassis
    Purpose     : Chassis assembly workstep
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:14:06 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Build.BusinessComponents.VehicleBuildStep.
using AutoEdge.Factory.Server.Build.BusinessComponents.AssembleChassis.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Server.Build.BusinessComponents.AssembleChassis inherits VehicleBuildStep:
        
    constructor public AssembleChassis(input poServiceManager as IServiceManager, 
                                       input poComponentInfo as IComponentInfo ):
        super (input poServiceManager, input poComponentInfo).
    end constructor.

    method override public void PerformStep():
        AssembleFrame().
        AssembleEngineTransmission().
    end method.
        
    method protected void AssembleFrame():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'AssembleFrame').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'AssembleFrame').
    end method.
        
    method protected void AssembleEngineTransmission():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'AssembleEngineTransmission').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'AssembleEngineTransmission').
    end method.
  
end class.