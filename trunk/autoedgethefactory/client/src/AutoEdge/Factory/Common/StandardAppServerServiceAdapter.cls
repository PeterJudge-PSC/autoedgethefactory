@todo(task="refactor", action="this class is pretty generic except for the AppServer name. Make that a property and move to CI?").
/** ------------------------------------------------------------------------
   File        : StandardAppServerServiceAdapter
   Purpose     : A standard (simple or generic) service adapter, used to 
                 make calls across an AppServer boundary. 
   Syntax      : 
   Description : 
   @author     : pjudge
   Created     : Tue Apr 27 08:43:10 EDT 2010
   Notes       : 
 ---------------------------------------------------------------------- */
{routinelevel.i}

using AutoEdge.Factory.Common.StandardAppServerServiceAdapter.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequestError.

using OpenEdge.CommonInfrastructure.ServiceAdapter.
using OpenEdge.CommonInfrastructure.IUserContext.
using OpenEdge.CommonInfrastructure.IService.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.CommonServiceMessageManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.IConnectionManager.
using OpenEdge.CommonInfrastructure.CommonConnectionManager.
using OpenEdge.CommonInfrastructure.ConnectionTypeEnum.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.

class AutoEdge.Factory.Common.StandardAppServerServiceAdapter inherits ServiceAdapter:
    define public property AppServerName as character no-undo get. set.
    
    define private variable mcCallbackProcedureName as character no-undo initial 'OpenEdge/CommonInfrastructure/service_managed_async_response.p'.
    
    
    constructor public StandardAppServerServiceAdapter(input pcService as character):
        super(pcService).
    end constructor.
    
    constructor public StandardAppServerServiceAdapter():
        super().
    end constructor.
    
    destructor public StandardAppServerServiceAdapter():
        define variable hProcedure  as handle no-undo.
        
        hProcedure = ABLSession:Instance:GetFirstRunningProc(mcCallbackProcedureName).
        delete object hProcedure no-error. 
    end destructor.
    
    /** Services a request. The service provider will call ExecuteResponse() in 
        the ServiceMessageManager once it's done with the request and ready with 
        a response (IServiceResponse); typically this will happen in a callback of
        some sort.
        
        @param IServiceRequest An array of requests to service. */
    method override public void ExecuteRequest(input poRequest as IServiceRequest extent):
        define variable oContext as IUserContext no-undo.
        
        Assert:ArgumentNotNull(poRequest, "Service request").
        
        oContext = cast(ServiceManager:GetService(CommonSecurityManager:SecurityManagerType), ISecurityManager):GetPendingContext().
        
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
    method override public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable oResponse as IServiceResponse extent no-undo.
        define variable oContext  as IUserContext no-undo.
        define variable oSecurityManager as ISecurityManager no-undo.
                
        Assert:ArgumentNotNull(poRequest, "Service request").
        
        oSecurityManager = cast(ServiceManager:GetService(CommonSecurityManager:SecurityManagerType), ISecurityManager).
        oContext = oSecurityManager:GetPendingContext().
        
        /* Requests are bundled by service message type, so we can only check this once. */
        case cast(poRequest[1], IServiceMessage):ActionType:
            when ServiceMessageActionEnum:FetchData then
                oResponse = cast(this-object:SyncFetch(cast(poRequest, IFetchRequest), input-output oContext), IServiceResponse).
            when ServiceMessageActionEnum:SaveData then
                oResponse = cast(this-object:SyncSave(cast(poRequest, ISaveRequest), input-output oContext), IServiceResponse).
        end case.
        
        /* Update the session context with the results of the request. */
        oSecurityManager:ValidateSession(oContext).
        
        return oResponse.
    end method.
    
    /** Data fetch request (async).
                
        @param IFetchRequest[] An array of fetch requests.
        @param IUserContext The context for this request.   */
    method protected void Fetch(input poRequest as IFetchRequest extent,
                                input poContext as IUserContext):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hResponseDataset as handle extent no-undo.
        define variable oOutput as IObjectOutput no-undo.
        
        set-byte-order(mTemp) = ByteOrderEnum:BigEndian:Value.
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax.              
        
        do iLoop = 1 to iMax:
            oOutput = new ObjectOutputStream().
            oOutput:WriteObject(poRequest[iLoop]).
            oOutput:Write(output mTemp).

            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
        end.
        
        set-byte-order(mUserContext) = ByteOrderEnum:BigEndian:Value.
        mUserContext = ServiceAdapter:SerializeContext(poContext).
        
        run OpenEdge/CommonInfrastructure/service_interface_fetchdata.p on GetServiceLocation() 
            asynchronous event-procedure 'EventProcedure_FetchData' in GetCallbackProcedure()                
                (input        mRequest,
                 output       hResponseDataset,
                 output       mResponse,
                 input-output mUserContext).
        /** Catch any errors returned from the AppServer call, in the return-value. */
        catch oError as AppError:
            undo, throw new ServiceRequestError(oError:ReturnValue, this-object:GetClass():TypeName + ':SyncFetch').
        end catch.
    end method.
    
    method protected IFetchResponse extent SyncFetch(input poRequest as IFetchRequest extent,
                                                     input-output poContext as IUserContext):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hResponseDataset as handle extent no-undo.
        define variable oOutput as IObjectOutput no-undo.
        define variable oInput as IObjectInput no-undo.
        define variable oResponse as IFetchResponse extent no-undo.
        
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax.
               
        do iLoop = 1 to iMax:
            oOutput = new ObjectOutputStream().
            oOutput:WriteObject(poRequest[iLoop]).
            oOutput:Write(output mTemp).
            
            set-byte-order(mRequest[iLoop]) = ByteOrderEnum:BigEndian:Value.
            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
        end.
        
        set-byte-order(mUserContext) = ByteOrderEnum:BigEndian:Value.
        mUserContext = ServiceAdapter:SerializeContext(poContext).
        
        /* Sync */
        run OpenEdge/CommonInfrastructure/service_interface_fetchdata.p on GetServiceLocation()
                        (input        mRequest,
                         output       hResponseDataset,
                         output       mResponse,
                         input-output mUserContext).

        assign iMax = extent(mResponse)
               extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax:
            oInput = new ObjectInputStream().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObject(), IFetchResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                hResponseDataset[iLoop],
                DataFormatEnum:ProDataSet).
        end.
        
        poContext = ServiceAdapter:DeserializeContext(mUserContext).
        
        return oResponse.
        
        /** Catch any errors returned from the AppServer call, in the return-value. */
        catch oError as AppError:
            undo, throw new ServiceRequestError(oError:ReturnValue, this-object:GetClass():TypeName + ':SyncFetch').
        end catch.
    end method.
    
    method protected void Save(input poRequest as ISaveRequest extent,
                               input poContext as IUserContext):
                                   
        define variable oResponse as ISaveResponse extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hRequestDataset as handle extent no-undo.
        define variable oOutput as IObjectOutput no-undo.
        define variable oInput as IObjectInput no-undo.
        define variable hDataset as handle no-undo.
        
        set-byte-order(mTemp) = ByteOrderEnum:BigEndian:Value.
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax
               extent(hRequestDataset) = iMax.
        
        do iLoop = 1 to iMax:
            cast(poRequest[iLoop], IServiceMessage):GetMessageData(output hDataset).
            hRequestDataset[iLoop] = hDataset.
            
            oOutput = new ObjectOutputStream().
            oOutput:WriteObject(poRequest[iLoop]).
            oOutput:Write(output mTemp).

            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
        end.
        
        set-byte-order(mUserContext) = ByteOrderEnum:BigEndian:Value.
        mUserContext = ServiceAdapter:SerializeContext(poContext).
        
        run OpenEdge/CommonInfrastructure/service_interface_savedata.p on GetServiceLocation() 
            asynchronous event-procedure 'EventProcedure_SaveData' in GetCallbackProcedure()
                    (input        mRequest,
                     input-output hRequestDataset,
                     output       mResponse,
                     input-output mUserContext).
        /** Catch any errors returned from the AppServer call, in the return-value. */
        catch oError as AppError:
            undo, throw new ServiceRequestError(oError:ReturnValue, this-object:GetClass():TypeName + ':SyncFetch').
        end catch.                     
    end method.
    
    method protected ISaveResponse extent SyncSave(input poRequest as ISaveRequest extent,
                                                   input-output poContext as IUserContext):
        define variable oResponse as ISaveResponse extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable mTemp as memptr no-undo.
        define variable mRequest as memptr extent no-undo.
        define variable mResponse as memptr extent no-undo.
        define variable mUserContext as memptr no-undo.
        define variable hRequestDataset as handle extent no-undo.
        define variable oOutput as IObjectOutput no-undo.
        define variable oInput as IObjectInput no-undo.
        define variable hDataset as handle no-undo.
        
        set-byte-order(mTemp) = ByteOrderEnum:BigEndian:Value.
        assign iMax = extent(poRequest)
               extent(mRequest) = iMax
               extent(hRequestDataset) = iMax.
        
        do iLoop = 1 to iMax:
            cast(poRequest[iLoop], IServiceMessage):GetMessageData(output hDataset).
            hRequestDataset[iLoop] = hDataset.
            
            oOutput = new ObjectOutputStream().
            oOutput:WriteObject(poRequest[iLoop]).
            oOutput:Write(output mTemp).
            
            mRequest[iLoop] = mTemp.
            /* no leaks! */
            set-size(mTemp) = 0.
        end.
        
        set-byte-order(mUserContext) = ByteOrderEnum:BigEndian:Value.
        mUserContext = ServiceAdapter:SerializeContext(poContext).
        
        run OpenEdge/CommonInfrastructure/service_interface_savedata.p on GetServiceLocation()
                (input        mRequest,
                 input-output hRequestDataset,
                 output       mResponse,
                 input-output mUserContext).
        
        assign iMax = extent(mResponse)
               extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax:
            oInput = new ObjectInputStream().
            oInput:Read(mResponse[iLoop]).
            oResponse[iLoop] = cast(oInput:ReadObject(), ISaveResponse).
            
            cast(oResponse[iLoop], IServiceMessage):SetMessageData(
                hRequestDataset[iLoop],
                DataFormatEnum:ProDataSet).
        end.
        
        poContext = ServiceAdapter:DeserializeContext(mUserContext).
        
        return oResponse.
        
        /** Catch any errors returned from the AppServer call, in the return-value. */
        catch oError as AppError:
            undo, throw new ServiceRequestError(oError:ReturnValue, this-object:GetClass():TypeName + ':SyncFetch').
        end catch.
    end method.
    
    /** Returns a procedure handle which will be used as the async event handler.
        
        @return handle A procedure handle. */
    method protected handle GetCallbackProcedure():
        define variable hProcedure as handle no-undo.
        
        hProcedure = ABLSession:Instance:GetFirstRunningProc(mcCallbackProcedureName).
        if not valid-handle(hProcedure) then
            run value(mcCallbackProcedureName) persistent set hProcedure.
        
        return hProcedure.            
    end method.
    
    /** Returns the ABL service or session handle on which to run the service interface.
        
        @return handle A server handle on which to run this service.    */
    method protected handle GetServiceLocation():
        define variable hServer as handle no-undo.
        
        hServer = ConnectionManager:GetConnectionHandle(ConnectionTypeEnum:AppServer, 'AutoEdgeTheFactory').
        
        return hServer.
    end method.
    
end class.