@todo(task="question", action="why do we need this specialisation? for ISaveRequest only?").
/** ------------------------------------------------------------------------
    File        : SaveResponse
    Purpose     : General save response class 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:09:22 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse inherits ServiceResponse
        implements ISaveResponse:
    
	constructor public SaveResponse(input poServiceRequest as ISaveRequest):
		super (input cast(poServiceRequest, IServiceRequest)).
	end constructor.
    
end class.