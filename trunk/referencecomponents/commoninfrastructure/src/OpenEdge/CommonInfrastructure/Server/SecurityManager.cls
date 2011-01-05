/** ------------------------------------------------------------------------
    File        : SecurityManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 11:54:05 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IUserContext.
using OpenEdge.CommonInfrastructure.Common.UserContext.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo. 
using OpenEdge.CommonInfrastructure.Common.ITenantManager.
using OpenEdge.CommonInfrastructure.Common.Service.

using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidActionError.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Server.SecurityManager abstract inherits OpenEdge.CommonInfrastructure.Common.SecurityManager 
        implements ISecurityManager:
    
    define protected property TenantManager as ITenantManager no-undo
        get():
            if not valid-object(TenantManager) then
                TenantManager = cast(ServiceManager:StartService(Class:GetClass('OpenEdge.CommonInfrastructure.Common.ITenantManager')), ITenantManager).
            
            return TenantManager.
        end get.
        set.

    constructor public SecurityManager(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    method public override void ValidateSession(input poContext as IUserContext):
        /* do the validation, whatever that might entail */
        
        CurrentUserContext = poContext.
    end method.
    
    method override public IUserContext ValidateSession(input pcContextId as longchar):
        define variable oUC as IUserContext no-undo.
        
        /* always read from "datastore" aka disk in our case */
        oUC =  ReadSerializedContext(pcContextId).
        
        if not valid-object(oUC) then
           undo, throw new InvalidValueSpecifiedError(
                            'user context',
                            substitute('context id &1', pcContextId)).
        
        /* HappyPlace! */
        return CurrentUserContext.
    end method.
        
    method override public void EndSession(input poContext as IUserContext):
        /* write out the context values */
        WriteSerializedContext(poContext).
        CurrentUserContext = ?.
    end method.
    
    method override public IUserContext GetClientContext(input pcContextId as longchar):
	   return ValidateSession(pcContextId).
	end method.
	
    method abstract protected void ValidateCredentials(input pcUserName as character,
                                              input pcUserDomain as character,
                                              input pcPassword as character).
    
    method override public IUserContext UserLogin(input pcUserName as character,
                                                  input pcUserDomain as character,
                                                  input pcPassword as character):
        define variable oUC as IUserContext no-undo.
        
        /* validate login credentials */
        ValidateCredentials(pcUserName, pcUserDomain, pcPassword).
        
        /* create context and establish tenancy */
        oUC = new UserContext(pcUserName, pcUserDomain).
        oUC:EstablishTenancy(TenantManager).
        
        WriteSerializedContext(oUC).
        
        return oUC.
    end method.

end class.