/** ------------------------------------------------------------------------
   File        : StandardServiceAdapter
   Purpose     : A standard (simple or generic) service adapter, used to 
                 make calls across an AppServer boundary. 
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
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter
        implements IServiceProvider:
    
    /** (mandatory) The service for which this service adapter is servicing a request. */   
    define public property Service as character no-undo get. private set.
    
    /** (mandatory) The session's service manager. Used to determine the ServiceMessageManager and 
        other managers for callbacks, context and more. */
    define protected property ServiceManager as IServiceManager no-undo get. private set.
    
    /** The ServicemessageManager is used plentifully; we keep it as a property so that
        we can get it whenever needed, without fuss. */
    define protected property ServiceMessageManager as IServiceMessageManager no-undo
        get():
            if not valid-object(ServiceMessageManager) then
                ServiceMessageManager = 
                    cast(ServiceManager:GetService(
                            Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager'))
                          , IServiceMessageManager).
            
            return ServiceMessageManager.
        end get.
        private set.
                
    define private variable mcCallbackProcedureName as character no-undo.
    
    constructor public StandardServiceAdapter(input pcService as character,
                                              input poServiceManager as IServiceManager):
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        Assert:ArgumentNotNull(poServiceManager, 'Service Manager').
        
        assign Service = pcService
               ServiceManager = poServiceManager
               
               mcCallbackProcedureName = 'OpenEdge/CommonInfrastructure/ServiceMessage/simple_async_response.p'.
    end constructor.
    
    destructor public StandardServiceAdapter():
        /*        
        delete object CallbackProcedure no-error.
        ServiceLocation:disconnect().
        delete server ServiceLocation no-error
        */
    end destructor.
    
    /** Services a request. The service provider will call ExecuteResponse() in 
        the ServiceMessageManager once it's done with the request and ready with 
        a response (IServiceResponse); typically this will happen in a callback of
        some sort.
        
        @param IServiceRequest An array of requests to service. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent):
        define variable oContext as IUserContext no-undo.
        
        Assert:ArgumentNotNull(poRequest, "Service request").
        
        oContext = cast(ServiceManager:GetService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
            , ISecurityManager):GetPendingContext().
        
        /* Requests are bundled by service message type, so we can only check this once. */
        case cast(poRequest[1], IServiceMessage):ActionType:
            when ServiceMessageActionEnum:FetchData then this-object:Fetch(cast(poRequest, IFetchRequest), oContext).
            when ServiceMessageActionEnum:SaveData then this-object:Save(cast(poRequest, ISaveRequest), oContext).
        end case.
    end method.
    
    /** Services a request in a synchronous manner. The responses are returned from the
        ExecuteSyncRequest() call, rather than the service provider calling ExecuteResponse() in the
        ServiceMessageManager at a later time.
        
        @param IServiceRequest An array of requests to service.
        @return IServiceResponse An array of responses to the request.  */    
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable oContext  as IUserContext     no-undo.
        
        Assert:ArgumentNotNull(poRequest, "Service request").
        
        oContext = cast(ServiceManager:GetService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager'))
            , ISecurityManager):GetPendingContext().
        
        /* Requests are bundled by service message type, so we can only check this once. */
        case cast(poRequest[1], IServiceMessage):ActionType:
            when ServiceMessageActionEnum:FetchData then
                oResponse = cast(this-object:SyncFetch(cast(poRequest, IFetchRequest), oContext), IServiceResponse).
            when ServiceMessageActionEnum:SaveData then
                oResponse = cast(this-object:SyncSave(cast(poRequest, ISaveRequest), oContext), IServiceResponse).
        end case.
        
        return oResponse.
    end method.    
    
    @todo(task="implement", action="REFACTOR so that Sync* and * share serialisation code? ").
    method protected void Fetch(input poRequest as IFetchRequest extent,
                                input poContext as IUserContext):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hResponseDataset as handle extent no-undo.
        define variable oOutput as ObjectOutputStream no-undo.
        
        assign 
            iMax             = extent(poRequest)
            extent(mRequest) = iMax.
        
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
            on GetServiceLocation() asynchronous 
            event-procedure 'EventProcedure_FetchData' in GetCallbackProcedure()                
                    (input        mRequest,
                     output       hResponseDataset,
                     output       mResponse,
                     input-output mUserContext).
    end method.
    
    method protected IFetchResponse extent SyncFetch(input poRequest as IFetchRequest extent,
        input poContext as IUserContext):
        define variable iLoop            as integer            no-undo.
        define variable iMax             as integer            no-undo.
        define variable mTemp            as memptr             no-undo.
        define variable mRequest         as memptr             extent no-undo.
        define variable mResponse        as memptr             extent no-undo.
        define variable mUserContext     as memptr             no-undo.
        define variable hResponseDataset as handle             extent no-undo.
        define variable oOutput          as ObjectOutputStream no-undo.
        define variable oInput           as ObjectInputStream  no-undo.
        define variable oResponse        as IFetchResponse     extent no-undo.
        
        assign 
            iMax             = extent(poRequest)
            extent(mRequest) = iMax.
        /*extent(mResponse) = iMax*/
        
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
        
        /* Sync */
        run OpenEdge/CommonInfrastructure/ServiceMessage/simple_fetchdata.p 
            on GetServiceLocation() 
            (input       mRequest,
            output       hResponseDataset,
            output       mResponse,
            input-output mUserContext).
        
        assign 
            iMax              = extent(mResponse)
            extent(oResponse) = iMax.
        
        oInput = new ObjectInputStream().
        do iLoop = 1 to iMax:
            oInput:Reset().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObjectArray(), IFetchResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                hResponseDataset[iLoop],
                DataFormatEnum:ProDataSet).
        end.
        
        /* Set context in to ContextManager from the data received from the server call. */
        oInput:Reset().
        oInput:Read(mUserContext).
        poContext = cast(oInput:ReadObjectArray(), IUserContext).
        @todo(task="implement", action="").
        
        return oResponse.
    end method.
    
    method protected void Save(input poRequest as ISaveRequest extent,
        input poContext as IUserContext):
        define variable oResponse       as ISaveResponse      extent no-undo.
        define variable iLoop           as integer            no-undo.
        define variable iMax            as integer            no-undo.
        define variable mTemp           as memptr             no-undo.
        define variable mRequest        as memptr             extent no-undo.
        define variable mResponse       as memptr             extent no-undo.
        define variable mUserContext    as memptr             no-undo.
        define variable hRequestDataset as handle             extent no-undo.
        define variable oOutput         as ObjectOutputStream no-undo.
        define variable oInput          as ObjectInputStream  no-undo.
        define variable hDataset        as handle             no-undo.
        
        assign 
            iMax                    = extent(poRequest)
            extent(mRequest)        = iMax
            extent(hRequestDataset) = iMax.
        
        oOutput = new ObjectOutputStream().
        do iLoop = 1 to iMax:
            cast(poRequest[iLoop], IServiceMessage):GetMessageData(output hDataset).
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
            on GetServiceLocation() asynchronous event-procedure 'EventProcedure_SaveData' in GetCallbackProcedure()
            (input        mRequest,
            input-output hRequestDataset,
            output       mResponse,
            input-output mUserContext).
    end method.

    method protected ISaveResponse extent SyncSave(input poRequest as ISaveRequest extent,
        input poContext as IUserContext):
        define variable oResponse       as ISaveResponse      extent no-undo.
        define variable iLoop           as integer            no-undo.
        define variable iMax            as integer            no-undo.
        define variable mTemp           as memptr             no-undo.
        define variable mRequest        as memptr             extent no-undo.
        define variable mResponse       as memptr             extent no-undo.
        define variable mUserContext    as memptr             no-undo.
        define variable hRequestDataset as handle             extent no-undo.
        define variable oOutput         as ObjectOutputStream no-undo.
        define variable oInput          as ObjectInputStream  no-undo.
        define variable hDataset        as handle             no-undo.
        
        assign 
            iMax                    = extent(poRequest)
            extent(mRequest)        = iMax
            extent(hRequestDataset) = iMax.
        
        oOutput = new ObjectOutputStream().
        do iLoop = 1 to iMax:
            cast(poRequest[iLoop], IServiceMessage):GetMessageData(output hDataset).
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
        
        run OpenEdge/CommonInfrastructure/ServiceMessage/simple_savedata.p on GetServiceLocation()
                        (input        mRequest,
                         input-output hRequestDataset,
                         output       mResponse,
                         input-output mUserContext).
        
        assign 
            iMax              = extent(mResponse)
            extent(oResponse) = iMax.
        
        oInput = new ObjectInputStream().
        do iLoop = 1 to iMax:
            oInput:Reset().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObjectArray(), ISaveResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                hRequestDataset[iLoop],
                DataFormatEnum:ProDataSet).
        end.
        
        /* Set context in to ContextManager from the data received from the server call. */
        oInput:Reset().
        oInput:Read(mUserContext).
        poContext = cast(oInput:ReadObjectArray(), IUserContext).
        @todo(task="implement", action="").
                       
        return oResponse.                                    
    end method.

    /** Returns a procedure handle which will be used as the async event handler.
        
        @return handle A procedure handle. */
    method protected handle GetCallbackProcedure():
        define variable hProcedure as handle no-undo.
        
        hProcedure = ABLSession:Instance:GetFirstRunningProc(mcCallbackProcedureName).
        if not valid-handle(hProcedure) then
            run value(mcCallbackProcedureName) persistent set hProcedure (input ServiceManager).
        
        return hProcedure.            
    end method.
    
    /** Returns the ABL service or session handle on which to run the service interface.
        
        @return handle A server handle on which to run this service.    */
    method protected handle GetServiceLocation():
        return session:handle.
    end method.
    
end class.