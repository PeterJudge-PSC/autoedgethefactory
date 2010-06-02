/*------------------------------------------------------------------------
    File        : ILifecycleContext
    Purpose     : 
    Syntax      : 
    Description : Contains information about the activation of a single instance.
    Author(s)   : pjudge
    Created     : Tue Mar 02 11:45:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.IKernel.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext:  
    /** Gets the request. 
    define public property Request as IActivationRequest no-undo get.
    **/
    
    /** Gets the kernel that is driving the activation. **/
    define public property Kernel as IKernel no-undo get.
    
    /** Gets the binding. **/
    define public property Binding as IBinding no-undo get.
    
    /** Gets the parameters that were passed to manipulate the activation process. **/
    define public property Parameters as IParameterCollection no-undo get.
    
    /** Gets or sets the pipeline component. **/
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the provider that should be used to create the instance for this context.
        <returns>The provider that should be used.</returns> **/
    method public IProvider GetProvider().
    
    /** Gets the scope for the context that "owns" the instance activated therein.
        <returns>The object that acts as the scope.</returns> **/
    method public Object GetScope().
    
    /** Resolves this instance for this context.
        <returns>The resolved instance.</returns> **/
    method public Object Resolve().
    
end interface.