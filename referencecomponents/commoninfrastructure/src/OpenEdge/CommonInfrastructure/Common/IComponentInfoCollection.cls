@deprecated(version="0.0"). 
/*------------------------------------------------------------------------
    File        : IComponentInfoCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Apr 08 11:06:09 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Collections.TypedList.
using OpenEdge.Lang.Collections.IListIterator.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.IComponentInfoCollection inherits TypedList:
    
    constructor public IComponentInfoCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponentInfo')).
    end constructor.
    
    constructor public IComponentInfoCollection(poTypedCollection as TypedList):
        super(poTypedCollection).
        
        /* Can't do this before the super call, sorry. */
        Assert:ArgumentIsType(poTypedCollection, this-object:GetClass()).
    end constructor.
    
    method override public logical Contains( input checkObject as Progress.Lang.Object ):
        define variable lContains as logical no-undo.
        
        lContains = super:Contains(input checkObject).
        if not lContains then
            lContains = IndexOf(checkObject) gt 0.
                    
        return lContains.
    end method.
    
    method override public integer IndexOf(poObject as Object):
        define variable iIndex as integer no-undo.
        define variable oIterator as IListIterator no-undo.
        
        iIndex = super:IndexOf(poObject).
        if iIndex eq 0 and this-object:Contains(poObject) then
        do:
            oIterator = ListIterator().
            do while oIterator:HasNext() and iIndex eq 0:
                iIndex = oIterator:NextIndex().
                if oIterator:Next():Equals(poObject) then
                    leave.
                else
                    iIndex = 0.
            end.
        end.
        
        return iIndex.
    end method.
    
    method override public integer LastIndexOf( input obj as Progress.Lang.Object ):
        
        return super:LastIndexOf(input obj).

    end method.
    
end class.