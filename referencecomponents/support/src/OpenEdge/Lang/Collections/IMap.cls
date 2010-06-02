
/*------------------------------------------------------------------------
    File        : IMap
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Apr 11 01:17:48 EDT 2010
    Notes       : All methods (and comments) except ToTable matches 
                  Java Map interface.
                  Collection views are properties 
                  Size is property
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.ISet.


interface OpenEdge.Lang.Collections.IMap:  
 
    /* Returns the number of key-value mappings in this map.*/
    define public property Size as integer no-undo get.
    
    /* Returns a collection view of the values contained in this map.
       reflects changes to the map and vice-versa. 
       Supports removal and removes the corresponding map entry from the map
       (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .*/
    define public property Values as ICollection no-undo get.
    
    /* Returns a set view of the keys contained in this map.*/
    define public property KeySet as ISet no-undo get.
    
    /* Returns a set view of the mappings contained in this map.*/
    define public property EntrySet as ISet no-undo get.
     
    /* Removes all mappings from this map (optional operation). */
    method public void Clear().
    
    /* Returns true if this map contains a mapping for the specified key. */
    method public logical ContainsKey(poKey as Object).
    
    /* Returns true if this map maps one or more keys to the specified value.*/
    method public logical ContainsValue(poValue as Object).
   
    /* Returns the value to which this map maps the specified key.*/
    method public Object Get(poKey as Object).
    
    /* Returns the hash code value for this map.*/
    /*    int    hashCode()*/
    /* Returns true if this map contains no key-value mappings.*/
    method public logical IsEmpty().
     
    /* Associates the specified value with the specified key in this map (optional operation).*/
    method public Object Put(poKey as Object,poValue as Object).
    
    /* Copies all of the mappings from the specified map to this map (optional operation).*/
    method public void PutAll(poMap as IMap).
    
    /* Removes the mapping for this key from this map if it is present (optional operation).*/
    method public Object Remove(poKey as Object).
    
end interface.