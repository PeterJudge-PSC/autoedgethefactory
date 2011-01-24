@todo(task="implement", action="split into client and server?").
/*------------------------------------------------------------------------
    File        : ISecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:53:52 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.IUserContext.
  
interface OpenEdge.CommonInfrastructure.ISecurityManager:
          
    /** Returns the current user's context. The current user is the one who has
        a request being serviced by this AVM. */
    define public property CurrentUserContext as IUserContext no-undo get.
        
    /** Describes whether the current session is managed or not. */
    define public property IsManagedSession as logical no-undo get.
    
    /** Validates a user's session as identified by a context id.
             
        @param longchar A user context id (typically a guid).
        @return IUserContext The (validated) user context object for the given ID. */    
    method public IUserContext ValidateSession(input pcContextId as longchar).

    /** Validates a user's session as identified by context.
        
        @param IUserContext The user context object being validated. */    
    method public void ValidateSession(input poContext as IUserContext).
    
    /** Ends a user's session (not a log out, but the opposite of ValidateSession).
        Ends the current session. */
    method public void EndSession().
    
    /** Ends a user's session (not a log out, but the opposite of ValidateSession) 
        
        @param IUserContext The context identifying the user who's session is being ended. */
    method public void EndSession(input poContext as IUserContext).

    /** Ends a user's session (not a log out, but the opposite of ValidateSession) 
        
        @param longchar The context ID identifying the user who's session is being ended. */
    method public void EndSession(input pcContextId as longchar).
    
    /** Resolves a context ID into a context object.
        
        @param longchar The identifier for the context.
        @return IUserContext The user context object. */
    method public IUserContext GetUserContext(input pcContextId as longchar).

    /** Retrieves or build user context for passing across the wire (in either direction).
        
        @return IUserContext User context for sending across the wire */
    method public IUserContext GetPendingContext().
    
    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's password. This should be encoded/encrypted.
        @return IUserContext The (validated) user context object for the given credentials. */
    method public IUserContext UserLogin(input pcUserName as character,
                                         input pcPassword as character).

    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted.
        @return IUserContext The (validated) user context object for the given credentials. */
    method public IUserContext UserLogin(input pcUserName as character,
                                         input pcUserDomain as character,
                                         input pcPassword as character).
    
    /** Logs a user out of the application.
        
        @param IUserContext The (validated) user context object for the given credentials. */
    method public void UserLogout(input poContext as IUserContext).

    /** Logs a user out of the application.
        
        @param longchar The user context ID. */
    method public void UserLogout(input pcContextId as longchar).
    
    /** Authorises the current user to undertake the specified action on the
        service. An error is thrown if the authentication fails.
        
        @param character The service being operated upon.
        @param ServiceMessageActionEnum The Action being performed. */
    method public void AuthenticateServiceAction (input pcService as character,
                                                  input poServiceMessageAction as ServiceMessageActionEnum).
    
end interface.