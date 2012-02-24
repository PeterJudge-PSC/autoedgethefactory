/** ------------------------------------------------------------------------
    File        : ICustomerEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 24 09:25:48 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.

interface AutoEdge.Factory.Server.Common.BusinessComponent.ICustomerEntity inherits IBusinessEntity:  
  
    /** Registers a customer. 
        
        @param character A customer name
        @param character A contact email address
        @param character The Customer's primary dealer
        @return integer The customer number for the new customer. */
    method public integer RegisterCustomer(input pcName as character,
                                           input pcEmail as character,
                                           input pcDealerCode as character).
    
    /** Returns a salesrep code for a given customer.
    
        @param integer The customer number
        @return character The salesrep code */                                           
    method public character GetCustomerSalesrep(input piCustNum as integer).                                           
                                           
  
end interface.