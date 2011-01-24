/*------------------------------------------------------------------------
    File        : MethodInjectionLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 09:02:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.MethodInjectionLifecycleStrategy inherits LifecycleStrategy: 
    constructor public MethodInjectionLifecycleStrategy (  ):
        super ().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        poContext:GetProvider():InjectMethods(poInstance, poContext).
    end method.
    
end class.