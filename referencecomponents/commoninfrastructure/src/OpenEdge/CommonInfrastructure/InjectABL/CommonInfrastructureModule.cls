/*------------------------------------------------------------------------
    File        : CommonInfrastructureModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 17 09:02:59 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

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
            based on session.
          */
        /** ServiceManager does not use the ComponentProvider */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.ServiceManager')
            :InSingletonScope()
            :WithConstructorArgument(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'))
            :OnClientSession()
            .
        
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Server.ServiceManager')
            :InSingletonScope()
            :WithConstructorArgument(Class:GetClass('OpenEdge.Core.InjectABL.IKernel'))
            :OnServerSession()
            .
        
        /* scopes the security manager's lifecycle to the service manager's */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.ISecurityManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.SecurityManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            .
        
        /* Scopes the tenant manager's lifecycle to the kernel's (aka Singleton-like behaviour) */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.ITenantManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.TenantManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnClientSession()
            .
        
        /** ServiceMessageManager handles requests and responses for data. */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.ServiceMessageManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            .
        
        /** The IServiceRequestBundle executes the requests; this execution may differ depending
            on whether we're on the client (call to ServiceAdapter) or server (call to Business Component) */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceRequestBundle').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.ServiceRequestBundle')
            :InTransientScope()
            .
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceRequestBundle').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Server.ServiceRequestBundle')
            :OnServerSession()
            :InTransientScope()
            .
        
        @todo(task="question", action="does this belong here? a separate module?").
        /** Default/simple service adapter binding */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter').
        
    end method.
    
end class.