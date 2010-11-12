/** ------------------------------------------------------------------------
    File        : AckResponse
    Purpose     : Simple acknowledgement response for a service request 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Nov 09 14:40:49 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

class OpenEdge.CommonInfrastructure.ServiceMessage.AckResponse inherits ServiceResponse:
    
	constructor public AckResponse (input poServiceRequest as IServiceRequest):
        super(input cast(poServiceRequest, IServiceMessage):MessageId,
              input cast(poServiceRequest, IServiceMessage):Service,
              input ServiceMessageActionEnum:ACK).
	end constructor.

end class.