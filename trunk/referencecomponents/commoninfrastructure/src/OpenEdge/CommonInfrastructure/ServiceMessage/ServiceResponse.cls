/** ------------------------------------------------------------------------
    File        : ServiceResponse
    Purpose     : General response class for service messages that are requests 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 16:21:47 EDT 2010
    Notes       : * This class exists largely to enforce constructor constraints,
                    so that there's always a MessageId passed in - this message ID
                    should map to the ServiceRequest that this ServiceResponse is
                    responding to.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse abstract inherits ServiceMessage
            implements IServiceResponse:
    
    constructor public ServiceResponse (input poServiceRequest as IServiceRequest):
        super(input cast(poServiceRequest, IServiceMessage):MessageId,
              input cast(poServiceRequest, IServiceMessage):Service,
              input cast(poServiceRequest, IServiceMessage):ActionType).
    end constructor.
    
end class.