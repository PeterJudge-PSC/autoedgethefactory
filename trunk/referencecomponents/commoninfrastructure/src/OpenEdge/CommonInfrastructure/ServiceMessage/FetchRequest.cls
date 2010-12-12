/** ------------------------------------------------------------------------
    File        : FetchRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:33:56 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest inherits ServiceRequest
        implements IFetchRequest: 
    
    define public property TableRequests as ITableRequestCollection no-undo
        get():
            if not valid-object(TableRequests) then
                TableRequests = new ITableRequestCollection().
            return TableRequests.
        end get.
        private set. 
    
    constructor public FetchRequest(input pcService as character):
        super(input pcService, input ServiceMessageActionEnum:FetchData).
    end constructor.
    
	constructor public FetchRequest(input pcService as character,
	                                input poMessageType as ServiceMessageActionEnum):
		super(input pcService, input poMessageType).
	end constructor.
	
	constructor public FetchRequest(input pcMessageId as character,
	                                input pcService as character,
	                                input poActionType as ServiceMessageActionEnum):
		super(input pcMessageId, input pcService, input poActionType).
	end constructor.
	
end class.