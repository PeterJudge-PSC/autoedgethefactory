/** -----------------------------------------------------------------------
    File        : IServiceRequestBundleCollection
    Purpose     : A (lookup) map of messages and bundles (IServiceRequestBundle),
                  allowing us to get from a ServiceRequest to its associated Bundle.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 15:56:56 EDT 2010
    Notes       : * Specialised class makes for more readable code on Get(),
                    Put(), Remove() etc.
                  * We use the ID of the request, since we need to be able 
                    to get the bundle on message response too, and this ID
                    is unique.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.

using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundleCollection inherits TypedMap: 
    
    constructor public IServiceRequestBundleCollection():
        super(Class:GetClass('OpenEdge.Lang.String'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle')).
    end constructor.
    
    constructor public IServiceRequestBundleCollection(input poMap as IServiceRequestBundleCollection):
        super(poMap).
    end constructor.

    method public IServiceRequestBundle Get(input pcKey as character):
        return this-object:Get(new String(pcKey)).
    end method.
    
    method public IServiceRequestBundle Get(input poKey as String):
        return cast(super:Get(poKey), IServiceRequestBundle).
    end method.
    
    method public String Put(input poKey as String, input poValue as IServiceRequestBundle):        
        return cast(super:Put(poKey, poValue), String).
    end method.

    method public String Put(input pcKey as character, input poValue as IServiceRequestBundle):     
        return this-object:Put(new String(pcKey), poValue). 
    end method.
    
    method public String Remove(input poKey as String):
        return cast(super:Remove(input poKey), String).
    end method.
    
    method public String Remove(input pcKey as character):
        return this-object:Remove(new String(pcKey)).
    end method.
    
end class.