/*------------------------------------------------------------------------------
    File        : Collection
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Sun Dec 16 22:41:40 EST 2007
    Notes       : 
------------------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.*.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.AbstractTTCollection.

class OpenEdge.Lang.Collections.Collection inherits AbstractTTCollection: 
   /*---------------------------------------------------------------------------
    Purpose: General collection class                                                                
    Notes:   
    --------------------------------------------------------------------------*/
     
    /* default temp-table  */ 
    define private temp-table ttCollection
      field objectref as Object
      index objidx objectref.
      
    constructor public Collection():
        super (temp-table ttCollection:handle,"objectref").
    end constructor.
    
    constructor public Collection (c as ICollection):
        super (c,temp-table ttCollection:handle, "objectref").
    end constructor.

    method public override logical Contains( checkObject as Object):
        define variable lContains as logical no-undo.
        define buffer lbCollection for ttCollection.
        
        if not valid-object(checkObject) then
            return false.
        
        /* try by-reference first */
        lContains = can-find(lbCollection where lbCollection.ObjectRef = checkObject). 
        for each lbCollection while lContains = false:
            lContains = lbCollection.ObjectRef:Equals(checkObject).
        end.
        
        return lContains.
    end method.
    
   /*  
    a custom equals method for a collection class that implements neither the List nor Set interface must 
    return false when this collection is compared to any list or set. ... 
    */
/*    method public override logical Equals(o as Object):               */
/*        define buffer btCollection for ttCollection.                  */
/*        define variable oColl as ICollection no-undo.                 */
/*                                                                      */
/*        if super:Equals(o) then                                       */
/*            return true.                                              */
/*        if type-of(o,ICollection)                                     */
/*        and o:Equals(this-object) then                                */
/*        do:                                                           */
/*            oColl = cast(o,ICollection).                              */
/*            if oColl:Size = Size then                                 */
/*            do:                                                       */
/*                for each btCollection:                                */
/*                    if not oColl:Contains(btCollection.objectref) then*/
/*                        return false.                                 */
/*                end.                                                  */
/*                return true.                                          */
/*            end.                                                      */
/*        end.                                                          */
/*        return false.                                                 */
/*    end method.                                                       */
/*                                                                      */
    method protected override void FindBufferUseObject ( o as Object ):
        find first ttCollection where ttCollection.objectref = o no-error.
    end.
     
end class.