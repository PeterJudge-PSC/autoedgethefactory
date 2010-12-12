/** ------------------------------------------------------------------------
    File        : BindingRoot
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:56:07 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingRoot.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.IBindingCollection.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.BindingRoot abstract implements IBindingRoot:
    define abstract public property Bindings as IBindingCollection no-undo get.
    
    method public IBindingSyntax Bind(input pcService as char):
        Assert:ArgumentIsValidType(pcService).
        
        return this-object:Bind(Class:GetClass(pcService)).
    end method.
    
    method public IBindingSyntax Bind(poService as class Class):
        define variable oBinding as IBinding no-undo.
        
        Assert:ArgumentNotNull(poService, 'Service').
        
        oBinding = new Binding(poService).
        AddBinding(oBinding).
        
        return CreateBindingBuilder(oBinding).
    end method.
    
    method public void Unbind(poService as class Class):
        define variable oIterator as IIterator.
        define variable oBinding as IBinding.
        
        oIterator = Bindings:Iterator().
        
        do while oIterator:HasNext():
            oBinding = cast(oIterator:Next(), IBinding).
            
            if oBinding:Service eq poService then
                RemoveBinding(oBinding).
        end.
    end method.
    
    method public void Unbind(pcService as char):
        Assert:ArgumentIsValidType(pcService).
        
        Unbind(Class:GetClass(pcService)).
    end method.
    
    method public IBindingSyntax Rebind(pcService as character):
        Assert:ArgumentIsValidType(pcService).
        
        return Rebind(Class:GetClass(pcService)).
    end method.
            
    method public IBindingSyntax Rebind(poService as class Class):
        Unbind(poService).
        return Bind(poService).
    end method.
    
    method abstract protected IBindingSyntax CreateBindingBuilder(poBinding as IBinding).
    method abstract public void AddBinding(poBinding as IBinding).
    method abstract public void RemoveBinding(poBinding as IBinding).
    
end class.