/*------------------------------------------------------------------------
    File        : IBindingRoot
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:26:29 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.Class.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.

interface OpenEdge.Core.InjectABL.Binding.IBindingRoot:
    define public property Bindings as IBindingCollection no-undo get.
      
    /** <summary>
     Declares a binding from the service to itself.
     </summary>
     <param name="service">The service to bind.</param>
    **/
    method public IBindingSyntax Bind(poService as class Class).
    method public IBindingSyntax Bind(pcService as char).
    
    /** <summary>
     Unregisters all bindings for the specified service.
     </summary>
     <param name="service">The service to unbind.</param>
    **/
    method public void Unbind(poService as class Class).
    method public void Unbind(pcService as char).
    
    /** <summary>
     Removes any existing bindings for the specified service, and declares a new one.
     </summary>
     <param name="service">The service to re-bind.</param>
    **/
    method public IBindingSyntax Rebind(poService as class Class).
    method public IBindingSyntax Rebind(pcService as char).
    
    /** <summary>
     Registers the specified binding.
     </summary>
     <param name="binding">The binding to add.</param>
    **/
    method public void AddBinding(poBinding as IBinding).
    
    /** <summary>
     Unregisters the specified binding.
     </summary>
     <param name="binding">The binding to remove.</param>
    **/
    method public void RemoveBinding(poBinding as IBinding).
    
end interface.