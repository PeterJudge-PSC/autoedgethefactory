/** ------------------------------------------------------------------------
    File        : FactoryCommonModule
    Purpose     : AutoEdge|TheFactory Shared bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.InjectABL.ManagerScopeEnum.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryCommonModule inherits InjectionModule:
     
    constructor public FactoryCommonModule (  ):
        super ().
    end constructor.
    
    method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* savvion parameters */
        oBindingSyntax = Bind('OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters').
        oBindingSyntax
            :To('AutoEdge.Factory.EnterpriseServices.SavvionParameters').

    end method.
    
end class.