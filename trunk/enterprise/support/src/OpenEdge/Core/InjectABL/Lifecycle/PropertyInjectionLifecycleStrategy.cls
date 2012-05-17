/*------------------------------------------------------------------------
    File        : PropertyInjectionLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 09:02:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy inherits LifecycleStrategy: 
    constructor public PropertyInjectionLifecycleStrategy (  ):
        super ().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        poContext:GetProvider():InjectProperties(poInstance, poContext).
    end method.
    
end class.