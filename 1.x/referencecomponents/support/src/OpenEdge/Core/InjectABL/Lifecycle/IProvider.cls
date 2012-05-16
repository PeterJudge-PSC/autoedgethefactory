/*------------------------------------------------------------------------
    File        : IProvider
    Purpose     : 
    Syntax      : 
    Description : Creates instances of services.
    @author pjudge
    Created     : Tue Mar 02 13:27:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Object.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Lifecycle.IProvider:  
    /** Gets the type (or prototype) of instances the provider creates. */
    define public property Type as class Class no-undo get.

    /** Creates an instance within the specified context.
    
        @param ILifecycleContext The context used to create the object.
        @return Object The created instance. */
    method public Object Create(poContext as ILifecycleContext).
    
    /** Dependency injection into a method.
    
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectMethods(poInstance as Object, poContext as ILifecycleContext).    
    
    /** Dependency injection into a property.
        
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectProperties(poInstance as Object, poContext as ILifecycleContext).
    
end interface.