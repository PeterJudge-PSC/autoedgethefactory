 
 /*------------------------------------------------------------------------
    File        : DatasetSaveRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:06:46 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.DatasetSaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetSaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.

class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetSaveRequest inherits SaveRequest
        implements IDatasetSaveRequest: 
    
    define public property Handle as handle no-undo get. set. 
    
    constructor public DatasetSaveRequest(pcService as character):
        super(pcService).
    end constructor.
        
    constructor public DatasetSaveRequest(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService).
    end constructor.


end class.