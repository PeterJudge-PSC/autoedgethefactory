/** ------------------------------------------------------------------------
    File        : OrderEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 16:22:06 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Order.BusinessComponents.OrderEntity inherits StandardBusinessEntity:
     
    define temp-table eOrder no-undo
        field BillingAddressId  as character
        field Carrier           as character
        field Creditcard        as character
        field CustomerId        as character
        field CustomerName      as character
        field CustomerPO        as character
        field EmailDate         as datetime-tz
        field EnteredDate       as datetime 
        field FromEmail         as logical  
        field Instructions      as character
        field InventoryTransId  as character
        field InvoiceId         as character
        field OrderDate         as date     
        field OrderId           as character
        field OrderNum          as integer  
        field PromiseDate       as date     
        field SalesrepId        as character
        field ShipDate          as date     
        field ShippingAddressId as character
/*        field StatusId          as character*/
        field OrderStatus       as character
        field Terms             as character
  
        index idx1 as primary unique OrderId
        index idx2 as unique OrderNum.
        
        
    /*
    define private temp-table eDepartment no-undo 
                  FIELD DeptCode as character
                  FIELD DeptName as character
                  FIELD Manager as integer /*eOrder.empnum */
          index idx1 as primary DeptCode.
    
    define private temp-table eFamily no-undo
                  FIELD BenefitDate       as date    
                  FIELD Birthdate         as date    
                  FIELD CoveredOnBenefits as logical 
                  FIELD EmpNum            as integer 
                  FIELD Relation          as character
                  FIELD RelativeName      as character
          index idx1 as primary EmpNum.
    */
    
    define private dataset dsOrder for eOrder /*, eDepartment, eFamily
        data-relation for eOrder, eDepartment relation-fields (DeptCode, DeptCode)
        data-relation for eOrder, eFamily relation-fields (EmpNum, EmpNum)*/ .

	constructor public OrderEntity ( input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
		super (input poServiceManager, input poComponentInfo).
	end constructor.

	constructor public OrderEntity ( input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo, input poDAO as IDataAccess ):
		super (input poServiceManager, input poComponentInfo, input poDAO).
	end constructor.

    method override protected handle CopyStaticDataset (output dataset-handle phDataset):
        phDataset = dataset dsOrder:handle.  
    end method.

end class.