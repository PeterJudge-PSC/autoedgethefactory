/** ------------------------------------------------------------------------
    File        : DatasetResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Fri Feb 12 00:25:55 EST 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
 
class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetFetchResponse inherits FetchResponse
        implements IDatasetFetchResponse: 

    define public property Handle as handle no-undo get. set.
    
    constructor public DatasetFetchResponse(input pcService as character):
        super(pcService).
    end constructor.
    
    constructor public DatasetFetchResponse(input pcMessageId as character,
                                            input pcService as character):
        super(pcMessageId, pcService).
    end constructor.
    
end class.