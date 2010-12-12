/** ------------------------------------------------------------------------
    File        : ComponentLifecycleStrategy
    Purpose     : Lifecycle management strategy for IComponent objects
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:00:21 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponent.

using OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ComponentLifecycleStrategy inherits LifecycleStrategy: 
    
    constructor public ComponentLifecycleStrategy ():
        super().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        define variable lInvokeCreate as logical no-undo.
        define variable lInvokeInit as logical no-undo.
        
        super:Activate(poContext, poInstance).
        
        /* IServiceManager is a special type of component. */
        lInvokeCreate = type-of(poInstance, IServiceManager) or
                        type-of(poInstance, IComponent).
        
        lInvokeInit = type-of(poInstance, IComponent).
        
        if lInvokeCreate then
            dynamic-invoke(poInstance, 'CreateComponent').

        if lInvokeInit then 
            dynamic-invoke(poInstance, 'Initialize').
    end method.
    
    method override public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
        define variable lInvokeDestroy as logical no-undo.
        
        super:Deactivate(poContext, poInstance).
        
        /* IServiceManager is a special type of component. */
        lInvokeDestroy = type-of(poInstance, IServiceManager) or
                         type-of(poInstance, IComponent).
        
        if lInvokeDestroy then
            dynamic-invoke(poInstance, 'DestroyComponent').
    end method.
    
end class.