/*------------------------------------------------------------------------
    File        : IBindingResolver
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 09 08:59:51 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings */
    method public IBindingCollection Resolve(poBindings as IBindingCollection,
                                             poService as class Class).
    
    /** Returns valid binding(s) for a scope from a set of bindings */
    method public IBindingCollection Resolve(poBindings as IBindingCollection,
                                             poScopeCallback as class Class,
                                             poScope as EnumMember).
    
end interface.