/** ------------------------------------------------------------------------
    File        : IRegisterCustomerTask
    Purpose     : Specialised itnerface for the register customer task 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 24 10:57:30 EDT 2011
    Notes       : 
  --------------------------------------------------------------------- */

interface AutoEdge.Factory.Server.Common.BusinessComponent.IRegisterCustomerTask:  

    /** Register a customer.
    
        This method currently uses output parameters; the inputs and outputs could be
        generalised but we choose not to do this here, for clarity.
        
        
        @param character The customer name
        @param character The user name
        @param character The password
        @param character The email address
        @param character The customer's dealer code
        @param integer-output The customer num
        @param character-output The salesrep for this customer. */
    method public void RegisterCustomer(input pcCustomerName as character,
                                        input pcUserName as character,
                                        input pcPassword as character,
                                        input pcCustomerEmail as character,
                                        input pcDealerCode as character,
                                        output piCustNum as integer,
                                        output pcSalesRep as character).
    
end interface.