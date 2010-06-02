 
 /*------------------------------------------------------------------------
    File        : EntrySetIterator
    Purpose     : Iterator for entrysets
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Mon Apr 12 00:18:04 EDT 2010
    Notes       : The IMappedEntry Key Value are created in next().      
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Iterator.
using OpenEdge.Lang.Collections.MapEntry.
 
routine-level on error undo, throw.

class OpenEdge.Lang.Collections.EntrySetIterator inherits Iterator: 
    define protected property OwningMap as IMap no-undo get. set. 
    constructor public EntrySetIterator (poMap as IMap, poCol as ICollection, tt as handle,ofield as char):
        super(poCol,tt,ofield).  
        OwningMap = poMap.          
    end constructor.    
    
    method public override Object Next():
        define variable oKey as Object no-undo.
        oKey = super:Next().
        return new MapEntry(OwningMap,oKey). 
    end method.    
     
end class.