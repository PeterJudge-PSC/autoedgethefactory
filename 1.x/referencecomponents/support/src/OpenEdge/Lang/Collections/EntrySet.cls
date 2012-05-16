/*------------------------------------------------------------------------
    File        : EntrySet
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : apr 2010
    Notes       : no empty constructor, specialized for KeySet of IMap 
                 - Changes to the map are reflected here, and vice-versa. 
                 - Supports removal and removes the corresponding map entry from the map
                   (Iterator.remove, Collection.remove, removeAll, retainAll and clear) .
                 - Do not support add and addAll.   
                 - no empty constructor, specialised for IMap 
  ----------------------------------------------------------------------*/

routine-level on error undo, throw.
using Progress.Lang.Object.
using Progress.Lang.AppError. 

using OpenEdge.Lang.Collections.KeySet. 
using OpenEdge.Lang.Collections.EntrySetIterator. 
using OpenEdge.Lang.Collections.IIterator. 
using OpenEdge.Lang.Collections.IMap. 
using OpenEdge.Lang.Collections.IMapEntry. 

class OpenEdge.Lang.Collections.EntrySet inherits KeySet: 
    define private variable mhTempTable     as handle no-undo. 
    define private variable mcField         as char  no-undo. 
      
    constructor public EntrySet (poMap as IMap,phTT as handle,pcKeyField as char):
        super (poMap,phTT,pcKeyField ).        
        mhTempTable = phTT.
        mcField = pcKeyField. 
    end constructor.
    
    method public override logical Contains(poObj as Object):     
        return super:Contains(CastEntry(poObj):Key).
    end method.
   
    method private IMapEntry CastEntry(poObj as Object).
         if not type-of(poObj,IMapEntry) then 
             undo, throw new AppError("Can only pass IMapEntry to method").
         return cast(poObj,IMapEntry).    
    end method.
        
    method public override logical Remove( poOld as Object ):
       return super:Remove(CastEntry(poOld):Key).
    end method.
     
     /* Returns a new IIterator over the entryset. */
    method public override IIterator Iterator( ):    
        return new EntrySetIterator(OwningMap, this-object,mhTempTable,mcField).
    end method.
    
end class.