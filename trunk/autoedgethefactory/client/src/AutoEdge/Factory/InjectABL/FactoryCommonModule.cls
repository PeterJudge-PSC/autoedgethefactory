/** ------------------------------------------------------------------------
    File        : FactoryCommonModule
    Purpose     : Client-side Common bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
/*routine-level on error undo, throw.*/

using OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule.
using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryCommonModule inherits BusinessComponentModule: 
    
	constructor public FactoryCommonModule (  ):
		super ().
	end constructor.
    
	method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* savvion parameters */        
        oBindingSyntax = Bind('OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicServerParameters').
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
        
        LoadEntities().
	end method.
	
    method protected void LoadEntities():
        define variable cDSName as character extent no-undo.
        define variable cConcreteDS as character extent no-undo.
        define variable cDSTableName as character extent no-undo.
        
        assign extent(cDSName) = 1
               extent(cConcreteDS) = 1
               extent(cDSTableName) = 1
               
               cDSName[1] = 'UserLoginDataSource'
               cConcreteDS[1] = 'AutoEdge.Factory.Common.Server.BusinessComponents.UserTableDS'
               cDSTableName[1] = 'ApplicationUser'
               .
        BindBusinessEntity(
            'UserLogin', 'AutoEdge.Factory.Common.Server.BusinessComponents.UserLoginEntity',
            'UserLoginDA', 'AutoEdge.Factory.Common.Server.BusinessComponents.UserLoginDA',
            cDSName, cDSTableName, cConcreteDS).
    end method.
    
end class.