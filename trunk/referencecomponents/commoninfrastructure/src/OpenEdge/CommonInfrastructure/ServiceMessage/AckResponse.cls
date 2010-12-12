 
 /*------------------------------------------------------------------------
    File        : AckResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 06 09:49:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.

routine-level on error undo, throw.

class OpenEdge.CommonInfrastructure.ServiceMessage.AckResponse inherits ServiceResponse: 

		
	constructor public AckResponse ( input poServiceRequest as OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest ):
		super (input poServiceRequest).
		
	end constructor.

		
	constructor public AckResponse ( input pcMessageId as longchar, input pcService as character, input poActionType as OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum ):
		super (input pcMessageId, input pcService, input poActionType).
		
	end constructor.

end class.