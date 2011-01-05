/** ------------------------------------------------------------------------
    File        : FactoryOrderModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryOrderModule inherits BusinessComponentModule: 
    
	constructor public FactoryOrderModule (  ):
		super ().
	end constructor.

    /** BUSINESS WORKFLOWS **/
    method protected void LoadEntities():
        define variable cDSName as character extent no-undo.
        define variable cConcreteDS as character extent no-undo.
        define variable cDSTableName as character extent no-undo.                

        assign extent(cDSName) = 1
               extent(cConcreteDS) = 1
               extent(cDSTableName) = 1
               
               cDSName[1] = 'OrderDataSource'
               cConcreteDS[1] = 'AutoEdge.Factory.Order.BusinessComponents.OrderTableDS'
               cDSTableName[1] = 'Order'
               .
        
        BindBusinessEntity(
            'Order', 'AutoEdge.Factory.Order.BusinessComponents.OrderEntity', 'OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter',
            'OrderDA', 'AutoEdge.Factory.Order.BusinessComponents.OrderDA',
            cDSName, cDSTableName, cConcreteDS).
    end method.
    
    method protected void LoadUI():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        oBindingSyntax = Bind(Class:GetClass('AutoEdge.Factory.Order.PresentationLayer.ITaskListManager')).
        oBindingSyntax
            :To('AutoEdge.Factory.Order.PresentationLayer.DealerReview')
            :OnClientSession().
    end method.
    
	method override public void Load(  ):
        LoadEntities().
        LoadUI().
	end method.
	
end class.