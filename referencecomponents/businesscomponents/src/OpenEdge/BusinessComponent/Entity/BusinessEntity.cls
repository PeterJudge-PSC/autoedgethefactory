/** ------------------------------------------------------------------------
    File        : BusinessEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Fri Aug 14 23:38:08 EDT 2009
    Notes       : * This class is abstract class since the Business Entity's 
                    data store could be a prodataset, temp-table or some other 
                    construct.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class OpenEdge.BusinessComponent.Entity.BusinessEntity abstract inherits Service 
        implements IBusinessEntity, IServiceProvider:
    
    define public property DataAccess as IDataAccess no-undo 
        get.
        private set.
    method public void SetDataAccess (input poDataAccess as IDataAccess):
        DataAccess = poDataAccess.
    end method.
    
    /** (mandatory) The service for which this service adapter is servicing a request. */
    define public property Service as character no-undo get. private set.
    
    /** Services a request. The service or adapter will call ExecuteResponse() in the ServiceMessageManager
        once it's done with the request. The object that implements this interface will call back to
        the ServiceMessageManager when it is done and it's ready with a response (IServiceResponse).
        
        @param poRequest The request to service.
        @param poServiceMessageManager The message manager controlling this request. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent,
                                      input poServiceMessageManager as IServiceMessageManager):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        iMax = extent(poRequest). 
        
        @todo(task="question", action="get an array in here, but can this only handle a single request?").
        do iLoop = 1 to iMax:
            case cast(poRequest[iLoop], IServiceMessage):ActionType:
                when ServiceMessageActionEnum:Fetch then
                do:
                    FetchData(cast(poRequest[iLoop], IFetchRequest)).
                    oResponse[iLoop] = cast(GetData(), IServiceResponse).
                end.
                when ServiceMessageActionEnum:Save then
                    oResponse[iLoop] = cast(SaveData(cast(poRequest[iLoop], ISaveRequest))
                                        , IServiceResponse).
                when ServiceMessageActionEnum:FetchSchema then
                    oResponse[iLoop] = cast(FetchSchema(cast(poRequest[iLoop], IFetchRequest))
                                        , IServiceResponse).
            end case.
        end.
        
        poServiceMessageManager:ExecuteResponse(oResponse).
    end method.
    
    constructor public BusinessEntity(input poDAO as IDataAccess,
                                      input poServiceManager as IServiceManager,
                                      input poComponentInfo as IComponentInfo):
        this-object(input poServiceManager, input poComponentInfo).
        DataAccess = poDAO. 
    end constructor.
    
    constructor public BusinessEntity(input poServiceManager as IServiceManager,
                                      input poComponentInfo as IComponentInfo):
        super(input poServiceManager, input poComponentInfo).
    end constructor.
    
    /* Tis method's final so that we can ensure we have the before, do, after sequence */
    method final public void FetchData(poRequest as IFetchRequest):
        BeforeFetchData(poRequest).
        DoFetchData(poRequest).
        AfterFetchData(poRequest).
    end method.
    
    /* Abstract since we don't know the data store (temp-table, prodataset, etc). */
    @method(virtual="true").
    method protected void BeforeFetchData(poRequest as IFetchRequest):
    end method.
    
    method protected void DoFetchData(poRequest as IFetchRequest):
        DataAccess:FetchData(poRequest).
    end method.
    
    @method(virtual="true").
    method protected void AfterFetchData(poRequest as IFetchRequest):
    end method.
    
    method public IFetchResponse GetData():
        return DataAccess:GetData().
    end method.
    
    method public ISaveResponse SaveData(poChanges as ISaveRequest):
        return DataAccess:SaveData(poChanges).
    end method.
    
    /* Abstract since we don't know the data store (temp-table, prodataset, etc). */
    method abstract public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest).
    
end class.