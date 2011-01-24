/*------------------------------------------------------------------------
    File        : TypedList
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Apr 08 13:19:02 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

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

    constructor protected TypedList (input poCol as ICollection, input phtt as handle, input pcField as character ):
        super (input poCol, input phtt, input pcField).
    end constructor.
        
    constructor protected TypedList (poType as class Class, input phtt as handle, input pcField as character ):
        super (input phtt, input pcField).
        CollectionType = poType.
    end constructor.
        
    constructor protected TypedList (poType as class Class, input phtt as handle, input hField as handle ):
        super (input phtt, input hField).
        CollectionType = poType.
    end constructor.

    method override public logical Add(poNewObject as Object):
        Assert:ArgumentIsType(poNewObject, CollectionType).
        return super:Add(poNewObject).
    end method.
    
end class.