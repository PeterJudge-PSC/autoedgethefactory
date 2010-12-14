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

using AutoEdge.Factory.Build.CompleteVehicleBuild.
using AutoEdge.Factory.Build.VehicleBuildStep.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequestError.
using OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkStepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
 
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class AutoEdge.Factory.Build.CompleteVehicleBuild inherits VehicleBuildStep:
    
    /** The ServiceMessageManager is used plentifully; we keep it as a property so that
        we can get it whenever needed, without fuss. */
    define protected property ServiceMessageManager as IServiceMessageManager no-undo
        get():
            if not valid-object(ServiceMessageManager) then
                ServiceMessageManager = cast(ServiceManager:GetService(
                        Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager')),
                    IServiceMessageManager).
            
            return ServiceMessageManager.
        end get.
        private set.
    
    define private variable mhOrderDataset as handle no-undo.
    
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
        
        /* update the order with the status */
        UpdateOrderViaBusinessEntity().
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
    
    method protected void UpdateOrderViaBusinessEntity():
        /* fetch order  */
        FetchOrderViaEntity(this-object:OrderId, output dataset-handle mhOrderDataset).
        EnableDatasetForUpdate(mhOrderDataset).
        
        /* update with new status */
        UpdateOrderStatus(this-object:OrderId, 'CompletedVehicleBuild').
        
        /* save updated status on the order */
        CommitChangesViaEntity().
    end method.

    method public void UpdateOrderStatus(input pcOrderId as character,
                                         input pcStatus as character):
        define variable hBuffer as handle no-undo.
        
        hBuffer = mhOrderDataset:get-buffer-handle('eOrder').
        hBuffer:find-first(' where ' + hBuffer:name + '.OrderId = ' + quoter(pcOrderId)) no-error.
        if hBuffer:available then
        do transaction:
            hBuffer::OrderStatus = pcStatus.
            hBuffer:buffer-release().
        end.
    end method.
    
    method public void CommitChangesViaEntity():
        define variable oBE as IBusinessEntity no-undo.
        define variable oSaveRequest as ISaveRequest no-undo.
        
        oBE = cast(ServiceManager:StartService(        
                        Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity'),
                        'OrderUpdate'), IBusinessEntity).
        
        oSaveRequest = BuildSaveRequest().
        if valid-object(oSaveRequest) then
            ProcessSaveResponse(oBE:SaveData(oSaveRequest)).
    end method.
    
    method protected void ProcessSaveResponse(input poSaveResponse as ISaveResponse):
        define variable hTransport as handle no-undo.
        define variable iLoop-1 as integer no-undo.
        define variable iMax-1 as integer no-undo.
        define variable iLoop-2 as integer no-undo.
        define variable iMax-2 as integer no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        define variable cTableName as character no-undo.                
        define variable oKeys as String extent no-undo.
        define variable cKeyValue as character no-undo.
        define variable oTexts as String extent no-undo.
        define variable cTextValue as character no-undo.
        define variable oRequestError as ServiceRequestError no-undo.
        define variable oInnerRequestError as ServiceRequestError no-undo.
        
        cast(poSaveResponse, IServiceMessage):GetMessageData(output hTransport).
        if cast(poSaveResponse, IServiceResponse):HasError then
        do:
            iMax-1 = num-entries(cast(poSaveResponse, IServiceResponse):ErrorText, '|').
            
            do iLoop-1 = 1 to iMax-1: 
                cTableName = entry(iLoop-1, cast(poSaveResponse, IServiceResponse):ErrorText, '|').
                
                oTableResponse = cast(poSaveResponse:TableResponses:Get(new String(cTableName))                
                                    , ITableResponse).
                
                oKeys = cast(oTableResponse:ErrorText:KeySet:ToArray(), String).
                oTexts = cast(oTableResponse:ErrorText:Values:ToArray(), String).
                
                iMax-2 = extent(oKeys).
                do iLoop-2 = 1 to iMax-2:
                    assign cKeyValue = oKeys[iLoop-2]:Value
                           cTextValue = oTexts[iLoop-2]:Value.

                    oRequestError = new ServiceRequestError(oInnerRequestError,
                                                substitute(' in table &1', oTableResponse:TableName),
                                                substitute('with id &1 : key value = &2 : error text = &3',
                                                                cast(poSaveResponse, IServiceMessage):MessageId,
                                                                cKeyValue,
                                                                cTextValue)).
                    oInnerRequestError = oRequestError.
                end.
                
                oRequestError = new ServiceRequestError(oInnerRequestError,
                                            substitute(' in table &1', oTableResponse:TableName),
                                            substitute('with &1 errors', string(iMax-2))).
                oInnerRequestError = oRequestError.
            end.
            
            undo, throw new ServiceRequestError(
                                oInnerRequestError,
                                substitute(' performing ', cast(poSaveResponse, IServiceMessage):ActionType:ToString()),
                                substitute('with request id &1', cast(poSaveResponse, IServiceMessage):MessageId)).
        end.    /* HasError */
        else
        do:
            DisableDatasetForUpdate(mhOrderDataset).
            hTransport:merge-changes(mhOrderDataset, true).
            EnableDatasetForUpdate(mhOrderDataset).
        end.    /* HasErrors */
        
    end method.

    method protected void FetchOrderViaEntity(input pcOrderId as character, output dataset-handle phOrders):
        define variable oRequest as IFetchRequest no-undo.
        define variable oResponse as IFetchResponse no-undo.
        define variable hDataset as handle no-undo.
        define variable oBE as IBusinessEntity no-undo.

        oBE = cast(ServiceManager:StartService(        
                        Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity'),
                        'OrderUpdate'), IBusinessEntity).
        
        oRequest = BuildFetchRequest().
        oBE:FetchData(oRequest).
        oResponse = oBE:GetData(cast(oRequest, IServiceMessage):MessageId).
        
        cast(oResponse, IServiceMessage):GetMessageData(output phOrders).        
    end method.
    
    method protected IFetchRequest BuildFetchRequest():
        define variable oFetchRequest as IFetchRequest no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable cTableName as character no-undo.
        
        oFetchRequest = new FetchRequest('OrderUpdate', ServiceMessageActionEnum:FetchData).
        
        cTableName = 'eOrder'.
        oTableRequest = new TableRequest(cTableName).
        oFetchRequest:TableRequests:Put(cTableName, oTableRequest).
        cast(oTableRequest, IQueryDefinition):AddFilter(cTableName,
                                              'OrderId',
                                              OperatorEnum:IsEqual,
                                              new String(this-object:OrderId),
                                              DataTypeEnum:Character,
                                              JoinEnum:None).
        return oFetchRequest. 
    end method.
    
    method protected ISaveRequest BuildSaveRequest():
        define variable oSaveRequest as ISaveRequest no-undo.
        define variable cTableName as char extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hTransportDataset as handle no-undo.
        define variable hBuffer as handle no-undo.
        
        oSaveRequest = new SaveRequest('OrderUpdate').
        
        /* Get the change data */
        create dataset hTransportDataset.
        hTransportDataset:create-like(mhOrderDataset).
        hTransportDataset:get-changes(mhOrderDataset).
        
        /* Put the PDS into the message */
        cast(oSaveRequest, IServiceMessage):SetMessageData(
                hTransportDataset,
                DataFormatEnum:ProDataSet).
        
        extent(cTableName) = mhOrderDataset:num-buffers.
                       
        /* We set the ISaveRequest:TableNames property, but we
            can probably also derive that from the dataset. */
        do iLoop = 1 to extent(cTableName):
            hBuffer = hTransportDataset:get-buffer-handle(iLoop).
            
            if hBuffer:before-buffer:table-handle:has-records then
                assign cTableName[iLoop] = hBuffer:name
                       iMax = iMax + 1.
        end.
        
        /* no updates needed. */
        if iMax gt 0 then
        do:
            extent(oSaveRequest:TableNames) = iMax.
            iMax = 0.
            do iLoop = 1 to extent(cTableName):         
                iMax = iMax + 1.
                if cTableName[iLoop] ne '' then
                    oSaveRequest:TableNames[iMax] = cTableName[iloop].
            end.
        end.
                
        return oSaveRequest.         
    end method.
    
    method protected void EnableDatasetForUpdate (phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = true.
        end.
    end method.
    
    method protected void DisableDatasetForUpdate(phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = no.
        end.
    end method.
    
end class.