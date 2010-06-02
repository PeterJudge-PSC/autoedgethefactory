/*------------------------------------------------------------------------
    File        : SaveResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:09:22 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.Core.System.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse inherits ServiceMessage
        implements ISaveResponse: 

    constructor public SaveResponse(pcService as character):
        super(pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
    constructor public SaveResponse(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
end class.