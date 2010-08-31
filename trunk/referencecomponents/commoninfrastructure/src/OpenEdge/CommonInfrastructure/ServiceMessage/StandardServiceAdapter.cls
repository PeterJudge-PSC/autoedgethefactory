/** ------------------------------------------------------------------------
    File        : StandardServiceAdapter
    Purpose     : A standard (simple or generic) service adapter. 
    Syntax      : 
    Description : 
    @author     : pjudge
    Created     : Tue Apr 27 08:43:10 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.MessageDataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter
        implements IServiceProvider:
    
    /** (mandatory) The service for which this service adapter is servicing a request. */   
    define public property Service as character no-undo get. private set.
    
    constructor public StandardServiceAdapter(input pcService as character):
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        
        Service = pcService.
    end constructor.
    
    /** Resolve service into an executable handle.
        @param pcService The name of the service being resolved. 
     */
    method public handle ResolveRemoteService(input pcService as character):
        define variable hService as handle no-undo.
        
        hService = session:handle.
        
        return hService.
    end method.
    
    /** Services a request. The service or adapter will call ExecuteResponse() in the ServiceMessageManager
        once it's done with the request. The object that implements this interface will call back to
        the ServiceMessageManager when it is done and it's ready with a response (IServiceResponse).
        
        @param poRequest The request to service.
        @param poServiceMessageManager The message manager controlling this request. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent,
                                      input poServiceMessageManager as IServiceMessageManager):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable oContext as IUserContext no-undo.
        
        Assert:ArgumentNotNull(poRequest[1], "Service request").
        Assert:ArgumentNotNull(poServiceMessageManager, "Service message manager").
        
        @todo(task="implement", action="get context from somewhere; probably Security Manager").
        
        /* Requests are bundled by service message type, so we can only check this once. */
        case cast(poRequest[1], IServiceMessage):ActionType:
            when ServiceMessageActionEnum:Fetch then
                oResponse = cast(this-object:Fetch(cast(poRequest, IFetchRequest), oContext), IServiceResponse).
            when ServiceMessageActionEnum:Save then
                oResponse = cast(this-object:Save(cast(poRequest, ISaveRequest), oContext), IServiceResponse).
        end case.
        
        poServiceMessageManager:ExecuteResponse(oResponse).
    end method.
    
    method protected IFetchResponse extent Fetch(input poRequest as IFetchRequest extent,
                                                 input poContext as IUserContext):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hResponseDataset as handle extent no-undo.
        define variable oOutput as ObjectOutputStream no-undo.
        define variable oInput as ObjectInputStream no-undo.
        define variable oResponse as IFetchResponse extent no-undo.
        
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax
               extent(mResponse) = iMax.
        
        oOutput = new ObjectOutputStream().
        do iLoop = 1 to iMax:
            oOutput:WriteObjectArray(poRequest[iLoop]).
            oOutput:Write(output mTemp).
            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
            oOutput:Reset().
        end.
        
        oOutput:Reset().
        oOutput:WriteObjectArray(poContext).
        oOutput:Write(output mUserContext).
        
        run OpenEdge/CommonInfrastructure/ServiceMessage/simple_fetchdata.p 
                on ResolveRemoteService(Service)
                           (input        mRequest,
                            output       hResponseDataset,
                            output       mResponse,
                            input-output mUserContext).
        
        assign iMax = extent(mResponse)
               extent(oResponse) = iMax.
        
        oInput = new ObjectInputStream().
        do iLoop = 1 to iMax:
            oInput:Reset().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObjectArray(), IFetchResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetData(
                    hResponseDataset[iLoop],
                    MessageDataFormatEnum:ProDataSet).
        end.
        
        oInput:Reset().
        oInput:Read(mUserContext).
        poContext = cast(oInput:ReadObjectArray(), IUserContext).
        
        return oResponse.
    end method.
    
    method protected ISaveResponse extent Save(input poRequest as ISaveRequest extent,
                                               input poContext as IUserContext):
        define variable oResponse as ISaveResponse  extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hRequestDataset as handle extent no-undo.
        define variable oOutput as ObjectOutputStream no-undo.
        define variable oInput as ObjectInputStream no-undo.
        define variable hDataset as handle no-undo.
        
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax
               extent(mResponse) = iMax
               extent(hRequestDataset) = iMax.
        
        oOutput = new ObjectOutputStream().
        do iLoop = 1 to iMax:
            cast(poRequest[iLoop], IServiceMessage):GetData(output hDataset).
            hRequestDataset[iLoop] = hDataset.
            
            oOutput:WriteObjectArray(poRequest[iLoop]).
            oOutput:Write(output mTemp).
            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
            oOutput:Reset().
        end.
        
        oOutput:Reset().
        oOutput:WriteObjectArray(poContext).
        oOutput:Write(output mUserContext).
        
        run OpenEdge/CommonInfrastructure/ServiceMessage/simple_savedata.p 
                on ResolveRemoteService(Service)
                    (input        mRequest,
                     input-output hRequestDataset,
                     output       mResponse,
                     input-output mUserContext).
        
        assign iMax = extent(mResponse)
               extent(oResponse) = iMax.
        
        oInput = new ObjectInputStream().
        do iLoop = 1 to iMax:
            oInput:Reset().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObjectArray(), ISaveResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetData(
                    hRequestDataset[iLoop],
                    MessageDataFormatEnum:ProDataSet).
        end.
        
        oInput:Reset().
        oInput:Read(mUserContext).
        poContext = cast(oInput:ReadObjectArray(), IUserContext).
        
        return oResponse.
    end method.
    
end class.