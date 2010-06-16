/* ------------------------------------------------------------------------
    File        : SaveRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:04:55 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest inherits ServiceMessage
        implements ISaveRequest, IServiceRequest: 

    constructor public SaveRequest(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
    constructor public SaveRequest(input pcMessageId as character,
                                   input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Save).
    end constructor.
    
end class.