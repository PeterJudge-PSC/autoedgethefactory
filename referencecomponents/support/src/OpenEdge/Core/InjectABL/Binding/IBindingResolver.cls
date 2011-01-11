/** ------------------------------------------------------------------------
    File        : IBindingResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 09 08:59:51 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.IMap.
using Progress.Lang.Class.

interface OpenEdge.Core.InjectABL.Binding.IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings
        
        @param IMap The complete set of bindings to resolve
        @param Class The service type
        @param character The binding name
        @return IList  The list of bindings corresponding to the service & name */
    method public IList Resolve(input poBindings as IMap,
                                input poService as class Class,
                                input pcName as character).
    
    /** Returns valid binding(s) for a scope from a set of bindings 
        
        @param IMap The complete set of bindings to resolve
        @param Class The type of scope (standard, manager etc)
        @param StandardScopeEnum The level of the scope (security manager, service manager etc)
        @return IList  The list of bindings corresponding to the scope and type */
    method public IList Resolve(input poBindings as IMap,
                                input poScopeCallback as class Class,
                                input poScope as StandardScopeEnum).
    
end interface.