/** ------------------------------------------------------------------------
    File        : BusinessEntity
    Purpose     : General Business entity class. The Business Entity is the primary
                  unit of business logic and data in the OERA.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Fri Aug 14 23:38:08 EDT 2009
    Notes       : * This class is abstract class since the Business Entity's 
                    data store could be a prodataset, temp-table or some other 
                    construct.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.

using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.Entity.BusinessEntity abstract inherits Service 
        implements IBusinessEntity:
    
    define static public property IBusinessEntityType as class Class no-undo get. private set.            
    
    /** The DataAccess object for this entity.
        The SetDataAccess method is a workaround for the lack of dynamic
        property invocation in the ABL.     */    
    define public property DataAccess as IDataAccess no-undo get. set.
    
    constructor static BusinessEntity():        
        BusinessEntity:IBusinessEntityType = Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity').
    end constructor.

    constructor public BusinessEntity(input poComponentInfo as IComponentInfo):
        super(poComponentInfo).
    end constructor.
        
    constructor public BusinessEntity(input poComponentInfo as IComponentInfo,
                                      input poDAO as IDataAccess):
        super(poComponentInfo).
        
        Assert:ArgumentNotNull(poDAO, 'Data Access Object').
        DataAccess = poDAO.
    end constructor.
    /** Returns a IDataContainer that's capable of operating against this IBusinessEntity.
        
        This is really a helper/friend method, but the ABL doesn't give us that level of
        access control, so we have to make this public so that we can operate against the
        interface. 
        
        @return IDataContainer A useable, useful data container. */
    method abstract public IDataContainer CreateDataContainer().
    
    method public void SetDataAccess (input poDataAccess as IDataAccess):
        Assert:ArgumentNotNull(poDataAccess, 'Data Access Object').
        DataAccess = poDataAccess.
    end method.
        
    /** Default data fetch retrieval. 
        
        @return IFetchResponse A message containing the fetched data. */
    method public IFetchResponse FetchData():
        define variable cMessageId as character no-undo.
        define variable oFetchRequest as IFetchRequest no-undo.
        define variable oFetchResponse as IFetchResponse no-undo.
        
        oFetchRequest = new FetchRequest(this-object:ComponentInfo:InstanceName).
        cMessageId = cast(oFetchRequest, IServiceMessage):MessageId.
        
        FetchData(oFetchRequest).
        
        return GetData(cMessageId).
    end method.
    
    /** Fetches data from the Data Access object. This call
        splits the request and resonse. To get the response,
        call GetData().
        
        This method is final, and the call is split into 3 separate parts:
        a Before-, a Do- and an AfterFetchData method. This
        is so that a concrete BE can override parts of the 
        behaviour easily.
        
        @param IFetchRequest The request parameters. */
    method final public void FetchData(input poRequest as IFetchRequest):
        BeforeFetchData(poRequest).
        DoFetchData(poRequest).
        AfterFetchData(poRequest).
    end method.
    
    /** Performs actions needed before the fetch is called. Allows easier
        overriding.
        
        @param IFetchRequest The fetch parameters */
    @method(virtual="true").
    method protected void BeforeFetchData(input poRequest as IFetchRequest):
    end method.
    
    /** Performs actual fetch from DataAccess object
        
        @param IFetchRequest The fetch parameters */
    method protected void DoFetchData(input poRequest as IFetchRequest):
        DataAccess:FetchData(poRequest).
    end method.

    /** Performs actions needed before the fetch is called. Allows easier
        overriding.
        
        @param IFetchRequest The fetch parameters */
    @method(virtual="true").
    method protected void AfterFetchData(input poRequest as IFetchRequest):
    end method.
    
    /** Response complement method for FetchData above.
        
        @param character The message id for the request/response
        @return IFetchResponse */
    method public IFetchResponse GetData(input pcMessageId as longchar):
        return DataAccess:GetData(pcMessageId).
    end method.
    
        /** Saves all (changed) data in the Entity.
        
        @return ISaveReponse A save request parameter object. */
    method public ISaveResponse SaveData():
        define variable oSaveRequest as ISaveRequest no-undo.
        
        return SaveData(BuildSaveRequest()).
    end method.
    
    /** Builds a save request for the Business Entity. Abstract since each implementation
        has its own type of datastore.
        
        @return ISaveRequest The complete save request for the BusinessEntity */    
    method abstract protected ISaveRequest BuildSaveRequest().
    /** Save data into the Data Access object. 
        
        This method is final, and the call is split into 3 separate parts:
        a Before-, a Do- and an AfterSaveData method. This
        is so that a concrete BE can override parts of the 
        behaviour easily.
        
        @param IFetchRequest The request parameters. */
    method final public ISaveResponse SaveData(input poRequest as ISaveRequest):
        define variable oSaveResponse as ISaveResponse no-undo.
        
        BeforeSaveData(poRequest).
        
        oSaveResponse = DoSaveData(poRequest).
        
        AfterSaveData(poRequest, oSaveResponse).
        
        return oSaveResponse.
    end method.
    /** Prepare the save rPerform the actual save via the DataAccess object.
        
        @param ISaveRequest The request parameters. */
    @method(virtual="true").
    method protected void BeforeSaveData(input poRequest as ISaveRequest):
    end method.
    
    /** Perform the actual save via the DataAccess object.
        
        @param ISaveRequest The request parameters.
        @return ISaveResponse The save response, including data */
    method protected ISaveResponse DoSaveData(input poRequest as ISaveRequest):
        return DataAccess:SaveData(poRequest).
    end method.
    
    /** Override for perforing actions after save is complete.
        
        @param ISaveRequest The save request
        @param ISaveResponse The save response */
    @method(virtual="true").
    method protected void AfterSaveData(input poRequest as ISaveRequest,
                                        input poResponse as ISaveResponse):
    end method.
    /** Defines the entity in terms of the schema that the underlying prodataset or
        temp-tables will have. This may be useful for example for binding UI before any data
        is requested.
        
        Abstract since each datastore will have it's own specialised way of determining the schema.
        
        @return IFetchResponse The response containing the schema */
    method abstract public IFetchResponse FetchSchema().
    /** Defines the entity in terms of the schema that the underlying prodataset or
        temp-tables will have. This is useful for example for binding UI before any data
        is requested.
        
        Abstract since each datastore will have it's own specialised way of determining the schema.
        
        @param IFetchRequest The request containing the individual tablerequests 
        @return IFetchResponse The response containing the schema */
    method abstract public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest).
    
end class.