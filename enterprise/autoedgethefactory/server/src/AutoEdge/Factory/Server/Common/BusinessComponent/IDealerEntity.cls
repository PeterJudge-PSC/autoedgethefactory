/** ------------------------------------------------------------------------
    File        : IDealerEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 27 14:02:06 EST 2012
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
  
interface AutoEdge.Factory.Server.Common.BusinessComponent.IDealerEntity inherits IBusinessEntity:  

    /** Returns details for a specific dealer
        
        @param character The dealer code 
        @param character The dealer name
        @param character The sales email address for the dealer
        @param character The general info email address  for the dealer
        @param character The street address for the dealer
        @param character The dealer's phone number
        @param character[] An array of salesrep codes for this dealer. */
    method public void GetDealerDetail (input  pcDealerCode as character,
                                        output pcName as character,
                                        output pcSalesEmail as character,
                                        output pcInfoEmail as character,
                                        output pcStreetAddress as character,
                                        output pcPhoneNumber as character,
                                        output pcSalesRep as character extent).
    
end interface.