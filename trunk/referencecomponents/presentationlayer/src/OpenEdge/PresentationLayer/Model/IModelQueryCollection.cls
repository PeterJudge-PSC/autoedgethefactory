/** -----------------------------------------------------------------------
    File        : IModelQueryCollection
    Purpose     : A (lookup) map of model query objects, keyd by name.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 15:56:56 EDT 2010
    Notes       : * Specialised class makes for more readable code on Get(),
                    Put(), Remove() etc.
  --------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.Model.IModelQueryCollection.
using OpenEdge.PresentationLayer.Model.IModelQuery.

using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.PresentationLayer.Model.IModelQueryCollection inherits TypedMap: 
    
    constructor public IModelQueryCollection():
        super(String:Type,
              Class:GetClass('OpenEdge.PresentationLayer.Model.IModelQuery')).
    end constructor.
    
    constructor public IModelQueryCollection(input poMap as IModelQueryCollection):
        super(poMap).
    end constructor.

    method public IModelQuery Get(input pcKey as character):
        return this-object:Get(new String(pcKey)).
    end method.
    
    method public IModelQuery Get(input poKey as String):
        return cast(super:Get(poKey), IModelQuery).
    end method.
    
    method public String Put(input poKey as String, input poValue as IModelQuery):        
        return cast(super:Put(poKey, poValue), String).
    end method.

    method public logical ContainsKey(input poKey as String):
        return super:ContainsKey(input poKey).
    end method.

    method public logical ContainsValue(input pcKey as character):
        return super:ContainsKey(new String(pcKey)).
    end method.
    
    method public logical ContainsValue(input poValue as IModelQuery):
        return super:ContainsValue(input poValue).
    end method.
    
    method public String Put(input pcKey as character, input poValue as IModelQuery):     
        return this-object:Put(new String(pcKey), poValue). 
    end method.
    
    method public String Remove(input poKey as String):
        return cast(super:Remove(input poKey), String).
    end method.
    
    method public String Remove(input pcKey as character):
        return this-object:Remove(new String(pcKey)).
    end method.
    
end class.