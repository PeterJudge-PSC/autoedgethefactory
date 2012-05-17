/** ------------------------------------------------------------------------
    File        : ISecurityManager
    Purpose     : Interface for server-side security manager operations.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 06 14:39:50 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.IUserContext.
  
interface OpenEdge.CommonInfrastructure.Server.ISecurityManager inherits OpenEdge.CommonInfrastructure.Common.ISecurityManager:
    /** Validates that the passed context is valid and that the session can be established.
        
        @param longchar A user context id. */
    method public void EstablishSession(input pcContextId as longchar).

    /** Validates that the passed context is valid and that the session can be established.
        
        @param IUserContext A user context object to validate. */
    method public void EstablishSession(input poUserContext as IUserContext).
    
    /** Ends a user's session (not a log out, but the opposite of EstablishSession) 
        
        @param longchar The context ID identifying the user who's session is being ended. */
    method public void EndSession(input pcContextId as longchar).
    
    /** Retrieves or build user context for passing across the wire (in either direction).
        The complement to this method is the SetUserContext() method, which will be invoked
        after the call across the wire.
        
        @param longchar The identifier for the context.
        @return IUserContext User context for sending across the wire */
    method public IUserContext GetPendingContext(input pcContextId as longchar).
    
    /** Logs a user out of the application.
        
        @param longchar The user context ID. */
    method public void UserLogout(input pcContextId as longchar).

    /** Logs a user out of the application.
        
        @param IUserContext A user context object . */
    method public void UserLogout(input poUserContext as IUserContext).
    
end interface.