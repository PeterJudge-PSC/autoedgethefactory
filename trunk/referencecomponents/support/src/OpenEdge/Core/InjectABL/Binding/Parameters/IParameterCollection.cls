/*------------------------------------------------------------------------
    File        : IParameterCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Core.InjectABL.Binding.Parameters.PropertyValue.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Iterator.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection inherits TypedCollection:
    
    constructor public IParameterCollection():
        super(Class:GetClass('OpenEdge.Core.InjectABL.Binding.Parameters.IParameter')).
    end constructor.
    
    constructor public IParameterCollection (poTypedCollection as TypedCollection):
        super(poTypedCollection).
        
        /* Can't do this before the super call, sorry. */
        Assert:ArgumentIsType(poTypedCollection, this-object:GetClass()).
    end constructor.
    
end class.