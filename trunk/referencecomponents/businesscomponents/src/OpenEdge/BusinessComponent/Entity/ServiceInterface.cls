/** ------------------------------------------------------------------------
    File        : ServiceInterface
    Purpose     : Decorates a Business Entity with a Service Provider interface -
                  ie. exposes it as an external service.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Dec 07 08:01:43 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.BusinessComponent.Entity.BusinessEntityDecorator.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Service.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.IComponentInfo.

using OpenEdge.Core.System.ArgumentError.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.Entity.ServiceInterface inherits BusinessEntityDecorator
        implements IServiceProvider: 
    
    /** The service for which this provider is currently servicing a request. */
    define public property Service as character no-undo get. set.
    
    constructor public ServiceInterface(input poBusinessEntity as IBusinessEntity):
        super (input poBusinessEntity).
    end constructor.

    /** External method to dynamically set the service property via InjectABL */
    method public void SetService (input pcService as character):
        this-object:Service = pcService.
    end method.
    
    /** Services a request. The service or adapter will call ExecuteResponse() in the ServiceMessageManager
        once it's done with the request. The object that implements this interface will call back to
        the ServiceMessageManager when it is done and it's ready with a response (IServiceResponse).
        
        @param IServiceRequest[] The requests to service. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        iMax = extent(poRequest).
                
        do iLoop = 1 to iMax:
            case cast(poRequest[iLoop], IServiceMessage):ActionType:
                when ServiceMessageActionEnum:FetchData then
                do:
                    FetchData(cast(poRequest[iLoop], IFetchRequest)).
                    oResponse[iLoop] = cast(GetData(cast(poRequest[iLoop], IServiceMessage):MessageId), IServiceResponse).
                end.
                when ServiceMessageActionEnum:SaveData then
                    oResponse[iLoop] = cast(SaveData(cast(poRequest[iLoop], ISaveRequest))
                                        , IServiceResponse).
                when ServiceMessageActionEnum:FetchSchema then
                    oResponse[iLoop] = cast(FetchSchema(cast(poRequest[iLoop], IFetchRequest))
                                        , IServiceResponse).
            end case.
        end.
    end method.
    
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        iMax = extent(poRequest). 
        extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax:
            case cast(poRequest[iLoop], IServiceMessage):ActionType:
                when ServiceMessageActionEnum:FetchData then
                do:
                    FetchData(cast(poRequest[iLoop], IFetchRequest)).
                    oResponse[iLoop] = cast(GetData(cast(poRequest[iLoop], IServiceMessage):MessageId), IServiceResponse).
                end.
                when ServiceMessageActionEnum:SaveData then
                    oResponse[iLoop] = cast(SaveData(cast(poRequest[iLoop], ISaveRequest))
                                        , IServiceResponse).
                when ServiceMessageActionEnum:FetchSchema then
                    oResponse[iLoop] = cast(FetchSchema(cast(poRequest[iLoop], IFetchRequest))
                                        , IServiceResponse).
            end case.
        end.
        
        return oResponse.
    end method.

end class.