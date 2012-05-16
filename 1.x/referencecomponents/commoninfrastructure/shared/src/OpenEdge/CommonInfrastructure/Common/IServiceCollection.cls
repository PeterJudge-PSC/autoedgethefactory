/*------------------------------------------------------------------------
    File        : IServiceCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 20 14:40:52 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IServiceCollection.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.Lang.Collections.TypedMap.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.IServiceCollection inherits TypedMap:
    constructor public IServiceCollection(poMap as IServiceCollection):
        super(poMap).
    end constructor.
    
    constructor public IServiceCollection():
        super(ComponentInfo:IComponentInfoType,
              Class:GetClass('OpenEdge.CommonInfrastructure.Common.IService')).
    end constructor.
    
end class.
