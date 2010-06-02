
/*------------------------------------------------------------------------
    File        : IMapEntry
    Purpose     : A map entry (key-value pair). 
                  The IMap:EntrySet returns a set-view of the map, 
                  whose elements are of this class. 
                   
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Sun Apr 11 23:46:14 EDT 2010
    Notes       : The only way to obtain a reference to a map entry is 
                  from the iterator of the IEntrySet.
                  The IMapEntry objects are valid only for the duration 
                  of the iteration.                      
  ----------------------------------------------------------------------*/

using Progress.Lang.Object.

interface OpenEdge.Lang.Collections.IMapEntry:  
    define property Key   as Object no-undo get. set.
    define property Value as Object no-undo get. set.
    
end interface.