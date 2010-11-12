/** ------------------------------------------------------------------------
    File        : IServiceMessageCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 15:18:23 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.Lang.Collections.TypedMap.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection inherits TypedMap:
    
    constructor public IServiceMessageCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer')).
    end constructor.
    
    constructor public IServiceMessageCollection(input poCollection as IServiceMessageCollection):
        super(poCollection).
    end constructor.    
    
    method public IMessageConsumer Get(input poKey as IServiceMessage):
        return cast(super:Get(poKey), IMessageConsumer).
    end method.
    
    method public IServiceMessage Put(input poKey as IServiceMessage, input poValue as IMessageConsumer):        
        return cast(super:Put(poKey, poValue), IServiceMessage).
    end method.

    method public logical ContainsKey(input poKey as IServiceMessage):
        return super:ContainsKey(input poKey).
    end method.

    method public logical ContainsValue(input poValue as IMessageConsumer):
        return super:ContainsValue(input poValue).
    end method.
    
    method public IServiceMessage Remove(input poKey as IServiceMessage):
        return cast(super:Remove(input poKey), IServiceMessage).
    end method.

	method public void PutAll(input poMap as IServiceMessageCollection):
		super:PutAll(poMap).
	end method.
    
end class.