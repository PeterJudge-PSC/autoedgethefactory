 
 /*------------------------------------------------------------------------
    File        : IIterator
    Purpose     : traverses a collection forward 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     :  
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface OpenEdge.Lang.Collections.IIterator:  
  method public logical HasNext().
  method public Object Next().
  method public logical Remove(). 
end interface.

 