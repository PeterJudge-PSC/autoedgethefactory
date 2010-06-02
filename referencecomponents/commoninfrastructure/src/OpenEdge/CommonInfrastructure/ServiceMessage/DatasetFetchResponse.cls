/*------------------------------------------------------------------------
    File        : DatasetResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Fri Feb 12 00:25:55 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.Lang.EnumMember.
 
class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetFetchResponse inherits FetchResponse
        implements IDatasetFetchResponse: 

    define public property Handle as handle no-undo get. set.
    
    constructor public DatasetFetchResponse(pcService as character):
        super(pcService).
    end constructor.
    
    constructor public DatasetFetchResponse(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService).
    end constructor.
    
end class.