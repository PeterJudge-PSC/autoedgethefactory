/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : Client-side security manager
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 04 13:25:00 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Client.ISecurityManager.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.SecurityManagerRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.SecurityManagerResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.AuthenticationError.

using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Client.SecurityManager inherits SecurityManager
        implements ISecurityManager:
    
    constructor public SecurityManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
        super (input poServiceManager, input poComponentInfo).
    end constructor.
    
    /** Logs a user into the application. The client-side version of this passes the request across to the
        an AppServer.
        
        @param character The user's login name
        @param character The user's login/security domain
        @param character The user's password. This should be encoded/encrypted. */
    method override public void UserLogin(input pcUserName as character,
                                          input pcUserDomain as character,
                                          input pcPassword as character):
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cErrorText as character no-undo.
        
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest('SecurityManager.UserLogin', ServiceMessageActionEnum:UserLogin).
        assign oRequest[1]:UserName = pcUserName
               oRequest[1]:UserDomain = pcUserDomain
               oRequest[1]:UserPassword = pcPassword.
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('login credentials', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        /* Don't validate, since the current context should be ?, and we're estabilishing a new session */
        SetUserContext(oResponse[1]:UserContext).
    end method.
    
    /** Merges the passed context into the curernt user's context. On the client,
        we take the additional step of validating the context for this session. 
        
        @param IUserContext The context to merge.   */    
    method override public void SetUserContext(input poContext as IUserContext):
        Assert:ArgumentNotNull(poContext, 'User Context').
        
        ValidateSession(poContext).
        
        super:SetUserContext(poContext).
    end method.
    
    method protected void ValidateSession(input poContext as IUserContext):
        Assert:ArgumentNotNull(poContext, 'User Context').
        
        if valid-object(CurrentUserContext) and not CurrentUserContext:Equals(poContext) then
            undo, throw new AuthenticationError(
                    'User context',
                    substitute('passed context does not match stored context (Context ID = &1)', poContext:ContextId)).
    end method.
    
    @deprecated(version="1.0.3").
    /** The method validates the client session on the server.
        
        @param longchar The context ID for the user, so as to validate the session 
    method override public void ValidateSession(input pcContextId as longchar):
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cErrorText as character no-undo.
        
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest('SecurityManager.ValidateSession', ServiceMessageActionEnum:ValidateSession).
        oRequest[1]:ContextId = pcContextId.
        oRequest[1]:UserContext = GetPendingContext().
        
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('user context', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        /* update the context with the response, if any */
        SetUserContext(oResponse[1]:UserContext).
    end method.
        */
    
    /** Logs the current user out of the application. */
    method public void UserLogout():
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        
        /* We can use different service names for login and logout; both will resolve to the same service provider.
           This is used for illustrative purposes. See OpenEdge.CommonInfrastructure.Common.InjectABL.CommonInfrastructureModule 
           for more details */
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest(SecurityManager:ISecurityManagerType:TypeName,
                                                 ServiceMessageActionEnum:UserLogout).
        oRequest[1]:ContextId = CurrentUserContext:ContextId.
        oRequest[1]:UserContext = GetPendingContext().
        
        /* make the call */
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('logout', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        /* On the client, a successful logout does end the session (not necessarily true on server) */
        SetUserContext(oResponse[1]:UserContext).
        EndSession().
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
    
end class.