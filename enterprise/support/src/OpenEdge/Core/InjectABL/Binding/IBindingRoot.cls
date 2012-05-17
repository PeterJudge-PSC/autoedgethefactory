/** ------------------------------------------------------------------------
    File        : IBindingRoot
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:26:29 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Lang.Collections.IMap.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.IBindingRoot:
    /** A collection of bindings, keyed by the service they bind to. */
    define public property Bindings as IMap no-undo get.
    
    /** Declares a binding from the service to itself.        
        @param Class The service to bind. */
    method public IBindingSyntax Bind(input poService as class Class).
        
    /** Declares a binding from the service to itself.        
        @param character The service to bind. */
    method public IBindingSyntax Bind(input pcService as character).
    
    /** Unregisters all bindings for the specified service.
        
        @param Class The service to unbind. */
    method public void Unbind(input poService as class Class).

    /** Unregisters all bindings for the specified service.
        
        @param character The service to unbind. */
    method public void Unbind(input pcService as character).
    
    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param Class The service to re-bind. **/
    method public IBindingSyntax Rebind(input poService as class Class).

    /** Removes any existing bindings for the specified service, and declares a new one.
        
        @param character The service to re-bind. **/
    method public IBindingSyntax Rebind(input pcService as character).
    
    /** Registers the specified binding.
        
        @param IBinding The binding to add. */
    method public void AddBinding(input poBinding as IBinding).
    
    /** Unregisters the specified binding.
        @param IBinding The binding to remove. */
    method public void RemoveBinding(input poBinding as IBinding).
    
end interface.