/** ------------------------------------------------------------------------
    File        : DefineRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:13:04 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.DefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.DefineRequest inherits ServiceMessage
        implements IDefineRequest, IServiceRequest: 
        
    constructor public DefineRequest(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Define).
    end constructor.
    
    constructor public DefineRequest(input pcMessageId as character,
                                     input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Define).
    end constructor.
    
end class.