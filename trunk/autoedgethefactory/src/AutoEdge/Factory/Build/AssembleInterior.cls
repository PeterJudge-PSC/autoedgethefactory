/** ------------------------------------------------------------------------
    File        : IAssembleInterior
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:38:15 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Build.AssembleInterior.
using AutoEdge.Factory.Build.VehicleBuildStep.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Build.AssembleInterior inherits VehicleBuildStep:  
    
	constructor public AssembleInterior(input poServiceManager as IServiceManager,
	                                    input poComponentInfo as IComponentInfo  ):
		super (input poServiceManager, input poComponentInfo).
	end constructor.

    /* step */
    method override public void PerformStep():
        InstallUpholstery().
        InstallElectronics().
        InstallInteriorTrim().
        FitWindshield().
    end method.
    
    method protected void InstallUpholstery():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'InstallUpholstery').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'InstallUpholstery').
    end method.
    
    method protected void InstallElectronics():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'InstallElectronics').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'InstallElectronics').
    end method.
    
    method protected void InstallInteriorTrim():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'InstallInteriorTrim').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'InstallInteriorTrim').
    end method.
    
    method protected void FitWindshield():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'FitWindshield').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'FitWindshield').
    end method.
  
end class.