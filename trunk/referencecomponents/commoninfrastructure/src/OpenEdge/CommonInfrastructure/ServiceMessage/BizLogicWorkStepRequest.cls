/*------------------------------------------------------------------------
    File        : BizLogicWorkStepRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Dec 07 13:13:41 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.WorkstepRequest.

class OpenEdge.CommonInfrastructure.ServiceMessage.BizLogicWorkStepRequest inherits WorkstepRequest:
    define public property WorkItemName as character no-undo get. set.
    define public property ProcessInstanceName as character no-undo get. set. 
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property WorkItemId as int64 no-undo get. set.
    
	constructor public BizLogicWorkStepRequest ( input pcService as character ):
		super (input pcService).
	end constructor.

	constructor public BizLogicWorkStepRequest ( input pcMessageId as longchar, input pcService as character ):
		super (input pcMessageId, input pcService).
	end constructor.

end class.