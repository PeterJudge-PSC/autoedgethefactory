/** ------------------------------------------------------------------------
    File        : CompleteVehicleBuild
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 30 16:39:34 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Build.BusinessComponents.CompleteVehicleBuild.
using AutoEdge.Factory.Build.BusinessComponents.VehicleBuildStep.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.

using OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkStepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using Progress.Lang.Class.

class AutoEdge.Factory.Build.BusinessComponents.CompleteVehicleBuild inherits VehicleBuildStep:
    
    
	constructor public CompleteVehicleBuild(input poServiceManager as IServiceManager,
	                                        input poComponentInfo as IComponentInfo    ):
		super (input poServiceManager, input poComponentInfo).
	end constructor.
		
	constructor public CompleteVehicleBuild(input poServiceManager as IServiceManager,
	                                        input poComponentInfo as IComponentInfo,
	                                        input poBizLogicParams as IBizLogicServerParameters ):
		super (input poServiceManager, input poComponentInfo, input poBizLogicParams).
	end constructor.

    method override public void PerformStep(input poRequest as IWorkStepRequest):
        define variable cDSName as character extent 1 no-undo.
        define variable cDSValue as character extent 1 no-undo.
        define variable oDSI as DataSlotInstance extent no-undo.
        define variable oBLRequest as BizLogicWorkStepRequest no-undo.
        
        super:PerformStep(input poRequest).
        
        /* easier/more readable than continually casting */
        oBLRequest = cast(poRequest, BizLogicWorkStepRequest).
        
        CompleteWorkItem(oDSI).
        cDSName[1] = 'VehicleBuildComplete'.
        cDSValue[1] = 'true'.
        
        UpdateDataSlotValue(oBLRequest:ProcessInstanceId,
                            oBLRequest:ProcessInstanceName,
                            cDSName,
                            cDSValue).
    end method.
    
    method override public void PerformStep():
        QualityControlCheckEngine().
        QualityControlCheckBody().
        QualityControlAnalyzeRepair().
    end method.
    
    method protected void QualityControlCheckEngine():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'QualityControlCheckEngine').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'QualityControlCheckEngine').
    end method.
    
    method protected void QualityControlCheckBody():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'QualityControlCheckBody').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'QualityControlCheckBody').
    end method.
    
    method protected void QualityControlAnalyzeRepair():
        BuildStatus = substitute('Substep &1 [ STARTING ]', 'QualityControlAnalyzeRepair').
        
        BuildStatus = substitute('Substep &1 [ OK ]', 'QualityControlAnalyzeRepair').
    end method.
    

end class.