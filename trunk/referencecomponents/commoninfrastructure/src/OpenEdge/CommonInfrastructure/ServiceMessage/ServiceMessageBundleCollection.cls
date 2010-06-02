/*------------------------------------------------------------------------
    File        : ServiceMessageBundleCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 15:56:56 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundleCollection inherits TypedMap: 
    
    constructor public ServiceMessageBundleCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle')).
    end constructor.
    
    constructor public ServiceMessageBundleCollection(poMap as ServiceMessageBundleCollection):
        super(poMap).
    end constructor.
    
    method public ServiceMessageBundle Get(poKey as IServiceMessage):
        return cast(super:Get(poKey), ServiceMessageBundle).
    end method.
    
end class.