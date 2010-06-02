/*------------------------------------------------------------------------
    File        : ComponentLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 05 08:00:21 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ComponentLifecycleStrategy inherits LifecycleStrategy: 
    
    constructor public ComponentLifecycleStrategy ():
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        Assert:ArgumentIsType(poInstance, Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponent')).
        
        dynamic-invoke(poInstance, 'CreateComponent').
    end method.
    
    method override public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
        Assert:ArgumentIsType(poInstance, Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponent')).
        
        dynamic-invoke(poInstance, 'DestroyComponent').
    end method.
    
end class.