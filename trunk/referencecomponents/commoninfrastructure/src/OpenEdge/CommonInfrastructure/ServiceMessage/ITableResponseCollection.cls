/** ------------------------------------------------------------------------
    File        : ITableResponseCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 20:50:42 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponseCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponseCollection inherits TypedMap: 
    
    constructor public ITableResponseCollection():
        super(Class:GetClass('OpenEdge.Lang.String'),
              Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse')).
    end constructor.
    
    constructor public ITableResponseCollection(c as ITableResponseCollection):
        super(c).
    end constructor.

    method public ITableResponse Get(input pcKey as character):
        return cast(super:Get(input new String(pcKey)), ITableResponse).
    end method.

	method public ITableResponse Put(input pcKey as character, input poValue as ITableResponse):
		return cast(super:Put(input new String(pcKey), input poValue), ITableResponse).
	end method.

end class.