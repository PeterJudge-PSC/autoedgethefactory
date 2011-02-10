/** ------------------------------------------------------------------------
    File        : ServerOrderModule
    Purpose     : Server-side Order bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class AutoEdge.Factory.Server.InjectABL.OrderModule inherits BusinessComponentModule: 
    
    constructor public OrderModule (  ):
        super ().
    end constructor.

    /** BUSINESS WORKFLOWS **/
    method protected void LoadEntities():
        define variable cDSName as character extent no-undo.
        define variable cConcreteDS as character extent no-undo.
        define variable cDataSourceKey as character extent no-undo.
                        
        /* Order vehicle */
        assign extent(cDSName) = 1
               extent(cConcreteDS) = 1
               extent(cDataSourceKey) = 1
               
               cDSName[1] = 'OrderDataSource'
               cConcreteDS[1] = 'AutoEdge.Factory.Server.Order.BusinessComponent.OrderTableDS'
               cDataSourceKey[1] = 'eOrder'
               .
        
        BindBusinessEntity(
            'Order', 'AutoEdge.Factory.Server.Order.BusinessComponent.OrderEntity',
            'OrderDA', 'AutoEdge.Factory.Server.Order.BusinessComponent.OrderDA',
            cDSName, cDataSourceKey, cConcreteDS).

        /* Vehicle Brand data */
        assign extent(cDSName) = ?
               extent(cConcreteDS) = ?
               extent(cDataSourceKey) = ?
        
               extent(cDSName) = 3
               extent(cConcreteDS) = extent(cDSName)
               extent(cDataSourceKey) = extent(cDSName)
               
               cDSName[1] = 'VehicleDataSource'
               cDataSourceKey[1] = 'eVehicle'
               cConcreteDS[1] = 'AutoEdge.Factory.Server.Order.BusinessComponent.VehicleDataSource'
               
               cDSName[2] = 'ItemDataSource'
               cDataSourceKey[2] = 'eItem'
               cConcreteDS[2] = 'AutoEdge.Factory.Server.Order.BusinessComponent.ItemTableDS'
               
               cDSName[3] = 'ItemOptionsDataSource'
               cDataSourceKey[3] = 'eItemOption'
               cConcreteDS[3] = 'AutoEdge.Factory.Server.Order.BusinessComponent.ItemOptionTableDS'
               .
        
        BindBusinessEntity(
            'VehicleOptions', 'AutoEdge.Factory.Server.Order.BusinessComponent.VehicleOptionsEntity',
            'VehicleOptionsDA', 'AutoEdge.Factory.Server.Order.BusinessComponent.VehicleOptionsDA',
            cDSName, cDataSourceKey, cConcreteDS).

    end method.
    
    method override public void Load(  ):
        LoadEntities().
    end method.
    
end class.