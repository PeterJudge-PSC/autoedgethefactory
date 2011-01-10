/*------------------------------------------------------------------------
    File        : SecurityManagerServiceAdapter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 04 14:23:46 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
/*routine-level on error undo, throw.*/

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.IUserContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerResponse.

using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Lang.Assert.
using Progress.Lang.Error.

class OpenEdge.CommonInfrastructure.SecurityManagerServiceAdapter
        implements IServiceProvider:
    
    /** The service for which this provider is currently servicing a request. */
    define public property Service as character no-undo get. set.

    constructor public SecurityManagerServiceAdapter():
        super().
    end constructor.
	
    /** External method to dynamically set the service property via InjectABL */
    method public void SetService (input pcService as character):
        this-object:Service = pcService.
    end method.
    
    /** Services a request. The service provider will call ExecuteResponse() in 
        the ServiceMessageManager once it's done with the request and ready with 
        a response (IServiceResponse); typically this will happen in a callback of
        some sort.
        
        @param IServiceRequest An array of requests to service. */
    method public void ExecuteRequest(input poRequest as IServiceRequest extent):
        return error new InvalidCallError('asynchronous', 'OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider:ExecuteRequest').
    end method.
    
    /** Services a request in a synchronous manner. The responses are returned from the
        ExecuteSyncRequest() call, rather than the service provider calling ExecuteResponse() in the
        ServiceMessageManager at a later time.
        
        @param IServiceRequest An array of requests to service.
        @return IServiceResponse An array of responses to the request.  */    
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable oResponse as IServiceResponse extent no-undo.
        
        Assert:ArgumentNotNull(poRequest, "Service request").
        
        /* Requests are bundled by service message type, so we can only check this once. */
        case cast(poRequest[1], IServiceMessage):ActionType:
            when ServiceMessageActionEnum:UserLogin then oResponse = UserLogin(cast(poRequest, SecurityManagerRequest)).
            when ServiceMessageActionEnum:UserLogout then oResponse = UserLogout(cast(poRequest, SecurityManagerRequest)).
            when ServiceMessageActionEnum:ValidateSession then oResponse = ValidateSession(cast(poRequest, SecurityManagerRequest)).
            otherwise 
                undo, throw new UnsupportedOperationError(
                                        cast(poRequest[1], IServiceMessage):ActionType:ToString(),
                                        this-object:GetClass():TypeName). 
        end case.
        
        return oResponse.
    end method.
    
    method protected SecurityManagerResponse extent UserLogin(input poRequest as SecurityManagerRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cContextId as longchar no-undo.
        define variable oResponse as SecurityManagerResponse extent no-undo. 
        define variable mUserContext as memptr no-undo.
        
        assign iMax = extent(poRequest)
               extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax on error undo, next:
            oResponse[iLoop] = new SecurityManagerResponse(poRequest[iLoop]).
            
            run OpenEdge/CommonInfrastructure/Server/service_userlogin.p
                on GetServiceLocation()
                    ( input poRequest[iLoop]:UserName,
                      input poRequest[iLoop]:UserDomain,
                      input poRequest[iLoop]:UserPassword,
                      output mUserContext).
            oResponse[iLoop]:UserContext = DeserializeContext(mUserContext).                       

            catch oError as Error:
                cast(oResponse[iLoop], IServiceResponse):HasError = true.
                cast(oResponse[iLoop], IServiceResponse):ErrorText = oError:GetMessage(1).
            end catch.
        end.
        
        return oResponse.
    end method.
    
    method private IUserContext DeserializeContext(input pmUserContext as memptr):
        define variable oContext as IUserContext no-undo.
        define variable oInput as ObjectInputStream no-undo.
        
        oInput = new ObjectInputStream().
        oInput:Read(pmUserContext).
        oContext = cast(oInput:ReadObject(), IUserContext).
        
        return oContext. 
    end method.

    method private memptr SerializeContext(input poUserContext as IUserContext):
        define variable mContext as memptr no-undo.
        define variable oOutput as ObjectOutputStream no-undo.
        
        oOutput = new ObjectOutputStream().
        oOutput:WriteObject(poUserContext).
        oOutput:Write(output mContext).
        
        return mContext.
    end method.
    
    method protected SecurityManagerResponse extent UserLogout(input poRequest as SecurityManagerRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cContextId as longchar no-undo.
        define variable oResponse as SecurityManagerResponse extent no-undo. 
        define variable mUserContext as memptr no-undo.
        
        assign iMax = extent(poRequest)
               extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax on error undo, next:
            oResponse[iLoop] = new SecurityManagerResponse(poRequest[iLoop]).
            run OpenEdge/CommonInfrastructure/Server/service_userlogout.p 
                on GetServiceLocation()
                    (input poRequest[iLoop]:ContextId).                                            
            
            catch oError as Error:
                cast(oResponse[iLoop], IServiceResponse):HasError = true.
                cast(oResponse[iLoop], IServiceResponse):ErrorText = oError:GetMessage(1).
            end catch.
        end.
        
        return oResponse.
    end method.
    
    method protected SecurityManagerResponse extent ValidateSession(input poRequest as SecurityManagerRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cContextId as longchar no-undo.
        define variable oResponse as SecurityManagerResponse extent no-undo. 
        define variable mUserContext as memptr no-undo.
        
        assign iMax = extent(poRequest)
               extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax on error undo, next:
            oResponse[iLoop] = new SecurityManagerResponse(poRequest[iLoop]).
            run OpenEdge/CommonInfrastructure/Server/service_validatesession.p
                on GetServiceLocation()
                    (input poRequest[iLoop]:ContextId).
            
            catch oError as Error:
                cast(oResponse[iLoop], IServiceResponse):HasError = true.
                cast(oResponse[iLoop], IServiceResponse):ErrorText = oError:GetMessage(1).
            end catch.
        end.
        
        return oResponse.
    end method.
    
    /** Returns the ABL service or session handle on which to run the service interface.
        
        @return handle A server handle on which to run this service.    */
    method protected handle GetServiceLocation():
        return session:handle.
    end method.
    
end class.