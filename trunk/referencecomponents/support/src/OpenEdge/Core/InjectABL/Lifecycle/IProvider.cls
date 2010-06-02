/*------------------------------------------------------------------------
    File        : IProvider
    Purpose     : 
    Syntax      : 
    Description : Creates instances of services.
    Author(s)   : pjudge
    Created     : Tue Mar 02 13:27:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using Progress.Lang.Object.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Lifecycle.IProvider:  
    /** Gets the type (or prototype) of instances the provider creates. **/
    define public property Type as class Class no-undo get.

    /** Creates an instance within the specified context.
    
        <param name="context">The context.</param>
        <returns>The created instance.</returns> **/
    method public Object Create(poContext as ILifecycleContext).
    
    method public void InjectMethods(poInstance as Object, poContext as ILifecycleContext).    
    method public void InjectProperties(poInstance as Object, poContext as ILifecycleContext).
    
end interface.