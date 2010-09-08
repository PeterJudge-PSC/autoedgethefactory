/** ------------------------------------------------------------------------
    File        : StandardDataAccess
    Purpose     : Standard DataAccess object for filling ProDataSet-based business components.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Aug 24 15:04:40 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.DataSource.IDataSource.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.String.

using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.DataAccess.StandardDataAccess
        implements IDataAccess:
    
    define protected property DatasetHandle as handle no-undo get. set.
    
    define protected property DataSources as IMap no-undo get. private set.
    
    define private variable moCurrentResponse as IServiceResponse no-undo.
    /* The datasources currently in use for this request */
    define private variable moCurrentDataSources as ICollection no-undo.
    
    constructor public StandardDataAccess():
        this-object(new TypedMap('OpenEdge.Lang.String', 'OpenEdge.DataSource.IDataSource')).
    end constructor.
    
    constructor public StandardDataAccess(poDataSources as TypedMap):
        super().
        
        DataSources = poDataSources. 
        moCurrentDataSources = new TypedCollection(Class:GetClass('OpenEdge.DataSource.IDataSource')).
    end constructor.

    method public void AddDataSource(input pcTableName as character,
                                     input poDataSource as IDataSource):
        DataSources:Put(new String(pcTableName), poDataSource).
    end method.
    
    method protected IDataSource GetDataSource(input pcTableName as character):
        return cast(DataSources:Get(new String(pcTableName)), IDataSource).
    end method.
    
    method public IFetchResponse GetData():
        
        return cast(moCurrentResponse, IFetchResponse).
        
        finally:
            moCurrentDataSources:Clear().
        end finally.
    end method.
    
    method public ISaveResponse SaveData(input poRequest as ISaveRequest):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable oDataSource as IDataSource no-undo.
        
        cast(poRequest, IServiceMessage):GetData(output DatasetHandle).
        
        /* Don't pass in the request as an argument since we don't know how many of the dataset's
           tables are being operated on in this request. */
        moCurrentResponse = new SaveResponse(poRequest).
        cast(moCurrentResponse, IServiceMessage):SetData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        AddDatasetCallbacks(DatasetHandle,
                            /* Should be Save or something similar. You'd expect. */
                            cast(poRequest, IServiceMessage):ActionType).
        
        iMax = DatasetHandle:num-buffers.
        do iLoop = 1 to iMax:
            hBuffer = DatasetHandle:get-buffer-handle(iLoop).
            oDataSource = GetDataSource(hBuffer:name).
            if valid-object(oDataSource) then
            do:
                AddBufferCallbacks(hBuffer, ServiceMessageActionEnum:Save).
                
                /* saves for all records in buffer. */
                oDataSource:SaveData(hBuffer).
            end.
        end.
        
        RemoveAllCallbacks(DatasetHandle, ServiceMessageActionEnum:Fetch).
    end method.
    
    method public void FetchData(input poRequest as IFetchRequest):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable oDataSource as IDataSource no-undo.
        define variable oServiceMessage as IServiceMessage no-undo. 

        oServiceMessage = cast(poRequest, IServiceMessage).
        oServiceMessage:GetData(DatasetHandle).
        
        /* Don't pass in the request as an argument since we don't know how many of the dataset's
           tables are being operated on in this request. */
        moCurrentResponse = new FetchResponse(poRequest).
        cast(moCurrentResponse, IServiceMessage):SetData(DatasetHandle, DataFormatEnum:ProDataSet).
        
        AddDatasetCallbacks(DatasetHandle, ServiceMessageActionEnum:Fetch).
        
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
                    moCurrentDataSources:Add(oDataSource).
                    oDataSource:FillMode = FillModeEnum:Append.
                    oDataSource:PrepareForFetch(hBuffer, oTableRequest).
                    
                    AddBufferCallbacks(hBuffer, ServiceMessageActionEnum:Fetch).
                    
                    /* Create an entry for the request buffer. We do this here since this is the
                       only place that we know that we're making a request for a particular table/buffer. */
                     cast(moCurrentResponse, IFetchResponse):TableResponses:Put(hBuffer:name, new TableResponse(hBuffer:name)).
                end.
            end.
        end.
        
        /* Get data into this dataset */
        FetchData(moCurrentDataSources).
    end method.
    
    /**
        @param ICollection The datasources being used for this request
      */
    method protected void FetchData(input poDataSources as ICollection):
        /* This could be a call to the individual datasources to populate their data.
            cast(poDataSources[1], IDataSource):FetchData().
         */
        
        DatasetHandle:fill().
        
        RemoveAllCallbacks(DatasetHandle, ServiceMessageActionEnum:Fetch).
    end method.
    
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
    
    /** Add ABL callbacks for the action.
        
        @return Logical value indicating whether there are any callbacks set for the buffer */
    method protected logical AddBufferCallbacks(input phBuffer as handle,
                                                input poServiceMessageAction as ServiceMessageActionEnum):
            case poServiceMessageAction:
                when ServiceMessageActionEnum:Fetch  then
                do:
                    /* GetDataSource(phBuffer:name):BeforeRowFill:Subscribe(XXX).*/
                    /* ohBuffer:set-callback(CallbackNameEnum:BeforeRowFill:ToString(), 'XXX', this-object). */
                end.
            end case.
    end method.
    
    method protected void RemoveBufferCallbacks(input phBuffer as handle,
                                                input poServiceMessageAction as ServiceMessageActionEnum):
    end method.
    
    /** General  
        @return Logical value indicating whether there are any callbacks set for the ProDataSet */
    method protected void AddDatasetCallbacks(input phDataset as handle,
                                              input poServiceMessageAction as ServiceMessageActionEnum):
        /* DatasetHandle:set-callback(CallbackNameEnum:AfterFill:ToString(), 'someThinG', this-object). */
    end method.
    
    method protected void RemoveDatasetCallbacks(input phDataset as handle,
                                                 input poServiceMessageAction as ServiceMessageActionEnum):
    end method.
    
end class.