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

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScope.
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
                     ManagerScope:ServiceManager)
            .
        
        /* Scopes the tenant manager's lifecycle to the kernel's (aka Singleton-like behaviour) */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.ITenantManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Client.TenantManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScope:ServiceManager)
            :OnClientSession()
            .

        /** ServiceMessageManager handles requests and responses to and from the business component
            layers.               */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IServiceMessageManager').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.Common.ServiceMessageManager')
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScope:ServiceManager)
            .
        
        /**  */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter').
        oBindingSyntax
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter')
            :WithConstructorArgument(Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'))
            .
        
    end method.
    
end class.