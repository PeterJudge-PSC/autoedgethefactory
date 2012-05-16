/*------------------------------------------------------------------------
    File        : ICollection
    Purpose     : A collection represents a group of objects, known as its 
                  elements.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 20:04:13 EST 2007
    Notes       : All methods (and comments) except ToTable and AddArray 
                  are an exact match to Java Collection interface. 
                  Size is implemented as property                                                                     
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
 
interface OpenEdge.Lang.Collections.ICollection:
  define public property Size as integer no-undo get.
  
  method public logical Add(o as Object).
  method public logical AddAll(c as ICollection).
  method public logical AddArray(c as Object extent).  
  method public void Clear().
  method public logical Contains (o as Object).
  /*  method override public logical equals (o as Object). */
  method public IIterator Iterator().
  method public logical IsEmpty().
  method public logical Remove (o as Object). 
  /* Removes from this list all the elements that are contained in the 
      specified collection (optional operation). */
  method public logical RemoveAll (c as ICollection). 
  /* Retains only the elements in this list that are contained in the 
      specified collection (optional operation). return true if the object changed */
  method public logical RetainAll (c as ICollection). 
  method public void ToTable (output table-handle tt). 
  method public Object extent ToArray (). 
end interface.