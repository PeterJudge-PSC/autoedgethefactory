/** ------------------------------------------------------------------------
    File        : BizLogicWorkStep
    Purpose     : Savvion BizLogic workflow class. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 13:45:41 EST 2010
    Notes       : * This might be used when we complete a step, and want to notify
                    the Savvion process of that fact. Or when we want to update 
                    DataSlotValues on completion.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicWorkFlow.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicAPI.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkFlowWebService.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.
using OpenEdge.BusinessComponent.WorkFlow.WorkStep.
using OpenEdge.BusinessComponent.WorkFlow.IWorkStep.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepResponse.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class. 

class OpenEdge.BusinessComponent.WorkFlow.BizLogic.BizLogicWorkStep abstract inherits WorkStep:
    
    /** Host and port of the Savvion SBM Server */
    define public property ServerParameters as IBizLogicServerParameters no-undo get. private set.
    
    define protected property SessionId as longchar no-undo get. private set.
    define protected property BizLogicService as IBizLogicAPI no-undo get. set.
    define protected property IsBizLogicConnected as logical no-undo
        get():
            return (valid-object(BizLogicService) and SessionId ne '').
        end get.
    
    constructor public BizLogicWorkStep(input poServiceManager as IServiceManager,
                                        input poComponentInfo as IComponentInfo):
        super(input poServiceManager, input poComponentInfo).
    end constructor.
    
	constructor public BizLogicWorkStep(input poServiceManager as IServiceManager,
	                                    input poComponentInfo as IComponentInfo,
                                        input poBizLogicParams as IBizLogicServerParameters):
		this-object(input poServiceManager, poComponentInfo).

        Assert:ArgumentNotNull(poBizLogicParams, 'BizLogic Server parameters').
        ServerParameters = poBizLogicParams.
	end constructor.
	
	method protected void ConnectBizLogicService():
        define variable cWorkStep as character no-undo.
        if not IsBizLogicConnected then
        do:
            if not valid-object(ServerParameters) then
                ServerParameters = cast(ServiceManager:Kernel:Get(Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters'))
                                     , IBizLogicServerParameters).
            
            /* once we're done with the step, tell Savvion */
            BizLogicService = new WorkFlowWebService(ServerParameters:Host + ':' + string(ServerParameters:Port)).
            SessionId = ServerParameters:Connect(BizLogicService).
        end.
    end method.
	
	method protected void DisconnectBizLogicService():
	    if IsBizLogicConnected then
            BizLogicService:Disconnect(SessionId).
        
        finally:
            SessionId = ''.
        end finally.
    end method.
        
    method protected void CompleteWorkItem(input poDataSlotInstance as DataSlotInstance extent):
        if not IsBizLogicConnected then
            ConnectBizLogicService().
            
        BizLogicService:CompleteWorkItem(SessionId,
                                         string(Name),
                                         poDataSlotInstance).
    end method. 
    	
	method protected void UpdateDataSlotValue(input piProcessInstanceId as int64,
	                                          input pcProcessInstanceName as character,
	                                          input pcDataSlotName as character extent,
	                                          input pcDataSlotValue as character extent):
        define variable oDataSlotInstance as DataSlotInstance extent no-undo.
        define variable iInnerLoop as integer no-undo.
        define variable iInnerMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        if not IsBizLogicConnected then
            ConnectBizLogicService().
                
        oDataSlotInstance= BizLogicService:GetProcessInstanceDataSlotFromPIID(
                                SessionId,
                                piProcessInstanceId,
                                pcDataSlotName).
        iMax = extent(oDataSlotInstance).
        iInnerMax = extent(pcDataSlotName).
        do iLoop = 1 to iMax:
            
            do iInnerLoop = 1 to iInnerMax:
                if pcDataSlotName[iInnerLoop] eq oDataSlotInstance[iLoop]:Name then
                do:
                    oDataSlotInstance[iLoop]:Value = pcDataSlotValue[iInnerLoop].
                    leave.
                end.
            end.    /* inner loop */
        end. /* outer loop */
        
        BizLogicService:SetProcessInstanceDataSlotsValue(
                            SessionId,
                            pcProcessInstanceName,
                            oDataSlotInstance).
    end method.
	
	method override public void DestroyComponent(  ):
		super:DestroyComponent().
    
        DisconnectBizLogicService().
	end method.


	method override public void Initialize(  ):
		super:Initialize().

/*        ConnectBizLogicService().*/
	end method.

	method override public void PerformStep( input poRequest as OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest ):
        Assert:ArgumentNotType(poRequest,
                               Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkFlowRequest')).
        
		super:PerformStep(input poRequest).
	end method.

end class. 