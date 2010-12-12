/** ------------------------------------------------------------------------
    File        : WorkstepResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 10:00:20 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.WorkstepResponse inherits ServiceResponse
            implements IWorkstepResponse: 
    
    /** (optional) The workstep name. */
    define public property Name as longchar no-undo
       get():
           if this-object:Name eq ? or this-object:Name eq '' then
               Name = Service.
       end get.
       set.
    
    /** (optional) A status text for the workstep */
    define public property Status as longchar no-undo get. set.  
    
	constructor public WorkstepResponse(input poServiceRequest as IWorkstepRequest):
		super(input cast(poServiceRequest, IServiceRequest)).
	end constructor.
	
	constructor public WorkstepResponse(input pcMessageId as longchar,
	                                    input pcService as character):
		super(input pcMessageId, input pcService, ServiceMessageActionEnum:PerformWorkStep).
	end constructor.
	
end class.