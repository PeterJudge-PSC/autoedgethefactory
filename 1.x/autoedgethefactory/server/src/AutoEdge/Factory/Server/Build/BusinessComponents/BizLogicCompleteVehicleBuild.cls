/** ------------------------------------------------------------------------
    File        : BizLogicCompleteVehicleBuild
    Purpose     : The OEBPM CompleteVehicleBuild workstep. This decorates the ABL-only step.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 16:48:52 EDT 2011
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.WorkFlow.BizLogicWorkStep.
using OpenEdge.BusinessComponent.WorkFlow.IWorkStep.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepRequest.

using OpenEdge.Lang.BPM.DataSlotInstance.

class AutoEdge.Factory.Server.Build.BusinessComponents.BizLogicCompleteVehicleBuild inherits BizLogicWorkStep: 
    
	constructor public BizLogicCompleteVehicleBuild (input poWorkStep as IWorkStep, input pcBpmServerName as character ):
		super (input poWorkStep, input pcBpmServerName).
	end constructor.

    method override public void PerformStep():
        define variable cDSName as character extent 1 no-undo.
        define variable cDSValue as character extent 1 no-undo.
        define variable oDSI as DataSlotInstance extent no-undo.
        
        super:PerformStep().
        
        CompleteWorkItem(oDSI).
        
        cDSName[1] = 'VehicleBuildComplete'.
        cDSValue[1] = 'true'.
        
        UpdateDataSlotValue(cDSName, cDSValue).
    end method.
    
end class.