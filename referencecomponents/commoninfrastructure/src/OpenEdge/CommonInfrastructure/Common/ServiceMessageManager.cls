/** ------------------------------------------------------------------------
    File        : ServiceMessageManager
    Purpose     : Manager aand broker of ServiceMessages and their Bundles (request/responses)
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 12:26:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------  */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.ServiceMessageManager abstract inherits Service
        implements IServiceMessageManager, IMessageRequestor, IMessageConsumer:
    
    define private variable moSyncResponse as IServiceResponse extent no-undo.
    define private variable miSyncResponseExtent as integer no-undo.
    
    /** A (lookup) map of messages and bundles, allowing us to get from a ServiceMessage to a Bundle if need be.  */
    define protected property ServiceRequestBundles as IServiceRequestBundleCollection no-undo get. private set.
    define protected property MessageConsumers as IMap no-undo get. private set.
    
    constructor public ServiceMessageManager(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
        
        MessageConsumers = new TypedMap(Class:GetClass('OpenEdge.Lang.String'), /* will store the IServiceMessage:MessageID */
                                        Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer')).
    end constructor.

    /** Factory method that creates a message bundle for a given component.
        
        @param poRequestor The object making the request.
        @param  poMessageType OpenEdge.Core.System.MessageTypeEnum (Fetch, Save or Define)  
        @return Returns an IServiceRequestBundle instance, into which we can add ServiceRequests,
                and execute requests.   */
    method public IServiceRequestBundle CreateMessageBundle(input poMessageRequestor as IMessageRequestor,
                                                            input poActionType as ServiceMessageActionEnum):
        define variable oBundle as IServiceRequestBundle no-undo.
        define variable oParams as IParameterCollection no-undo.
        
        oParams = new IParameterCollection().
        oParams:Add(new ConstructorArgument(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'))).
        oParams:Add(new ConstructorArgument(poMessageRequestor)).
        oParams:Add(new ConstructorArgument(poActionType)).
        
        oBundle = cast(ServiceManager:Kernel:Get(
                            Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle'),
                            oParams), IServiceRequestBundle).
        return oBundle.
    end method.
    
    /** Add a request to the specified Request list
        @param poMessageBundle The message bundle in which to add the request 
        @param poRequest This is going to be a request specialised by the
                         request type: IFetchRequest, ISaveRequest, IDefineRequest
        @param poMessageConsumer The component that will consumer the message response.    */    
    method public void AddRequest(input poMessageBundle as IServiceRequestBundle,
                                  input poRequest as IServiceRequest,
                                  input poMessageConsumer as IMessageConsumer):
        define variable cMessageId as character no-undo.
        
        cMessageId = cast(poRequest, IServiceMessage):MessageId.
                                             
        poMessageBundle:AddRequest(poRequest).
        
        MessageConsumers:Put(poRequest, poMessageConsumer).
        ServiceRequestBundles:Put(string(cast(poRequest, IServiceMessage):MessageId), poMessageBundle).
    end method.
    
    /** Remove a request from its message bundle
       
        @param poRequest The request to remove from its bundle */    
    method public void RemoveRequest(input poRequest as IServiceRequest):
        define variable oMessageId as String no-undo.
        
        oMessageId = new String(cast(poRequest, IServiceMessage):MessageId).
        
        ServiceRequestBundles:Get(oMessageId):RemoveRequest(poRequest).
        
        /* We don't want anybody listening any more */
        MessageConsumers:Remove(oMessageId).
        
        /* Once the last message is removed from, the bundle will not longer be in the Map,
           since the map is IServiceMessage:MessageId -> IServiceRequestBundle */
        ServiceRequestBundles:Remove(oMessageId).
    end method.
    
    /** Execute the request for the component. This method creates a bundle
        and executes the request in one call. It's a wrapper around 
        CreateMessageBundle, AddRequest and ExecuteBundle.
         
        @param poRequestor The object making the request. 
        @param poRequest The Service request being made
        @param poMessageConsumer The component that will consumer the message response. */    
    method public void ExecuteRequest(input poMessageRequestor as IMessageRequestor,
                                      input poRequest as IServiceRequest,
                                      input poMessageConsumer as IMessageConsumer):
        define variable oBundle as IServiceRequestBundle no-undo.
        
        oBundle = CreateMessageBundle(poMessageRequestor, cast(poRequest, IServiceMessage):ActionType).
        AddRequest(oBundle, poRequest, poMessageConsumer).
        oBundle:ExecuteBundle().
    end method.
    
    /** Executes responses for the message(s) requested earlier.
        
        @param poResponse A single request responses. */
    method public void ExecuteResponse(poResponse as IServiceResponse):
        define variable oMessageId as String no-undo.
        
        oMessageId = new String(cast(poResponse, IServiceMessage):MessageId).
        
        /* Pass the response on to the consumer */
        cast(MessageConsumers:Get(oMessageId), IMessageConsumer):ActionCompleted(poResponse).
        
        /* Tell the bundle we're done with this request. */
        ServiceRequestBundles:Get(oMessageId):ResponseReceived(string(oMessageId:Value)).
        
        /* Done with the request; no-one wants to listen any more. */
        MessageConsumers:Remove(oMessageId).
    end method.
    
    /** Executes responses for the message(s) requested earlier.
        
        @param poResponse An array of request responses. */        
    method public void ExecuteResponse(poResponse as IServiceResponse extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poResponse).
        do iLoop = 1 to iMax:
            ExecuteResponse(poResponse[iLoop]).
        end.
    end method.
    
    /** A synchronous/linear/connected/combined request and response call.
        
        @param poRequest An array of service requests. 
        @return Returns an array of responses for the provided requests
      */
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable oBundle as IServiceRequestBundle no-undo.
        
        iMax = extent(poRequest).
        
        oBundle = CreateMessageBundle(this-object, cast(poRequest[1], IServiceMessage):ActionType).
        do iLoop = 1 to iMax:
            AddRequest(oBundle, poRequest[iLoop], this-object).
        end.
        oBundle:ExecuteBundle().
        
        return moSyncResponse.
        
        finally:
            /* let go of responses to prevent leakage. */
            assign moSyncResponse = ?
                   extent(moSyncResponse) = ?
                   miSyncResponseExtent = 0.
        end finally.
    end method.
    
    method override public void DestroyComponent():
        super:DestroyComponent().
        
        ServiceRequestBundles:Clear().
    end method.

    method override public void CreateComponent():
        super:CreateComponent().
        
        ServiceRequestBundles = new IServiceRequestBundleCollection().
    end method.
    
    /* IMessageConsumer */
	method public void ActionCompleted(input poResponse as IServiceResponse):
		assign miSyncResponseExtent = miSyncResponseExtent + 1. 
		       moSyncResponse[miSyncResponseExtent] = poResponse
		       .
	end method.
	
    /** Notification that all requests within a bundle are about to be executed. 
        
        @param poBundle The request bundle whose requests are being acted upon. */    
    method public void RequestStarted(input poBundle as IServiceRequestBundle):
        /* Init variables. */
        assign miSyncResponseExtent = 0 
               extent(moSyncResponse) = ?
               extent(moSyncResponse) = poBundle:TotalRequests
               .
    end method.
    
    /** Notification that all requests within a bundle are complete. 
        
        @param poBundle The request bundle whose request are now complete   */    
    method public void RequestCompleted(input poBundle as IServiceRequestBundle):
        /* no-op */
	end method.
	
end class.
