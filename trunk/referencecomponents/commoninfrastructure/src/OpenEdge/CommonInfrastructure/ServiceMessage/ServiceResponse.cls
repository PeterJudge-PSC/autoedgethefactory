/** ------------------------------------------------------------------------
    File        : ServiceResponse
    Purpose     : General response class for service messages that are requests 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 16:21:47 EDT 2010
    Notes       : * This general response also contains information about
                    errors on the request.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse abstract inherits ServiceMessage
            implements IServiceResponse:
    
    /** Was there an error on the request? */
    define public property HasError as logical no-undo get. set.
    
    /** If an error occurred, some text related to the error. Could 
       be some meaningful or structured text. Could be a serialized 
       Progress.Lang.Error object. */
    define public property ErrorText as longchar no-undo get. set.
    
	constructor protected ServiceResponse(input pcMessageId as character,
	                                      input pcService as character,
	                                      input poActionType as ServiceMessageActionEnum ):
		super (input pcMessageId, input pcService, input poActionType).
	end constructor.
	
    constructor public ServiceResponse (input poServiceRequest as IServiceRequest):
        super(input cast(poServiceRequest, IServiceMessage):MessageId,
              input cast(poServiceRequest, IServiceMessage):Service,
              input cast(poServiceRequest, IServiceMessage):ActionType).
    end constructor.    

end class.