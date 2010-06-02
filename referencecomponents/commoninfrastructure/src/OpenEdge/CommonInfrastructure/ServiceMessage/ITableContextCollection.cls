/*------------------------------------------------------------------------
    File        : ITableContextCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 14:10:32 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection.
using OpenEdge.Lang.Collections.TypedList.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection inherits TypedList: 
        
    constructor public ITableContextCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext')).
    end constructor.
        
    constructor public ITableContextCollection(c as ITableContextCollection):
        super(c).
    end constructor.
    
end class.