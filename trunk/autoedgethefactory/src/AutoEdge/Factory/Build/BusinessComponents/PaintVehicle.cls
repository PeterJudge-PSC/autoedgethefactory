/** ------------------------------------------------------------------------
    File        : IPaintVehicle
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:36:59 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Build.BusinessComponents.VehicleBuildStep.
using AutoEdge.Factory.Build.BusinessComponents.PaintVehicle.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Build.BusinessComponents.PaintVehicle inherits VehicleBuildStep:

	constructor public PaintVehicle(input poServiceManager as IServiceManager, 
	                                input poComponentInfo as IComponentInfo  ):
		super (input poServiceManager, input poComponentInfo).
	end constructor.

    method override public void PerformStep():
        BodyInWhiteInspection().
        PaintUndercoat().
        PaintFinalCoat().
        BakePaint(). 
    end method.        
    
    method public void BodyInWhiteInspection():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'BodyInWhiteInspection').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'BodyInWhiteInspection').
    end method.
    
    method public void PaintUndercoat():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'PaintUndercoat').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'PaintUndercoat').
    end method.
    
    method public void PaintFinalCoat():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'PaintFinalCoat').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'PaintFinalCoat').
    end method.
    
    method public void BakePaint():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'BakePaint').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'BakePaint').
    end method.
     

end class.