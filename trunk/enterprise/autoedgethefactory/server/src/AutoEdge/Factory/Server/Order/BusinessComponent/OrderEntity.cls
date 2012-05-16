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

using AutoEdge.Factory.Server.Order.BusinessComponent.IOrderEntity.

using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.RowStateEnum.
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Server.Order.BusinessComponent.OrderEntity inherits StandardBusinessEntity
    implements IOrderEntity:
        
    define temp-table eOrder no-undo before-table beOrder
        field OrderNum      as integer
        field OrderId       as character
        field OrderDate     as date
        field EnteredDate   as datetime
        field FromEmail     as logical

        field CustomerNum   as integer
        field CustomerName  as character
        field CustomerPO    as character
        
        field OrderAmount   as decimal
        field OrderStatus   as character
        field Instructions  as character
        
        field SalesrepCode  as character
        field DealerCode    as character
        
        index idx1 as primary unique Orderid
        index idx2 as unique OrderNum.

    /* one-to-one map to eOrder */
    define temp-table eOrderPayment no-undo before-table beOrderPayment
        field OrderNum          as integer
        field PromiseDate       as date
        field InvoiceNum        as character
        field ShipDate          as date
        field Terms             as character
        field ShippingAddressId as character
        field BillingAddressId  as character
        field Carrier           as character
        field Creditcard        as character
        
        index idx1 as primary unique OrderNum.
    
    @todo(task="refactor", action="merge OrderLine and FinishedItem and Item into single BE table? ").
    define temp-table eOrderLine no-undo before-table beOrderLine
        field OrderId           as character
        field LineNum           as integer
        field Price             as decimal
        field Quantity          as integer
        field Discount          as integer
        field ItemId            as character
        field OrderLineStatus   as character
        field FinishedItemId    as character
        index idx1 as primary unique OrderId LineNum.
    
    define temp-table eFinishedItem no-undo before-table beFinishedItem
        field FinishedItemId as character
        field ItemId as character
        field StatusDate as datetime
        field FinishedItemStatus as character
        field ExternalId as character   /* This is likely to be the VIN */
        index idx1 as primary unique FinishedItemId.
    
    @todo(task="refactor", action="merge ComponentItem and Item into single BE table? ").
    define temp-table eComponentItem no-undo before-table beComponentItem
        field ItemId as character
        field FinishedItemId as character
        field Quantity as decimal
        index idx1 as primary unique FinishedItemId ItemId 
        index idx2 FinishedItemId
        .
    
    define temp-table eItem no-undo before-table beItem
        field ItemId as character
        field ItemNum as integer
        field ItemName as character
        field ItemType as character
        field Description as character
        field Price as decimal
        index idx1 as primary unique ItemId
        index idx2 as unique ItemNum
        .

    define private dataset dsOrder for eOrder, /*eOrderPayment,*/ eOrderLine, eFinishedItem, eItem, eComponentItem 
        data-relation for eOrder, eOrderLine relation-fields (OrderId, OrderId)
        data-relation for eOrderLine, eItem relation-fields (ItemId, ItemId)
        data-relation for eOrderLine, eFinishedItem relation-fields (FinishedItemId, FinishedItemId)
        data-relation for eFinishedItem, eComponentItem relation-fields (FinishedItemId, FinishedItemId)
        .
    
    define override protected property DatasetHandle as handle no-undo        
        get():
            if not valid-handle(DatasetHandle) then
               DatasetHandle = dataset dsOrder:handle.
               
            return DatasetHandle.
        end get.
        set.    

    constructor public OrderEntity(input poComponentInfo as IComponentInfo ):
        super (input poComponentInfo).
    end constructor.

    constructor public OrderEntity(input poComponentInfo as IComponentInfo, input poDAO as IDataAccess ):
        super(input poComponentInfo, input poDAO).
    end constructor.

    method override protected void BeforeSaveData(input poRequest as ISaveRequest):
		super:BeforeSaveData(input poRequest).
		
        for each eComponentItem:
            message eComponentItem.ItemId eComponentItem.Quantity
                view-as alert-box.
	   end.
	end method.
	
    method override public IFetchResponse GetData(input pcMessageId as longchar ):
        define variable oResponse as IFetchResponse no-undo.
        define variable dLineTotal as decimal no-undo.
        
        oResponse = super:GetData(input pcMessageId).

        /* Aggregate order total */
        for each eOrderLine,
            first eOrder where eOrder.OrderId eq eOrderLine.OrderId:
            
            dLineTotal = eOrderLine.Price * eOrderLine.Quantity.
            if eOrderLine.Discount gt 0 then
                dLineTotal = dLineTotal - (eOrderLine.Discount * dLineTotal / 100).
            
            eOrder.OrderAmount = eOrder.OrderAmount + dLineTotal.
        end.
        return oResponse.        
	end method.

    method protected void BindReceivedDataset( input dataset dsOrder bind):
        /* no body needed. the parameter passing does what we need. */
    end method.

    method override protected void ReceiveDataset(input phDataset as handle):
        BindReceivedDataset(dataset-handle phDataset).
    end method.
    
    method public integer GetOrderNumFromId( input pcOrderId as character ):
        define variable oRequest as IFetchRequest no-undo.
        define variable cTableName as character no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        
        oRequest = new FetchRequest('Order').
        
        cTableName = 'eOrder'.
        oTableRequest = new TableRequest(cTableName).
        oRequest:TableRequests:Put(cTableName, oTableRequest).
        oTableRequest:AddFilter(cTableName,
                                'OrderId',
                                OperatorEnum:IsEqual,
                                new String(pcOrderId),
                                DataTypeEnum:Character,
                                JoinEnum:And).
        FetchData(oRequest).
                     
        find first eOrder where eOrder.OrderId eq pcOrderId no-error.
        if available eOrder then
            return eOrder.OrderNum .
	end method.
	
	method public void UpdateFinishedItemStatus( input piOrderNum as integer, input piLineNum as integer, input pcStatusCode as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.
	method public void UpdateOrderLineStatus( input piOrderNum as integer, input piLineNum as integer, input pcStatusCode as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.
	method public void UpdateOrderStatus( input piOrderNum as integer, input pcStatusCode as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.
	
/**  Creates a vehicle order
    
        @param integer The order number 
        @param character The dealer servicing this order
        @param integer The customer placing this order
        @param logical Is the order approved 
        @parma longchar Additional instructions
        @param longchar The opaque id of the model
        @param longchar The opaque id of the trim material
        @param longchar The opaque id of the trim colour
        @param longchar[] The opaque ids of any accessories
        @param longchar The opaque id of the paint colour
        @param longchar The opaque id of the moonroof option
        @param longchar The opaque id of the wheels selected  
        @return character the opaque id of the newly-created order.*/
    method public character CreateOrder(input piOrderNum as integer,
                                      input pcDealerCode as character,
                                      input pcSalesrepCode as character,
                                      input piCustomerNumber as integer,
                                      input plOrderApproved as logical,
                                      input pcInstructions as longchar,
                                      input pcModelId as character,
                                      input pcInteriorTrimMaterial as character,
                                      input pcInteriorTrimColour as character,
                                      input pcInteriorAccessories as character extent,
                                      input pcExteriorColour as character,
                                      input pcMoonroof as character,
                                      input pcWheels as character):
        define variable cOrderId as character no-undo.
        define variable cFinishedItemId as character no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable dOrderAmount as decimal no-undo.
        define variable oSaveResponse as ISaveResponse no-undo.
                                 
        Assert:ArgumentNotNullOrEmpty(pcModelId, 'Model').
        Assert:ArgumentNotNullOrEmpty(pcDealerCode, 'Dealer').
        Assert:ArgumentNotZero(piOrderNum, 'Order Number').
                                                                    
        EnableDatasetForUpdate().
        
        create eOrder.
        assign cOrderId = guid(generate-uuid)
               eOrder.OrderNum = piOrderNum
               eOrder.OrderId = cOrderId
               eOrder.EnteredDate = now
               eOrder.OrderDate = today
               eOrder.DealerCode = pcDealerCode
               eOrder.Salesrepcode = pcSalesrepCode
               eOrder.OrderStatus = 'ORDER-NEW'
               eOrder.CustomerNum = piCustomerNumber
               eOrder.Instructions = pcInstructions.
            
        create eFinishedItem.
        assign
            cFinishedItemId = guid(generate-uuid)
            eFinishedItem.FinishedItemId = cFinishedItemId
            eFinishedItem.ItemId = pcModelId
            eFinishedItem.StatusDate = now
            eFinishedItem.FinishedItemStatus = 'ORDER-NEW'.

        /* orderline */
        create eOrderLine.
        assign
            eOrderLine.OrderId = cOrderId
            eOrderLine.LineNum = 1
            eOrderLine.Quantity = 1
            eOrderLine.ItemId = pcModelId
            eOrderLine.FinishedItemId = cFinishedItemId
            eOrderLine.OrderLineStatus = 'ORDER-NEW'.
            
        /* components */
        CreateComponentItem(cFinishedItemId, pcInteriorTrimColour, 1).
        CreateComponentItem(cFinishedItemId, pcInteriorTrimMaterial, 1).
        CreateComponentItem(cFinishedItemId, pcExteriorColour, 1).
        CreateComponentItem(cFinishedItemId, pcWheels, 1).
        CreateComponentItem(cFinishedItemId, pcMoonroof, 1).
            
        iMax = extent(pcInteriorAccessories).
        do iLoop = 1 to iMax:
            CreateComponentItem(cFinishedItemId, pcInteriorAccessories[iLoop], 1).
        end.
        
        DisableDatasetForUpdate().
        oSaveResponse = SaveData(BuildSaveRequest()).
        
        CheckForSaveError(oSaveResponse).
        
        return cOrderId.                
    end method.
    
    method private void CreateComponentItem (input pcFinishedItemId as character,
                                             input pcItemId as character,
                                             input pdQuantity as decimal):    
        if pcItemId eq '' or pcItemId eq ? or pcItemId eq '<NULL>' then
            return.
                
        find first eComponentItem where
                   eComponentItem.ItemId eq pcItemId and
                   eComponentItem.FinishedItemId eq pcFinishedItemId
                   no-error.
        if not available eComponentItem then
        do:
            create eComponentItem.
            assign eComponentItem.ItemId = pcItemId
                   eComponentItem.FinishedItemId = pcFinishedItemId.
        end.
        eComponentItem.Quantity = eComponentItem.Quantity + pdQuantity.
    end method.
    
    /** Returns the amount of an order.
    
        @param integer The order ide
        @return decimal The order amount  */
    method public decimal GetOrderAmount(input piOrderNum as integer):
        define variable oRequest as IFetchRequest no-undo.
        define variable cTableName as character no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        
        if not IsOrderCached(piOrderNum) then
        do:
            oRequest = new FetchRequest('Order').
            
            cTableName = 'eOrder'.
            oTableRequest = new TableRequest(cTableName).
            oRequest:TableRequests:Put(cTableName, oTableRequest).
            oTableRequest:AddFilter(cTableName,
                                    'OrderNum',
                                    OperatorEnum:IsEqual,
                                    new String(string(piOrderNum)),
                                    DataTypeEnum:Integer,
                                    JoinEnum:And).
            FetchData(oRequest).
        end.
                     
        find first eOrder where eOrder.OrderNum eq piOrderNum no-error.
        if available eOrder then
            return eOrder.OrderAmount.
    end method.
    
    method private logical IsOrderCached (input piOrderNum as integer):
        find eOrder where eOrder.OrderNum eq piOrderNum no-error.
        return available eOrder.
    end method.
    
end class.