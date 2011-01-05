/** ------------------------------------------------------------------------
    File        : SecurityManagerRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 04 14:28:49 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum. 
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequest.

class OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerRequest inherits ServiceRequest:
    
    /* name of the user to whom this context applies */
    define public property UserName as character no-undo get. set.
    
    /* domain of the user to whom this context applies */
    define public property UserDomain as character no-undo get.  set.
    
    /* name of the user to whom this context applies */
    define public property UserPassword as character no-undo get. set.
    
    /** Unique identifier for the client session */
    define public property ContextId as longchar no-undo get.  set.
    
	constructor public SecurityManagerRequest ( input pcService as character, input poMessageType as ServiceMessageActionEnum ):
		super (input pcService, input poMessageType).
	end constructor.
		
end class.