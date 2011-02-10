/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : Client-side security manager
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 04 13:25:00 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

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

using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.

class OpenEdge.CommonInfrastructure.Client.SecurityManager inherits SecurityManager: 

    constructor public SecurityManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
        super (input poServiceManager, input poComponentInfo).
    end constructor.
    
    method override public IUserContext UserLogin(input pcUserName as character,
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
        
        this-object:CurrentUserContext = oResponse[1]:UserContext. 
        
        return CurrentUserContext.
    end method.
    
    method override public void ValidateSession(input poContext as IUserContext):
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cErrorText as character no-undo.
        
        this-object:CurrentUserContext = poContext.
        
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest('SecurityManager.ValidateSession', ServiceMessageActionEnum:ValidateSession).
        oRequest[1]:ContextId = poContext:ContextId.
        oRequest[1]:UserContext = GetPendingContext().
        
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('user context', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        /* update the credentials with the response */
        this-object:CurrentUserContext = oResponse[1]:UserContext.
    end method.
    
    method override public IUserContext ValidateSession(input pcContextId as longchar):
        ValidateSession(GetUserContext(pcContextId)).
        
        return this-object:CurrentUserContext. 
    end method.
    
    method override public void EndSession( input poContext as IUserContext):
        /* theoretically, we could write out some client-side stuff and persist as a cookie of sorts.
           left as an exercise to the reader. */
    end method.
    
    method override public void UserLogout(input poContext as IUserContext):
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        
        this-object:CurrentUserContext = poContext.
        
        /* We can use different service names for login and logout; both will resolve to the same service provider.
           This is used for illustrative purposes. See OpenEdge.CommonInfrastructure.Common.InjectABL.CommonInfrastructureModule 
           for more details */
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:IServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest(ServiceMessageManager:IServiceMessageManagerType:TypeName,
                                                 ServiceMessageActionEnum:UserLogout).
        oRequest[1]:ContextId = poContext:ContextId.
        oRequest[1]:UserContext = GetPendingContext().
        
        /* make the call */
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('logout', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        /* On the client, a successful logout does end the session (not necessarily true on server) */
        EndSession(oResponse[1]:UserContext).
        
        /* user doesn't live here no more */
        this-object:CurrentUserContext = ?.
    end method.
    
end class.