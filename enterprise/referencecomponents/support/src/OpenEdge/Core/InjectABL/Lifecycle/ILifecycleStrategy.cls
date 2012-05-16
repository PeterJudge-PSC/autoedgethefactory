/*------------------------------------------------------------------------
    File        : ILifecycleStrategy
    Purpose     : Is called during the activation and deactivation of an instance.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 07:55:45 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy:  
    /** Contributes to the activation of the instance in the specified context.
        @param poContext The lifecycle context
        @param poInstance The instance being activated
     */
    method public void Activate(poContext as ILifecycleContext, poInstance as Object).
    
    /** Contributes to the deactivation of the instance in the specified context.
        @param poContext The lifecycle context
        @param poInstance The instance being deactivated
      */
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object).
    
end interface.