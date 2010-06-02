/*------------------------------------------------------------------------
    File        : ServiceMessageManager
    Purpose     : Manager aand broker of ServiceMessages and their Bundles (request/responses)
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 12:26:37 EDT 2010
    Notes       : * ServiceMessageBroker 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.

using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.System.ServiceMessageActionEnum.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.ServiceMessageManager inherits Service
        implements IServiceMessageManager:
    
    /** A (lookup) map of messages and bundles, allowing us to get from a ServiceMessage to a Bundle if need be.  */
    define protected property ServiceMessageBundles as ServiceMessageBundleCollection no-undo get. private set.
    
    constructor public ServiceMessageManager(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    method public ServiceMessageBundle CreateMessageBundle(poMessageRequestor as IMessageRequestor,
                                                           poActionType as ServiceMessageActionEnum):
        return new ServiceMessageBundle(ServiceManager, poMessageRequestor, poActionType).
    end method.
    
    method public void AddRequest(poMessageBundle as ServiceMessageBundle,
                                  poMessage as IServiceMessage,
                                  poMessageConsumer as IMessageConsumer):
        poMessageBundle:AddMessage(poMessage, poMessageConsumer).
        ServiceMessageBundles:Put(poMessage, poMessageBundle).
    end method.
    
    method public void RemoveRequest(poMessage as IServiceMessage):
        define variable oBundle as ServiceMessageBundle no-undo.
        
        oBundle = ServiceMessageBundles:Get(poMessage).
        oBundle:RemoveMessage(poMessage).
        
        /* Once the last message is removed from, the bundle will not longer be in the Map,
           since the map is IServiceMessage -> ServiceMessageBundle */
        ServiceMessageBundles:Remove(poMessage).
    end method.
    
    method public void ExecuteRequest(poMessageRequestor as IMessageRequestor,
                                      poMessage as IServiceMessage,
                                      poMessageConsumer as IMessageConsumer):
        define variable oBundle as ServiceMessageBundle no-undo.
        
        oBundle = CreateMessageBundle(poMessageRequestor, poMessage:ActionType).
        oBundle:AddMessage(poMessage, poMessageConsumer).
        oBundle:ExecuteRequest().
    end method.
    
    method public void ExecuteResponse(poMessage as IServiceMessage):
        ServiceMessageBundles:Get(poMessage):ExecuteResponse(poMessage).
        ServiceMessageBundles:Remove(poMessage).
    end method.
    
    method public void ExecuteResponse(poMessage as IServiceMessage extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poMessage).
        do iLoop = 1 to iMax:
            ExecuteResponse(poMessage[iLoop]).
        end.
    end method.
    
    method override public void DestroyComponent():
        super:DestroyComponent().
        
        ServiceMessageBundles:Clear().
    end method.

    method override public void CreateComponent():
        super:CreateComponent().
        
        ServiceMessageBundles = new ServiceMessageBundleCollection().
    end method.
    
end class.