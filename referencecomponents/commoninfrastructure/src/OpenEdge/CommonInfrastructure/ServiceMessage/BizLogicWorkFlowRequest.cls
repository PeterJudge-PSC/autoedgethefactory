/* ------------------------------------------------------------------------
    File        : BizLogicWorkFlowRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 02 16:01:49 EST 2010
    Notes       : * DataSlotInstances are the payload? 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkFlowRequest inherits ServiceRequest
        implements IWorkflowRequest:
    
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property BizLogicServer as longchar no-undo get. set.
    
    constructor public BizLogicWorkFlowRequest (input pcMessageId as longchar,
                                                input pcService as character):
		super (pcMessageId, pcService, ServiceMessageActionEnum:PerformWorkFlow).
	end constructor.
	
	constructor public BizLogicWorkFlowRequest (input pcService as character):
		super (pcService, ServiceMessageActionEnum:PerformWorkFlow).
	end constructor.
	
end class.