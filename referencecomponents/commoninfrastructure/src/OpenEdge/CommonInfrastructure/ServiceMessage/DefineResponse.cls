/** ------------------------------------------------------------------------
    File        : DefineResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:13:04 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.DefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.DefineResponse inherits ServiceMessage
        implements IDefineResponse, IServiceResponse: 
        
    constructor public DefineResponse(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Define).
    end constructor.
        
    constructor public DefineResponse(input pcMessageId as character,
                                      input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Define).
    end constructor.
    
end class.