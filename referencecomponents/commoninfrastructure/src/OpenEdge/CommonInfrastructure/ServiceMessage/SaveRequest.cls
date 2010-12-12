/** ------------------------------------------------------------------------
    File        : SaveRequest
    Purpose     : A request for committing data.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:04:55 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest inherits ServiceRequest
        implements ISaveRequest:
    
	define public property TableNames as character extent no-undo get. set. 

    constructor public SaveRequest(input pcService as character):
        super(pcService, ServiceMessageActionEnum:SaveData).
    end constructor.
    
    constructor public SaveRequest(input pcMessageId as character,
                                   input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:SaveData).
    end constructor.

	constructor public SaveRequest(input pcService as character,
                                   input poMessageType as ServiceMessageActionEnum ):
		super (input pcService, input poMessageType).
	end constructor.
		
	constructor public SaveRequest(input pcMessageId as character,
	                               input pcService as character,
	                               input poActionType as ServiceMessageActionEnum ):
		super (input pcMessageId, input pcService, input poActionType).
	end constructor.
	
end class.