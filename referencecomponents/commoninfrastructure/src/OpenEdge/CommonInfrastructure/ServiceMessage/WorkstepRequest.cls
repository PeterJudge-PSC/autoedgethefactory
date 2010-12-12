/** ------------------------------------------------------------------------
    File        : WorkstepRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 01 19:04:36 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.WorkstepRequest inherits ServiceRequest
        implements IWorkStepRequest:
    
    /** (optional) The workstep name. */
	define public property Name as longchar no-undo
	   get():
	       if this-object:Name eq ? or this-object:Name eq '' then
	           Name = Service.
	   end get.
	   set.
    
	constructor public WorkstepRequest(input pcService as character):
		super (input pcService, ServiceMessageActionEnum:PerformWorkStep).
	end constructor.
	
	constructor public WorkstepRequest ( input pcMessageId as longchar, input pcService as character):
		super (input pcMessageId, input pcService, input ServiceMessageActionEnum:PerformWorkStep).
	end constructor.

end class.