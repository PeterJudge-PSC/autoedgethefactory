/** ------------------------------------------------------------------------
    File        : FactoryCommonModule
    Purpose     : AutoEdge|TheFactory Shared bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryCommonModule inherits InjectionModule: 
    define protected property InjectABLServiceProviderType as class Class no-undo get. set.
    define protected property IServiceProviderType as class Class no-undo get. set.
    
    constructor public FactoryCommonModule (  ):
        super ().
        
        assign IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider')
               InjectABLServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider').
    end constructor.
    
    method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* savvion parameters */
        oBindingSyntax = Bind('OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters').
        oBindingSyntax
            :To('AutoEdge.Factory.Common.SavvionParameters').
        
        /* the tenant manager's lifecycle matches the security manager's */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ITenantManager').
        oBindingSyntax
            :To('AutoEdge.Factory.Common.Server.TenantManager')
            :Using(InjectABLServiceProviderType)
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
/*            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),*/
/*                     ManagerScopeEnum:SecurityManager)                                      */
            .
            
@todo(task="refactor", action="").        
/* NOTE: using service manager on client for testing purposes 

            :OnServerSession().
*/

        /* scopes the security manager's lifecycle to the service manager's */
        oBindingSyntax = Bind(OpenEdge.CommonInfrastructure.CommonSecurityManager:SecurityManagerType).
        oBindingSyntax
            :To('AutoEdge.Factory.Common.Server.SecurityManager')
            :Using(InjectABLServiceProviderType)
            :InScope(Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ManagerScope'),
                     ManagerScopeEnum:ServiceManager)
            :OnServerSession().
        
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
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter')
/*            :To('OpenEdge.CommonInfrastructure.SecurityManagerServiceAdapter')*/
            :OnClientSession().
    end method.
    
end class.