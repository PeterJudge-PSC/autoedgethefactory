/** ------------------------------------------------------------------------
    File        : CommonInfrastructureModule
    Purpose     : Binding for Common Infrastructure InjectABL services 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 17 09:02:59 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Client.ServiceManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.ServiceMessageManager.

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
        
        /** Bind IServiceManager to the relevant client or server-side implementation
            based on session.    */
        /** ServiceManager does not use the ComponentProvider */
        oBindingSyntax = Bind(ServiceManager:ServiceManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.ServiceManager')
            :InSingletonScope()
            :WithConstructorArgument(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'))
            :OnClientSession()
            .
        
        oBindingSyntax = Bind(ServiceManager:ServiceManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Server.ServiceManager')
            :InSingletonScope()
            :WithConstructorArgument(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'))
            :OnServerSession()
            .
        
        /**  SecurityManager handles context, login, etc. Its lifecycle scoped to the service manager's.
             We have a client manager, a server manager and a service adapter for getting from the
             former to the latter, across session boundaries. */
        oBindingSyntax = Bind(SecurityManager:SecurityManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.SecurityManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnClientSession().

        oBindingSyntax = Bind(SecurityManager:SecurityManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.SecurityManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnServerSession().
        
        /* We can either bind the whole manager as a service, or we can bind the individual services.
           We have an example of both here. */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.SecurityManagerServiceAdapter')
            :Named(SecurityManager:SecurityManagerType:TypeName)
            :OnClientSession()
            :WithPropertyValue('Service', SecurityManager:SecurityManagerType:TypeName).
        
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.SecurityManagerServiceAdapter')
            :Named('SecurityManager.UserLogin')
            :OnClientSession()
            :WithPropertyValue('Service', 'SecurityManager.UserLogin').

        /* scopes the tenant manager's lifecycle to the security manager's */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.ITenantManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Server.TenantManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:SecurityManager)
            :OnServerSession().
        
        /** ServiceMessageManager handles requests and responses for data. */
        oBindingSyntax = Bind(ServiceMessageManager:ServiceMessageManagerType).
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.ServiceMessageManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            .
    end method.
    
end class.