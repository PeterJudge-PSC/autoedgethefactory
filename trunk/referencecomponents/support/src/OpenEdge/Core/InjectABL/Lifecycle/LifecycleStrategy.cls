/*------------------------------------------------------------------------
    File        : LifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 05 07:58:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Lifecycle.LifecycleStrategy abstract implements ILifecycleStrategy: 
    
    constructor public LifecycleStrategy ():
    end constructor.
    
    @method(virtual="True").
    method public void Activate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
    @method(virtual="True").
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
end class.