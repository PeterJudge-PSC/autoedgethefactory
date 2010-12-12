/** ------------------------------------------------------------------------
    File        : UserContext
    Purpose     : Dummy user context object 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Dec 02 11:37:05 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IUserContext.

class OpenEdge.CommonInfrastructure.Common.UserContext implements IUserContext: 

	define public property ClientSessionId as longchar no-undo get. private set.
	
	constructor public UserContext (input pcClientSessionId as longchar):
	    ClientSessionId = pcClientSessionId.
    end constructor.
    
end class.