/** ------------------------------------------------------------------------
    File        : CommonModule
    Purpose     : AutoEdge|TheFactory Shared bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ConnectionManager.
using OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScopeEnum.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using Progress.Lang.Class.

class AutoEdge.Factory.Client.InjectABL.CommonModule inherits InjectionModule: 
    define protected property IServiceProviderType as class Class no-undo get. set.
    define protected property InjectABLServiceProviderType as class Class no-undo get. set.
    
    constructor public CommonModule (  ):
        super ().
        assign IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceProvider')
               InjectABLServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ServiceProvider').
    end constructor.
    
    method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* scopes the security manager's lifecycle to the service manager's */
        oBindingSyntax = Bind(ConnectionManager:IConnectionManagerType).
        oBindingSyntax
            :To('AutoEdge.Factory.Client.Common.CommonInfrastructure.ConnectionManager')
            :Using(InjectABLServiceProviderType)
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnThinClientSession().
        
        LoadServices().        
    end method.
    
    method protected void LoadServices():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* Bind as a service adapter. the server-side bindings will translate this into a IServiceProvider
           object capable of doing something useful. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named('UserLogin')
            :To('OpenEdge.CommonInfrastructure.Client.AppServerServiceAdapter')
            :OnThinClientSession().
    end method.
    
    method protected void LoadConnections():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.Common.IAppServerConnectionParameters').
        oBindingSyntax
            :To('AutoEdge.Factory.Common.AppServerConnectionParameters')
            :Named('AutoEdgeTheFactory')
            :Using(InjectABLServiceProviderType)
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ConnectionManager)
            :OnThinClientSession().
    end method.
    
end class.