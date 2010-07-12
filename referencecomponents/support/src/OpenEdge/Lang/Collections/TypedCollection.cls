/*------------------------------------------------------------------------
    File        : TypedCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 10 10:43:01 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.TypedCollection inherits Collection:
    define public property CollectionType as class Class no-undo get. private set. 
    
    constructor public TypedCollection (poType as class Class):
        super().
        CollectionType = poType.
    end constructor.
    
    constructor public TypedCollection(c as TypedCollection):
        super(input c).
        
        CollectionType = c:CollectionType.
    end constructor.
    
    method override public logical Add(newObject as Object):
        Assert:ArgumentIsType(newObject, CollectionType).
        return super:Add(newObject).
    end method.
    
    method override public logical Remove(oldObject as Object):
        Assert:ArgumentIsType(oldObject, CollectionType).
        return super:Remove(oldObject).
    end method.
    
    method override public logical Contains(checkObject as Object):
        Assert:ArgumentIsType(checkObject, CollectionType).
        return super:Contains(checkObject).
    end method.

end class.