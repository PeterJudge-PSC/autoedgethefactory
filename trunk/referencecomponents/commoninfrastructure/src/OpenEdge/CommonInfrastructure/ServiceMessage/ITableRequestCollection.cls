/*------------------------------------------------------------------------
    File        : ITableRequestCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:10:32 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection inherits TypedMap: 
        
    constructor public ITableRequestCollection():
        super(Class:GetClass('OpenEdge.Lang.String'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest')).
    end constructor.
    
    constructor public ITableRequestCollection(c as ITableRequestCollection):
        super(c).
    end constructor.

	method public ITableRequest Get( input pcKey as character ):
		return cast(super:Get(new String(pcKey)), ITableRequest).
	end method.
end class.