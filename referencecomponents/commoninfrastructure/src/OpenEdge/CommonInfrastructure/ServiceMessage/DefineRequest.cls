/*------------------------------------------------------------------------
    File        : DefineRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:13:04 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.DefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.Core.System.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.DefineRequest inherits ServiceMessage
        implements IDefineRequest: 
        
    constructor public DefineRequest(pcService as character):
        super(pcService, ServiceMessageActionEnum:Define).
    end constructor.
        
    constructor public DefineRequest(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Define).
    end constructor.
    
end class.