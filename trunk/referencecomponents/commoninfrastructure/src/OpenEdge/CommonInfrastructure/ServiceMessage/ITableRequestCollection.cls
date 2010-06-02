/*------------------------------------------------------------------------
    File        : ITableRequestCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 14:10:32 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.Lang.Collections.TypedList.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection inherits TypedList: 
        
    constructor public ITableRequestCollection():
        super(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest')).
    end constructor.
        
    constructor public ITableRequestCollection(c as ITableRequestCollection):
        super(c).
    end constructor.

end class.