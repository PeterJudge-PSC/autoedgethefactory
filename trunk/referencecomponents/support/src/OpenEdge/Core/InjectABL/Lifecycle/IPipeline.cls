/*------------------------------------------------------------------------
    File        : IPipeline
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:09:14 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.Core.InjectABL.Lifecycle.IPipeline:  
    /** Gets the strategies that contribute to the activation and deactivation processes. **/
    define public property Strategies as ILifecycleStrategyCollection no-undo get.

    /** Activates the instance in the specified context. 
     <param name="context">The context.</param>
     <param name="reference">The instance reference.</param>
    **/
    method public void Activate(poContext as ILifecycleContext, poInstance as Object).

    /** Deactivates the instance in the specified context.
     <param name="context">The context.</param>
     <param name="reference">The instance reference.</param>
     **/
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object).
  
end interface.