/** ------------------------------------------------------------------------
    File        : ServiceRequest
    Purpose     : A request to a service for data or action
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 16:19:53 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest inherits ServiceMessage
        implements IServiceRequest:
    
    constructor public ServiceRequest (input pcService as character,
                                       input poMessageType as ServiceMessageActionEnum):
        super(input pcService, input poMessageType).
    end constructor.
    
	constructor public ServiceRequest (input pcMessageId as longchar,
	                                   input pcService as character,
	                                   input poActionType as ServiceMessageActionEnum ):
		super (input pcMessageId, input pcService, input poActionType).
	end constructor.
	
end class.