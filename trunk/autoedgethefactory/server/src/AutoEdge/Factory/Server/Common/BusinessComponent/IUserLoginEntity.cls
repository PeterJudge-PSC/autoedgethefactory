/** ------------------------------------------------------------------------
    File        : IUserLoginEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 24 09:29:46 EDT 2011
    Notes       : 
  ----------------------------------------------------------------------*/
using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.

interface AutoEdge.Factory.Server.Common.BusinessComponent.IUserLoginEntity:
    
    /** Create an application user for a customer
    
        @param character The login name 
        @param character The login password
        @param integer The customer's customer number */
    method public void RegisterCustomer(input pcUserName as character,
                                        input pcPassword as character,
                                        input piCustNum as integer).

    /** Create an application user for an employee
    
        @param character The login name 
        @param character The login password
        @param integer The employee's employee number */    
    method public void RegisterEmployee(input pcUserName as character,
                                        input pcPassword as character,
                                        input piEmpNum as integer).

    /** Create an application user for a supplier
    
        @param character The login name 
        @param character The login password
        @param integer The supplier's unique code */    
    method public void RegisterSupplier(input pcUserName as character,
                                        input pcPassword as character,
                                        input pcSupplierCode as character).

    /** Create an application user for a supplier
    
        @param character The login name 
        @param character The login password
        @param integer The supplier's unique code */    
    method public void RegisterSystemUser(input pcUserName as character,
                                          input pcPassword as character).

    /** Create an general application user 
    
        @param character The login name 
        @param character The login password
        @param UserTypeEnum The Type of user in the system
        @param character A unique value used to link to the user's related record*/    
    method public void RegisterUser(input pcUserName as character,
                                    input pcPassword as character,
                                    input poUserType as UserTypeEnum,
                                    input pcUserCode as character).
                                      
end interface.