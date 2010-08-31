/** ------------------------------------------------------------------------
    File        : ITableContextCollection
    Purpose     : A collection
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:10:32 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection inherits TypedMap: 
    
    constructor public ITableContextCollection():
        super(Class:GetClass('OpenEdge.Lang.String'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext')).
    end constructor.
    
    constructor public ITableContextCollection(c as ITableContextCollection):
        super(c).
    end constructor.

	method public ITableContext Get(input pcKey as character):
		return cast(super:Get(input new String(pcKey)), ITableContext).
	end method.

end class.