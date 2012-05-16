/** ------------------------------------------------------------------------
    File        : ITableResponseCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 20:50:42 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponseCollection.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponse.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponseCollection inherits TypedMap: 
    
    constructor public ITableResponseCollection():
        super(String:Type,
              Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponse')).
    end constructor.
    
    constructor public ITableResponseCollection(c as ITableResponseCollection):
        super(c).
    end constructor.
    
    method public ITableResponse Get(input pcKey as character):
        return cast(this-object:Get(new String(pcKey)), ITableResponse).
    end method.
    
    method public ITableResponse Get(input poKey as String):
        return cast(super:Get(poKey), ITableResponse).
    end method.
    
    method public ITableResponse Put(input poKey as String, input poValue as ITableResponse):
        return cast(super:Put(poKey, poValue), ITableResponse).
    end method.

    method public ITableResponse Put(input pcKey as character, input poValue as ITableResponse):     
        return cast(this-object:Put(new String(pcKey), poValue), ITableResponse). 
    end method.
    
    method public ITableResponse Remove(input poKey as String):
        return cast(cast(super:Remove(input poKey), String), ITableResponse).
    end method.
    
    method public ITableResponse Remove(input pcKey as character):
        return cast(this-object:Remove(new String(pcKey)), ITableResponse).
    end method.

end class.