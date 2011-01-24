/*------------------------------------------------------------------------
    File        : IServiceCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 20 14:40:52 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.IServiceCollection.
using OpenEdge.CommonInfrastructure.ComponentInfo.
using OpenEdge.Lang.Collections.TypedMap.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.IServiceCollection inherits TypedMap:
    constructor public IServiceCollection(poMap as IServiceCollection):
        super(poMap).
    end constructor.
    
    constructor public IServiceCollection():
        super(ComponentInfo:ComponentInfoType,
              Class:GetClass('OpenEdge.CommonInfrastructure.IService')).
    end constructor.
    
end class.
