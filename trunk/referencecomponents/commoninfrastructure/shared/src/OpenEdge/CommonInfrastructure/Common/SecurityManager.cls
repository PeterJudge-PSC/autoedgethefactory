/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:54:05 EDT 2010
    Notes       :               
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidActionError.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.SecurityManager abstract inherits Service 
        implements ISecurityManager:
    
    /** Use these properties in lieu of having to say Class:GetClass('....ISecurityManager') every time */
    define static public property IUserContextType as class Class no-undo get. private set.
    define static public property ISecurityManagerType as class Class no-undo get. private set.
    
    constructor static SecurityManager():
        SecurityManager:ISecurityManagerType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ISecurityManager').
        SecurityManager:IUserContextType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.IUserContext').
    end constructor.
    
    /** Returns the current user's context. The current user is the one who has
        a request being serviced by this AVM. */
    define public property CurrentUserContext as IUserContext no-undo
        get.
        protected set.
        
    /** Describes whether the current session is managed or not. A managed session
        basically has a user associated with it. */
    define public property IsManagedSession as logical no-undo
        get():
            return valid-object(CurrentUserContext).
        end get.
    
    constructor public SecurityManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    /** Validates a user's session as identified by context.
        
        @param IUserContext The user context object being validated. */    
    method abstract public void ValidateSession(input poContext as IUserContext).

    /** Validates a user's session as identified by a context id.
             
        @param longchar A user context id (typically a guid).
        @return IUserContext The (validated) user context object for the given ID. */
    method abstract public IUserContext ValidateSession(input pcContextId as longchar).
        
    /** Ends a user's session (not a log out, but the opposite of ValidateSession).
        Ends the current session. */
    method public void EndSession():
        EndSession(CurrentUserContext).
    end method.
    
    /** Ends a user's session (not a log out, but the opposite of ValidateSession) 
        
        @param IUserContext The context identifying the user who's session is being ended. */    
    method abstract public void EndSession(input poContext as IUserContext).
    
    /** Ends a user's session (not a log out, but the opposite of ValidateSession) 
        
        @param longchar The context ID identifying the user who's session is being ended. */    
    method public void EndSession(input pcContextId as longchar):
        EndSession(GetUserContext(pcContextId)).
    end method.    

    /** Resolves a context ID into a context object.
        
        @param longchar The identifier for the context.
        @return IUserContext The user context object. */
    method public IUserContext GetUserContext(input pcContextId as longchar):
       return ValidateSession(pcContextId).
    end method.
    
    /** Retrieves or build user context for passing across the wire (in either direction).
        
        @return IUserContext User context for sending across the wire */
    method public IUserContext GetPendingContext():
        /* In the absence of an override, return the current context.
           An override to this call may take the contents of the CurrentUserContext,
           and edit/manipulate them in some way, so that only some values are passed 
           across the wire.     */
        return CurrentUserContext.
    end method.
    
    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted.
        @return IUserContext The (validated) user context object for the given credentials. */    
    method abstract public IUserContext UserLogin(input pcUserName as character,
                                                  input pcUserDomain as character,
                                                  input pcPassword as character).
    /** Logs a user into the application
    
        @param character The user's login name
        @param character The user's password. This should be encoded/encrypted.
        @return IUserContext The (validated) user context object for the given credentials. */
    method public IUserContext UserLogin(input pcUserName as character,
                                         input pcPassword as character):
        define variable cDomain as character no-undo.
        
        if num-entries(pcUserName, '@') eq 2 then
            assign cDomain = entry(2,  pcUserName, '@')
                   pcUserName = entry(1,  pcUserName, '@').
        
        return UserLogin(pcUserName, cDomain, pcPassword).                                             
    end method.
    
    /** Logs a user out of the application.
        
        @param IUserContext The (validated) user context object for the given credentials. */
    method public void UserLogout(input poContext as IUserContext):
        CurrentUserContext = ?.
        
        /* end the session */
        EndSession(poContext).
    end method.
    
    /** Logs a user out of the application.
        
        @param longchar The user context ID. */
    method public void UserLogout(input pcContextId as longchar):
        UserLogout(GetUserContext(pcContextId)).
    end method.
    
    /** Read and write allows us to turn context into a kind of cookie, if we so desire. */
    method protected IUserContext ReadSerializedContext(input pcContextId as longchar):
        define variable oOIS as IObjectInput no-undo.
        define variable oUC as IUserContext no-undo.
        define variable cFilename as character no-undo.
        
        cFilename = search(string(session:temp-dir + SecurityManager:IUserContextType:TypeName + '.' + pcContextId + '.ser')).
        if not cFilename eq ? then
        do:
            oOIS = new ObjectInputStream().
            oOIS:Read(cFilename).
            oUC = cast(oOIS:ReadObject(), IUserContext).
        end.
        
        return oUC.
    end method.
    
    method protected void WriteSerializedContext(input poUserContext as IUserContext):
        define variable oOOS as IObjectOutput no-undo.
        define variable oUC as IUserContext no-undo.
        define variable cFilename as character no-undo.
        
        if valid-object(poUserContext) then
        do:
            cFilename = session:temp-dir + SecurityManager:IUserContextType:TypeName + '.' + poUserContext:ContextId + '.ser'.
            
            oOOS = new ObjectOutputStream().
            oOOS:WriteObject(poUserContext).
            oOOS:Write(cFilename).
        end.
    end method.
    
    /** Authorises the current user to undertake the specified action on the
        service. AN error is thrown if the authentication fails.
        
        @param character The service being operated upon.
        @param ServiceMessageActionEnum The Action being performed. */
    method public void AuthenticateServiceAction (input pcService as character,
                                                  input poServiceMessageAction as ServiceMessageActionEnum):
        @todo(task="implement", action="").
    end method.
    
end class.