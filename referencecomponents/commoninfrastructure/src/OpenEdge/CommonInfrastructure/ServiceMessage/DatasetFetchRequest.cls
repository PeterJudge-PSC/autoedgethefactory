/*------------------------------------------------------------------------
    File        : DatasetFetchRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Thu Feb 11 23:52:27 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.Core.System.ServiceMessageActionEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetFetchRequest inherits FetchRequest 
        implements IDatasetFetchRequest: 
    
    define public property Handle as handle    no-undo get. set.
    
    constructor public DatasetFetchRequest(pcService as character):
        super(pcService).
    end constructor.
    
    constructor public DatasetFetchRequest(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService).
    end constructor.
    
end class.