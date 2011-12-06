/** ------------------------------------------------------------------------
    File        : ILifecycleContext
    Purpose     : 
    Syntax      : 
    Description : Contains information about the activation of a single instance.
    @author pjudge
    Created     : Tue Mar 02 11:45:31 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.IKernel.

using OpenEdge.Lang.Collections.ICollection.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext:  
    /** Gets the request. 
    define public property Request as IActivationRequest no-undo get.
    */
    
    /** Gets the kernel that is driving the activation. */
    define public property Kernel as IKernel no-undo get.
    
    /** Gets the binding. */
    define public property Binding as IBinding no-undo get.
    
    /** Gets the arguments for the constructor/methods/etc that were passed to manipulate the activation process. */
    define public property Arguments as ICollection no-undo get.
    
    /** Gets or sets the pipeline component. */
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the provider that should be used to create the instance for this context.
        
        @return IProvider The provider that should be used. */
    method public IProvider GetProvider().
    
    /** Gets the scope for the context that "owns" the instance activated therein.
        @return Object The object that acts as the scope. */
    method public Object GetScope().
    
    /** Resolves this instance for this context.
        The resolved instance. */
    method public Object Resolve().
    
end interface.