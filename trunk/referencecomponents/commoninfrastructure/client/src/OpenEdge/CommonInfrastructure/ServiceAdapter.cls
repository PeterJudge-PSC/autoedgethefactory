/** ------------------------------------------------------------------------
   File        : ServiceAdapter
   Purpose     : A standard (simple or generic) service adapter, used to 
                 make calls across an AppServer boundary. 
   Syntax      : 
   Description : 
   @author     : pjudge
   Created     : Tue Apr 27 08:43:10 EDT 2010
   Notes       : 
 ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.

using OpenEdge.CommonInfrastructure.ServiceAdapter.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.CommonServiceManager.
using OpenEdge.CommonInfrastructure.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.CommonServiceMessageManager.
using OpenEdge.CommonInfrastructure.ISecurityManager.
using OpenEdge.CommonInfrastructure.CommonSecurityManager.
using OpenEdge.CommonInfrastructure.IConnectionManager.
using OpenEdge.CommonInfrastructure.CommonConnectionManager.
using OpenEdge.CommonInfrastructure.IUserContext.

using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.ObjectOutputStream.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceAdapter abstract
        implements IServiceProvider:
    
    /** The service for which this provider is currently servicing a request. */
    define public property Service as character no-undo get. set.
    
    /** (mandatory) The session's service manager. Used to determine the ServiceMessageManager and 
        other managers for callbacks, context and more. */
    define protected property ServiceManager as IServiceManager no-undo
        get():
            if not valid-object(ServiceManager) then
                ServiceManager = cast(ABLSession:Instance:SessionProperties:Get(CommonServiceManager:ServiceManagerType), IServiceManager).
            
            return ServiceManager.
        end get.
        private set.
    
    /** The ServicemessageManager is used plentifully; we keep it as a property so that
        we can get it whenever needed, without fuss. */
    define protected property ServiceMessageManager as IServiceMessageManager no-undo
        get():
            if not valid-object(ServiceMessageManager) then
                ServiceMessageManager = cast(ServiceManager:GetService(CommonServiceMessageManager:ServiceMessageManagerType) , IServiceMessageManager).
            
            return ServiceMessageManager.
        end get.
        private set.
    
    /** The ConnectionManager is used plentifully; we keep it as a property so that
        we can get it whenever needed, without fuss. */
    define protected property ConnectionManager as IConnectionManager no-undo
        get():
            if not valid-object(ConnectionManager) then
                ConnectionManager = cast(ServiceManager:GetService(CommonConnectionManager:IConnectionManagerType) , IConnectionManager).
            
            return ConnectionManager.
        end get.
        private set.
    
    constructor public ServiceAdapter(input pcService as character):
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        
        Service = pcService.
    end constructor.
    
    constructor public ServiceAdapter():
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
    method abstract public void ExecuteRequest(input poRequest as IServiceRequest extent).
    
    /** Services a request in a synchronous manner. The responses are returned from the
        ExecuteSyncRequest() call, rather than the service provider calling ExecuteResponse() in the
        ServiceMessageManager at a later time.
        
        @param IServiceRequest An array of requests to service.
        @return IServiceResponse An array of responses to the request.  */    
    method abstract public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent).

    /** Deserialises a MEMPTR into a UserContext object. This helper method is in this
        super class since this is a frequently-undertaken action.
        
        @param memptr The serialised user-context
        @return IUserContext The reconstituted object.  */
    method static public IUserContext DeserializeContext(input pmUserContext as memptr):
        define variable oContext as IUserContext no-undo.
        define variable oInput as ObjectInputStream no-undo.
        
        oInput = new ObjectInputStream().
        oInput:Read(pmUserContext).
        oContext = cast(oInput:ReadObject(), IUserContext).
        
        return oContext.
        finally:
            set-size(pmUserContext) = 0.
        end finally. 
    end method.

    /** Serialises a UserContext object to MEMPTR. This helper method is in this
        super class since this is a frequently-undertaken action.
        
        @return IUserContext The context being serialised.
        @param memptr The serialised user-context   */
    method static public memptr SerializeContext(input poUserContext as IUserContext):
        define variable mContext as memptr no-undo.
        define variable oOutput as ObjectOutputStream no-undo.
        
        oOutput = new ObjectOutputStream().
        oOutput:WriteObject(poUserContext).
        oOutput:Write(output mContext).
        
        return mContext.
        finally:
            set-size(mContext) = 0.
        end finally. 
    end method.
    
end class.