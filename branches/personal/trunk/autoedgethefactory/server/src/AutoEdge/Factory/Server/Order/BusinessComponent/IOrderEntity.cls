/** ------------------------------------------------------------------------
    File        : IOrderEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jun 28 10:45:17 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.

interface AutoEdge.Factory.Server.Order.BusinessComponent.IOrderEntity inherits IBusinessEntity:
  
    /** Returns an ordernumber given an OrderId
        
        @param character An opaque id for an order
        @return integer The corresponding order number */    
    method public integer GetOrderNumFromId(input pcOrderId as character).
    
    /** Returns the amount of an order.
    
        @param integer The order number
        @return decimal The order amount     */
    method public decimal GetOrderAmount(input piOrderNum as integer).

    /** Updates the status of an orderline's finished item 
        
        @param integer The order number
        @param integer The orderline number
        @param character The status of the finished item */
    method public void UpdateFinishedItemStatus(input piOrderNum as integer,
                                                input piLineNum as integer,
                                                input pcStatusCode as character).
                                                
    /** Updates the status of an orderline 
        
        @param integer The order number
        @param integer The orderline number
        @param character The status of the orderline */        
    method public void UpdateOrderLineStatus(input piOrderNum as integer,
                                             input piLineNum as integer,
                                             input pcStatusCode as character).
                                                    
    /** Updates the status of an order header 
        
        @param integer The order number
        @param character The status of the orderline */        
    method public void UpdateOrderStatus(input piOrderNum as integer,
                                         input pcStatusCode as character).
                                         
    /**  Creates a vehicle order
    
        @param integer The order number 
        @param character The dealer servicing this order
        @param character The salesrep placing this order
        @param integer The customer placing this order
        @param logical Is the order approved 
        @parma longchar Additional instructions
        @param character The opaque id of the model
        @param character The opaque id of the trim material
        @param character The opaque id of the trim colour
        @param character[] The opaque ids of any accessories
        @param character The opaque id of the paint colour
        @param character The opaque id of the moonroof option
        @param character The opaque id of the wheels selected  
        @return character The order id */
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
                                      input pcWheels as character).
    
end interface.