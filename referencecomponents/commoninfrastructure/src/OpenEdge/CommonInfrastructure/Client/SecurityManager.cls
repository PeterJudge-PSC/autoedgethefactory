/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 04 13:25:00 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SecurityManagerResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.ServiceMessageManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

using OpenEdge.Core.System.InvalidValueSpecifiedError.

class OpenEdge.CommonInfrastructure.Client.SecurityManager inherits OpenEdge.CommonInfrastructure.Common.SecurityManager: 

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
        
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:ServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest('SecurityManager.UserLogin', ServiceMessageActionEnum:UserLogin).
        assign oRequest[1]:UserName = pcUserDomain
               oRequest[1]:UserDomain = pcUserDomain
               oRequest[1]:UserPassword = pcPassword.
        
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('login credentials', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
        
        this-object:CurrentUserContext = oResponse[1]:UserContext. 
        
        return CurrentUserContext.
	end method.

	method override public void ValidateSession(input poContext as IUserContext):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method override public IUserContext ValidateSession(input pcContextId as longchar):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method override public void EndSession( input poContext as IUserContext):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.
	
	method override public void UserLogout( input poContext as OpenEdge.CommonInfrastructure.Common.IUserContext ):
        define variable oResponse as SecurityManagerResponse extent no-undo.
        define variable oRequest as SecurityManagerRequest extent 1 no-undo.
        define variable oSMM as IServiceMessageManager no-undo.
        
        /* We can use different service names for login and logout; both will resolve to the same service provider.
           This is used for illustrative purposes. See OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule 
           for more details */
        oSMM = cast(ServiceManager:StartService(ServiceMessageManager:ServiceMessageManagerType), IServiceMessageManager).
        
        oRequest[1] = new SecurityManagerRequest(ServiceMessageManager:ServiceMessageManagerType:TypeName, ServiceMessageActionEnum:UserLogout).
        oRequest[1]:ContextId = poContext:ContextId.
        
        oResponse = cast(oSMM:ExecuteRequest(cast(oRequest, IServiceRequest)), SecurityManagerResponse).
        
        if cast(oResponse[1], IServiceResponse):HasError then
            undo, throw new InvalidValueSpecifiedError('logout', ': ' + string(cast(oResponse[1], IServiceResponse):ErrorText)).
	end method.	
	
end class.