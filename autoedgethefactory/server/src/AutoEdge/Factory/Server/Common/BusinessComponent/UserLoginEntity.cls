/** ------------------------------------------------------------------------
    File        : UserLoginEntity
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 10:06:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.
using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using AutoEdge.Factory.Server.Common.BusinessComponent.IUserLoginEntity.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Lang.Assert.
class AutoEdge.Factory.Server.Common.BusinessComponent.UserLoginEntity inherits StandardBusinessEntity
        implements IUserLoginEntity:
    define private temp-table eUserLogin no-undo
        field ApplicationUserId as character
        field UserCategory      as character    /* supplier/customer/employee */
        field UserCode          as character    /* SuppNum/CustNum/EmpNum */
        field LastLoginDate     as datetime-tz
        field LastLoginLocation as character
        field LocaleName        as character
        field LoginName         as character
        field LoginDomain       as character
        field Password          as character
        index idx1 as primary LoginDomain LoginName 
        .
    
    define private dataset dsUser for eUserLogin.        
    
    define override protected property DatasetHandle as handle no-undo        
        get():
            if not valid-handle(DatasetHandle) then
               DatasetHandle = dataset dsUser:handle.
               
            return DatasetHandle.
        end get.
        set.
    constructor public UserLoginEntity(input poComponentInfo as IComponentInfo ):
        super(input poComponentInfo).
    end constructor.
        
    constructor public UserLoginEntity(input poComponentInfo as IComponentInfo, input poDAO as IDataAccess ):
        super(input poComponentInfo, input poDAO).
    end constructor.

    method protected void BindReceivedDataset( input dataset dsUser bind):
        /* no body needed. the parameter passing does what we need. */
    end method.
    method override protected void ReceiveDataset(input phDataset as handle):
        BindReceivedDataset(dataset-handle phDataset).
    end method.
    
    /** Create an application user for a customer
    
        @param character The login name 
        @param character The login password
        @param integer The customer's customer number */
    method public void RegisterCustomer(input pcUserName as character,
                                        input pcPassword as character,
                                        input piCustNum as integer):
        Assert:ArgumentNotNullOrZero(piCustNum, 'Customer Number').
        RegisterUser(pcUserName, pcPassword, UserTypeEnum:Employee, string(piCustNum)).                                            
    end method.

    /** Create an application user for an employee
    
        @param character The login name 
        @param character The login password
        @param integer The employee's employee number */    
    method public void RegisterEmployee(input pcUserName as character,
                                        input pcPassword as character,
                                        input piEmpNum as integer):
        Assert:ArgumentNotNullOrZero(piEmpNum, 'Employee Number').
        RegisterUser(pcUserName, pcPassword, UserTypeEnum:Employee, string(piEmpNum)).                                  
    end method.

    /** Create an application user for a supplier
    
        @param character The login name 
        @param character The login password
        @param integer The supplier's unique code */    
    method public void RegisterSupplier(input pcUserName as character,
                                        input pcPassword as character,
                                        input pcSupplierCode as character):
        Assert:ArgumentNotNullOrEmpty(pcPassword, 'Supplier Code').
        RegisterUser(pcUserName, pcPassword, UserTypeEnum:Employee, pcSupplierCode).
    end method.
    
    /** Create an application user for a supplier
    
        @param character The login name 
        @param character The login password
        @param integer The supplier's unique code */    
    method public void RegisterSystemUser(input pcUserName as character,
                                          input pcPassword as character):
    end method.

    /** Create an general application user 
    
        @param character The login name 
        @param character The login password
        @param UserTypeEnum The Type of user in the system
        @param character A unique value used to link to the user's related record*/    
    method public void RegisterUser(input pcUserName as character,
                                    input pcPassword as character,
                                    input poUserType as UserTypeEnum,
                                    input pcUserCode as character):
        define variable cLoginDomain as character no-undo.
        define variable cBrand as character no-undo.

        Assert:ArgumentNotNullOrEmpty(pcUserName, 'User Name').
        Assert:ArgumentNotNullOrEmpty(pcPassword, 'Password').
        Assert:ArgumentNotNull(poUserType, 'User Type').
        
        cLoginDomain = substitute('&1.&2',
                                  UserTypeEnum:Customer:ToString(),
                                  cBrand).
        EnableDatasetForUpdate().
        
        create eUserLogin.
        assign eUserLogin.LoginName = pcUserName
               eUserLogin.Password = pcPassword
               eUserLogin.UserCategory = poUserType:ToString()
               eUserLogin.LoginDomain = cLoginDomain
               eUserLogin.UserCode = pcUserCode
               .
        DisableDatasetForUpdate().
        
        SaveData(BuildSaveRequest()).
    end method.
end class.