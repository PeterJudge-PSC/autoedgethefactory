/*------------------------------------------------------------------------
    File        : IComponentCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 15:01:31 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
/*routine-level on error undo, throw.*/

using OpenEdge.Lang.Collections.TypedList.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.IComponentCollection inherits TypedList:
    constructor public IComponentCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.IComponent')).
    end constructor.

    constructor public IComponentCollection(poType as class Class):
        super(Class:GetClass('OpenEdge.CommonInfrastructure.IComponent')).
    end constructor.
    
    constructor public IComponentCollection(poTypedCollection as TypedList):
        super(poTypedCollection).
        
        /* Can't do this before the super call, sorry. */
        Assert:ArgumentIsType(poTypedCollection, this-object:GetClass()).
    end constructor.
    
end class.
