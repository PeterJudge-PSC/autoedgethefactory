/*------------------------------------------------------------------------
    File        : DefineResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:13:04 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.DefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.Core.System.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.DefineResponse inherits ServiceMessage
        implements IDefineResponse: 
        
    constructor public DefineResponse(pcService as character):
        super(pcService, ServiceMessageActionEnum:Define).
    end constructor.
        
    constructor public DefineResponse(pcMessageId as character, pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Define).
    end constructor.
    
end class.