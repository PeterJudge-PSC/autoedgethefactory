/** ------------------------------------------------------------------------
    File        : CommonInfrastructureModule
    Purpose     : Binding for Common Infrastructure InjectABL services 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 17 09:02:59 EDT 2010
    Notes       : * This is a client-side-only module (by virtue of Propath/naming),
                    and so the OnClientSession() binding is probably not strictly necessary.
                    However, it's useful to have.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.CommonSecurityManager.

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.InjectABL.CommonInfrastructureModule inherits InjectionModule: 
    
    constructor public CommonInfrastructureModule():
        super().
    end constructor.
    
    method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        /**  SecurityManager handles context, login, etc. Its lifecycle scoped to the service manager's.
             We have a client manager, a server manager and a service adapter for getting from the
             former to the latter, across session boundaries. 

             Server-side binding is done per-application, since we currently have no generic auth code */
        oBindingSyntax = Bind(CommonSecurityManager:SecurityManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.SecurityManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnClientSession().
             
        /* We can either bind the whole manager as a service, or we can bind the individual services.
           We have an example of both here. */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.SecurityManagerServiceAdapter')
            :Named(CommonSecurityManager:SecurityManagerType:TypeName)
            :OnClientSession()
            :WithPropertyValue('Service', CommonSecurityManager:SecurityManagerType:TypeName).
        
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.SecurityManagerServiceAdapter')
            :Named('SecurityManager.UserLogin')
            :OnClientSession()
            :WithPropertyValue('Service', 'SecurityManager.UserLogin').
    
    end method.
    
end class.