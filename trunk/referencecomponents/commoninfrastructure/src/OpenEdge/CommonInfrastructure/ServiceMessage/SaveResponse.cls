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

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse inherits ServiceMessage
        implements ISaveResponse, IServiceResponse: 

    constructor public SaveResponse(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
    constructor public SaveResponse(input pcMessageId as character,
                                    input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
end class.