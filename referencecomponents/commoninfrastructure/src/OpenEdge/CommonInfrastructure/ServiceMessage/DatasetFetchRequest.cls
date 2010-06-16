/** ------------------------------------------------------------------------
    File        : DatasetFetchRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Thu Feb 11 23:52:27 EST 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.

class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetFetchRequest inherits FetchRequest 
        implements IDatasetFetchRequest: 
    
    define public property Handle as handle    no-undo get. set.
    
    constructor public DatasetFetchRequest(input pcService as character):
        super(pcService).
    end constructor.
    
    constructor public DatasetFetchRequest(input pcMessageId as character,
                                           input pcService as character):
        super(pcMessageId, pcService).
    end constructor.
    
end class.