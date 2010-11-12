/*------------------------------------------------------------------------
    File        : TypedList
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Apr 08 13:19:02 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedList.
using OpenEdge.Lang.Collections.List.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Collections.TypedList inherits List: 
    define public property CollectionType as class Class no-undo get. private set. 
    
    constructor public TypedList (poType as class Class):
        super().
        CollectionType = poType.
    end constructor.
    
    constructor public TypedList (c as TypedList):
        super(input c).
        
        CollectionType = c:CollectionType.
    end constructor.

    method override public logical Add(poNewObject as Object):
        Assert:ArgumentIsType(poNewObject, CollectionType).
        return super:Add(poNewObject).
    end method.
    
end class.