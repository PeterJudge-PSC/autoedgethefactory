/** ------------------------------------------------------------------------
    File        : StandardDataAccess
    Purpose     : Standard DataAccess object for filling ProDataSet-based business components.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Aug 24 15:04:40 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.DataSource.IDataSource.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.String.
using OpenEdge.Lang.DataTypeEnum.

using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.DataAccess.StandardDataAccess
        implements IDataAccess:
    
    define protected property DatasetHandle as handle no-undo get. set.
    define protected property DataSources as IMap no-undo get. private set.
    
    /* The datasources currently in use for the current request */
    define private variable moCurrentRequest as IServiceRequest no-undo.
    define private variable moCurrentRequestDataSources as ICollection no-undo.
    
    constructor public StandardDataAccess():
        this-object(new TypedMap('OpenEdge.Lang.String', 'OpenEdge.DataSource.IDataSource')).
    end constructor.
    
    constructor public StandardDataAccess(input poDataSources as TypedMap):
        super().
        
        DataSources = poDataSources.
        moCurrentRequestDataSources = new TypedCollection(Class:GetClass('OpenEdge.DataSource.IDataSource')).
    end constructor.

    method public void AddDataSource(input pcTableName as character,
                                     input poDataSource as IDataSource):
        DataSources:Put(new String(pcTableName), poDataSource).
    end method.
    
    method protected IDataSource GetDataSource(input pcTableName as character):
        return cast(DataSources:Get(new String(pcTableName)), IDataSource).
    end method.
    
    method public IFetchResponse GetData():
        define variable oIterator as IIterator no-undo.
        define variable oFetchResponse as IFetchResponse no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        
        oFetchResponse = new FetchResponse(cast(moCurrentRequest, IFetchRequest)). 
        cast(oFetchResponse, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        oIterator = moCurrentRequestDataSources:Iterator().
        do while oIterator:HasNext():
            oTableResponse = cast(oIterator:Next(), IDataSource):GetData().
            
            /* Create an entry for the request buffer. We do this here since this is the
               only place that we know that we're making a request for a particular table/buffer. */
            oFetchResponse:TableResponses:Put(oTableResponse:TableName, oTableResponse).
            
            /* cascade error flag up. */
            if oTableResponse:HasError then
                cast(oFetchResponse, IServiceResponse):HasError = true.
        end.
        
        return oFetchResponse.
        finally:
            moCurrentRequestDataSources:Clear().
            moCurrentRequest = ?.
        end finally.
    end method.
    
    method public ISaveResponse SaveData(input poRequest as ISaveRequest):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable oDataSource as IDataSource no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        define variable oSaveResponse as ISaveResponse no-undo.
        
        oSaveResponse = new SaveResponse(poRequest).
        cast(poRequest, IServiceMessage):GetMessageData(output DatasetHandle).
        
        AddDatasetCallbacks(DatasetHandle,
                            /* Should be Save or something similar. You'd expect. */
                            cast(poRequest, IServiceMessage):ActionType).
        
        iMax = DatasetHandle:num-buffers.
        do iLoop = 1 to iMax:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop).
            oDataSource = GetDataSource(hBuffer:name).
            if valid-object(oDataSource) then
            do:
                AddBufferCallbacks(hBuffer, cast(poRequest, IServiceMessage):ActionType).
                
                /* saves for all data in the data target (buffer in this case). */
                oDataSource:SetDataTarget(hBuffer).
                oTableResponse = oDataSource:SaveData().
                
                /* cascade error flag up to message from tableresponse */                
                if oTableResponse:HasError then
                    assign cast(oSaveResponse, IServiceResponse):HasError = true.
            end.
        end.
        
        RemoveAllCallbacks(DatasetHandle, cast(poRequest, IServiceMessage):ActionType).
        
        /* Set the response error stuff to that of the dataset. */        
        if DatasetHandle:error then
            assign cast(oSaveResponse, IServiceResponse):HasError = true
                   cast(oSaveResponse, IServiceResponse):ErrorText = DatasetHandle:error-string.
        
        /* Add the data to the message */
        cast(oSaveResponse, IServiceMessage):SetMessageData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        return oSaveResponse.
    end method.
    
    method public void FetchData(input poRequest as IFetchRequest):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable oDataSource as IDataSource no-undo.
        define variable oServiceMessage as IServiceMessage no-undo. 

        oServiceMessage = cast(poRequest, IServiceMessage).
        oServiceMessage:GetMessageData(output DatasetHandle).
        
        /* Keep a record of the current request, for use in constructing the response in GetData(). */
        moCurrentRequest = cast(poRequest, IServiceRequest).
        
        AddDatasetCallbacks(DatasetHandle, cast(poRequest, IServiceMessage):ActionType). 
        
        /* Clean out just to be sure.*/
        moCurrentRequestDataSources:Clear().
        
        iMax = DatasetHandle:num-buffers.
        do iLoop = 1 to iMax:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop). 
            hBuffer:fill-mode = FillModeEnum:NoFill:ToString().
            
            if not poRequest:TableRequests:IsEmpty() then
                oTableRequest = poRequest:TableRequests:Get(hBuffer:name).
            
            /* no tableRequests = all tables */
            if valid-object(oTableRequest) or poRequest:TableRequests:IsEmpty() then
            do:
                oDataSource = GetDataSource(hBuffer:name).
                if valid-object(oDataSource) then
                do:
                    moCurrentRequestDataSources:Add(oDataSource).
                    oDataSource:FillMode = FillModeEnum:Append.
                    
                    oDataSource:SetDataTarget(hBuffer).
                    oDataSource:Prepare(oTableRequest).
                    
                    AddBufferCallbacks(hBuffer, cast(poRequest, IServiceMessage):ActionType).
                end.
            end.
        end.
        
        /* Get data into this dataset */
        FetchData().
    end method.
    
    /** Fetch/retrieve data from the datasource, and populate the business entity with 
        it. */
    method protected void FetchData():
        /* This could be a call to the individual datasources to populate their data.
            cast(moCurrentRequestDataSources:Get(1), IDataSource):PerformFetch().
         */
        DatasetHandle:fill().
        
        RemoveAllCallbacks(DatasetHandle, cast(moCurrentRequest, IServiceMessage):ActionType).
    end method.
    
    /** Removes all the callbacks on a dataset and its buffers, for a given action. 
        
        @param handle The dataset handle for which to remove the callbacks.
        @param ServiceMessageActionEnum The action being performed.     */
    method protected void RemoveAllCallbacks(input phDatasetHandle as handle,
                                             input poServiceMessageAction as ServiceMessageActionEnum):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = phDatasetHandle:num-buffers.
        do iLoop = 1 to iMax:
            RemoveBufferCallbacks(phDatasetHandle:get-buffer-handle(iLoop), 
                                  poServiceMessageAction).
        end.
        
        RemoveDatasetCallbacks(phDatasetHandle, poServiceMessageAction).
    end method.
    
    /** Add ABL callbacks to a buffer handle for an action.
    
        @param handle The buffer on which to attach the callback
        @param ServiceMessageActionEnum The action being performed.
        
        @return Logical value indicating whether there are any callbacks set for the buffer */
    method protected logical AddBufferCallbacks(input phBuffer as handle,
                                                input poServiceMessageAction as ServiceMessageActionEnum):
            case poServiceMessageAction:
                when ServiceMessageActionEnum:Fetch then
                do:
                    /* GetDataSource(phBuffer:name):BeforeRowFill:Subscribe(XXX).*/
                    /* ohBuffer:set-callback(CallbackNameEnum:BeforeRowFill:ToString(), 'XXX', this-object). */
                end.
            end case.
    end method.

    /** Remove ABL callbacks from a buffer handle for an action.
    
        @param handle The dataset from which to remove the callback
        @param ServiceMessageActionEnum The action being performed. */
    method protected void RemoveBufferCallbacks(input phBuffer as handle,
                                                input poServiceMessageAction as ServiceMessageActionEnum):
    end method.
    
    /** Add ABL callbacks to a buffer handle for an action.
    
        @param handle The dataset on which to attach the callback
        @param ServiceMessageActionEnum The action being performed.
        
        @return Logical value indicating whether there are any callbacks set for the buffer */
    method protected void AddDatasetCallbacks(input phDataset as handle,
                                              input poServiceMessageAction as ServiceMessageActionEnum):
        /* DatasetHandle:set-callback(CallbackNameEnum:AfterFill:ToString(), 'someThinG', this-object). */
    end method.
    
    /** Remove ABL callbacks from a dataset handle for an action.
    
        @param handle The dataset from which to remove the callback
        @param ServiceMessageActionEnum The action being performed. */            
    method protected void RemoveDatasetCallbacks(input phDataset as handle,
                                                 input poServiceMessageAction as ServiceMessageActionEnum):
    end method.
    
end class.