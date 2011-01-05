/** ------------------------------------------------------------------------
    File        : SecurityManagerResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jan 04 14:29:05 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

class OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerResponse inherits ServiceResponse: 
    
    define public property UserContext as IUserContext no-undo get. set.
    
	constructor public SecurityManagerResponse ( input poServiceRequest as SecurityManagerRequest ):
		super (input cast(poServiceRequest, IServiceRequest)).
		
	end constructor.
	
end class.