/*------------------------------------------------------------------------
    File        : DatasetSaveResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:11:07 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.DatasetSaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDatasetSaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse.

class OpenEdge.CommonInfrastructure.ServiceMessage.DatasetSaveResponse inherits SaveResponse  
        implements IDatasetSaveResponse: 

    define public property Handle as handle no-undo  get. set. 

    constructor public DatasetSaveResponse(pcService as character ):
        super(pcService).
    end constructor.
    
    constructor public DatasetSaveResponse(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService).
    end constructor.

end class.