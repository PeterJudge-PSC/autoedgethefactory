/*------------------------------------------------------------------------
    File        : ILifecycleStrategyCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategyCollection.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.Lang.Collections.TypedCollection.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategyCollection inherits TypedCollection: 
        
    constructor public ILifecycleStrategyCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy')).
    end constructor.
    
end class.