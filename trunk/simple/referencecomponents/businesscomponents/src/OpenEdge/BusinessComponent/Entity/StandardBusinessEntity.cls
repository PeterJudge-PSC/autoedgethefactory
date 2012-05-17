/** ------------------------------------------------------------------------
    File        : StandardBusinessEntity
    Purpose     : Standard ProDataSet-based business entity 
    Syntax      : 
    Description : 
    @author pjudge
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceRequestError.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.CallbackNameEnum.
using OpenEdge.Lang.String.

class OpenEdge.BusinessComponent.Entity.StandardBusinessEntity abstract inherits BusinessEntity:
    
    @todo(task="implement", action="BE schema in XSD? PDS? ").
    @todo(task="refactor", action="investigate this mechanism. use property or just make Copy...() abstract?").    
    define protected property StaticDatasetHandle as handle no-undo get. private set.

    /** Each BusinessEntity derived from this class will need to specify its own DatasetHandle value,
        since they will all differ */
    define abstract protected property DatasetHandle as handle no-undo get. set.

    constructor public StandardBusinessEntity(input poComponentInfo as IComponentInfo,
                                              input poDAO as IDataAccess ):
        super(input poComponentInfo, input poDAO).
    end constructor.

    constructor public StandardBusinessEntity(input poComponentInfo as IComponentInfo ):
        super(input poComponentInfo).
    end constructor.

    method override protected void BeforeFetchData(poRequest as IFetchRequest):
        /* We assume new data appending requests would possibly need 
           direction to MERGE or APPEND in fill */
        cast(poRequest, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
    end method.
        
	method override protected void AfterSaveData(input poRequest as ISaveRequest,
	                                             input poResponse as ISaveResponse ):
		super:AfterSaveData(input poRequest, input poResponse).
		
        cast(poRequest, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
		
        /* make post-save BusinessEntity  validation calls here */
	end method.

	method override protected void BeforeSaveData( input poRequest as ISaveRequest ):
        define variable oSaveResponse as ISaveResponse no-undo.
        define variable hDataset as handle no-undo.
        
		super:BeforeSaveData(input poRequest).
		
        cast(poRequest, IServiceMessage):GetMessageData(output hDataset).
        ReceiveDataset(hDataset).
        
        /* Make any pre-save BusinessEntity validation calls here. No need for a generic
          'dataset+PreSave' name, since each BE will add its own overrides. 
          
          The DataAccess and DataSources take care of ProDataSet- and Buffer-level events/
          callbacks if needed. */          
	end method.
	
    /** Defines the entity in terms of the schema that the underlying prodataset or
        temp-tables will have. This is useful for example for binding UI before any data
        is requested.
        
        @param IFetchRequest The request containing the individual tablerequests 
        @return IFetchResponse The response containing the schema */
    method override public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest):
        define variable oFetchSchemaResponse as IFetchResponse no-undo.
        define variable hDataset as handle no-undo.
        
        create dataset hDataset.
        hDataset:create-like(DatasetHandle).
        
        oFetchSchemaResponse = new FetchResponse(poDefineRequest).
        cast(oFetchSchemaResponse, IServiceMessage):SetMessageData(hDataset, DataFormatEnum:ProDataSet).
        
        return oFetchSchemaResponse.
    end method.
    
    /** Response complement method for FetchData above.
        
        @param character The message id for the request/response
        @return IFetchResponse */
    method override public IFetchResponse GetData(input pcMessageId as longchar):
        define variable oResponse as IFetchResponse no-undo.
        define variable hDataset as handle no-undo.
        
        oResponse = DataAccess:GetData(pcMessageId).

        cast(oResponse, IServiceMessage):GetMessageData(output hDataset).
        ReceiveDataset(hDataset).
        
        return oResponse.
    end method.    
    
    /** Allows us to 'push' data from a ServiceMessage (typically SaveData) into the Business Entity's
        dataset, and thus allow us to use static code (ie FOR EACH eCustomer) on it, instead of having
        to use dynamic programming constructs.
        
        Note that the implementing method will need to have a static dataset as its input parameter,
        so that the ABL can do what we want it to. 
        
        @param handle The dataset passed by message. */
    method abstract protected void ReceiveDataset(input phDataset as handle).

/** METHODS BEFORE FOR UPDATEABLE BUSINESS ENTITY **/
    method protected void EnableDatasetForUpdate():
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        if valid-handle(DatasetHandle) then
        do iLoop = 1 to DatasetHandle:num-buffers:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = true.
        end.
    end method.
        
    method protected void DisableDatasetForUpdate():
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        if valid-handle(DatasetHandle) then
        do iLoop = 1 to DatasetHandle:num-buffers:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = no.
        end.
    end method.
    
    /** Builds a save request for the Business Entity.  
        
        @return ISaveRequest The complete save request for the BusinessEntity */
    method protected ISaveRequest BuildSaveRequest():
        define variable oSaveRequest as ISaveRequest no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iExtent as integer no-undo. 
        define variable cChangedTables as character extent no-undo.
        define variable hBuffer as handle no-undo.
        
        /* The instance name is the unique name of this IBusinessEntity service. */
        oSaveRequest = new SaveRequest(this-object:ComponentInfo:InstanceName).
        
        /* Put the PDS into the message */
        cast(oSaveRequest, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        /* We set the ISaveRequest:TableNames property, but we
           can probably also derive that from the dataset. */
        iMax = DatasetHandle:num-buffers.
        extent(cChangedTables) = iMax.
        do iLoop = 1 to iMax:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop).
            
            /* There will always be records in the before buffer, regardless of the operation.
               The 'after' buffer won't contain deletes. */
            if hBuffer:before-buffer:table-handle:has-records then
                assign iExtent = iExtent + 1
                       cChangedTables[iExtent] = hBuffer:name.
        end.
        
        if iExtent gt 0 then
        do:
            /* Fill the array backwards, since a stack is always LIFO. Order is
               probably not important anyway, but ... */
            extent(oSaveRequest:TableNames) = iExtent.
            do iLoop = 1 to iMax while cChangedTables[iLoop] ne '':
                oSaveRequest:TableNames[iLoop] = cChangedTables[iloop].
            end.
        end.
        
        return oSaveRequest.
    end method.

    method protected void CheckForSaveError(input poSaveResponse as ISaveResponse):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cTableName as character no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        define variable cKeys as longchar no-undo.
        define variable cTexts as longchar no-undo.
        
        if poSaveResponse:HasError then
        do:
            iMax  = num-entries(poSaveResponse:ErrorText, '|').
            do iLoop = 1 to iMax:
                cTableName = entry(iLoop, poSaveResponse:ErrorText, '|').
                
                oTableResponse = cast(poSaveResponse:TableResponses:Get(new String(cTableName)) , ITableResponse).
                
                cKeys = String:Join(cast(oTableResponse:ErrorText:KeySet:ToArray(), String), '|').
                cTexts = String:Join(cast(oTableResponse:ErrorText:Values:ToArray(), String), '|').
                undo, throw new ServiceRequestError(
                                    substitute('saving &1 data', poSaveResponse:Service), 
                                    substitute('[ Table: &1 Keys: &2 Text: &3]', 
                                            cTableName,
                                            cKeys,
                                            cTexts)).
            end.
        end.
    end method.                    

    method protected void CheckForFetchError(input poFetchResponse as IFetchResponse):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cTableName as character no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        define variable cKeys as longchar no-undo.
        define variable cTexts as longchar no-undo.
        
        if poFetchResponse:HasError then
        do:
            iMax  = num-entries(poFetchResponse:ErrorText, '|').
            do iLoop = 1 to iMax:
                cTableName = entry(iLoop, poFetchResponse:ErrorText, '|').
                
                oTableResponse = cast(poFetchResponse:TableResponses:Get(new String(cTableName)) , ITableResponse).
                
                cKeys = String:Join(cast(oTableResponse:ErrorText:KeySet:ToArray(), String), '|').
                cTexts = String:Join(cast(oTableResponse:ErrorText:Values:ToArray(), String), '|').
                undo, throw new ServiceRequestError(
                                    substitute('fetching &1 data', poFetchResponse:Service), 
                                    substitute('[ Table: &1 Keys: &2 Text: &3]', 
                                            cTableName,
                                            cKeys,
                                            cTexts)).
            end.
        end.
    end method.                    

end class.