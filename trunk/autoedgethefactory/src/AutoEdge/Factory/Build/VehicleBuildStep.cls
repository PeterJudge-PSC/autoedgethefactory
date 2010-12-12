/** ------------------------------------------------------------------------
    File        : VehicleBuildStep
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 15:55:25 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Build.IBuildVehicle.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.BizLogicWorkStep.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkStepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkStepResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.ApplicationError.

class AutoEdge.Factory.Build.VehicleBuildStep abstract inherits BizLogicWorkStep
        implements IBuildVehicle:
    
    /** (derived, readonly) The current status */
    define public property BuildStatus as character no-undo get. protected set.

    /** (mandatory) OrderId passed in to constructor. */  
    define public property OrderId as character no-undo get. private set.


    constructor public VehicleBuildStep(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
		
	constructor public VehicleBuildStep(input poServiceManager as IServiceManager,
	                                    input poComponentInfo as IComponentInfo,
	                                    input poBizLogicParams as IBizLogicServerParameters ):
		super(input poServiceManager, input poComponentInfo, input poBizLogicParams).
	end constructor.
    
    method override public IWorkStepResponse GetResponse(input pcMessageId as longchar):
        define variable oResponse as IWorkStepResponse no-undo.
        
        oResponse = super:GetResponse(pcMessageId).
        oResponse:Status = BuildStatus.
        
        if BuildStatus matches '*[ ERROR ]' then
            assign cast(oResponse, IServiceResponse):ErrorText = BuildStatus
                   cast(oResponse, IServiceResponse):HasError = true.

        return oResponse. 
    end method. 
    
    method override public void PerformStep(input poRequest as IWorkStepRequest):
        define variable cMsgData as longchar no-undo.
        
        cast(poRequest, IServiceMessage):GetMessageData(output cMsgData).
        OrderId = string(cMsgData).
        
        BuildStatus = substitute('WorkStep &1 [ STARTING ]', Name).
        
        super:PerformStep(input poRequest).
        
        BuildStatus = substitute('WorkStep &1 [ OK ]', Name).
        finally:
            OrderId = ''.
        end finally.
    end method.
        
end class.