/** ------------------------------------------------------------------------
    File        : CustomerEntity
    Purpose     : Entity for customers
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 16 09:50:15 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Server.Common.BusinessComponent.ICustomerEntity.

using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.TableRequestTypeEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceRequestError.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Lang.String.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.Assert.

class AutoEdge.Factory.Server.Common.BusinessComponent.CustomerEntity inherits StandardBusinessEntity
        implements ICustomerEntity:

    define temp-table eCustomer no-undo before-table eCustomerBefore
        field CustomerId as character serialize-hidden
        field CustNum as integer
        field Name as character
        
        field CreditLimit as decimal
        field Balance as decimal
        field Terms as character
        field Discount as integer
        
        field SalesrepCode  as character
        field DealerCode    as character
        
        field PrimaryLocale as character
        field Language as character
        index idx1 as primary unique CustomerId
        index idx2 as unique CustNum.
    
    define temp-table eAddress no-undo before-table eAddressBefore
        field CustomerId as character serialize-hidden
        field AddressType as character
        field AddressLine1 as character
        field AddressLine2 as character
        field City as character
        field PostalCode as character
        field State as character
        field CountryCode as character
        field CountryName as character 
        index idx1 as primary unique CustomerId AddressType
        .
    
    define temp-table eContact no-undo before-table eContactBefore
        field CustomerId as character serialize-hidden
        field ContactType as character
        field ContactDetail as character
        index idx1 as primary unique CustomerId ContactType
        .
               
    define dataset dsCustomer for eCustomer, eAddress, eContact
        data-relation for eCustomer, eAddress relation-fields (CustomerId, CustomerId)
        data-relation for eCustomer, eContact relation-fields (CustomerId, CustomerId)
        .
    
    define override protected property DatasetHandle as handle no-undo
        get():
            if not valid-handle(DatasetHandle) then
               DatasetHandle = dataset dsCustomer:handle.
            
            return DatasetHandle.
        end get.
        set.
    
	constructor public CustomerEntity (input poComponentInfo as IComponentInfo):
		super(input poComponentInfo).
	end constructor.
		
	constructor public CustomerEntity(input poComponentInfo as IComponentInfo, input poDAO as IDataAccess):
		super(input poComponentInfo, input poDAO).
	end constructor.
	
	method override protected void BeforeSaveData(input poRequest as ISaveRequest):
		super:BeforeSaveData(input poRequest).
	end method.

    method protected void BindReceivedDataset( input dataset dsCustomer bind):
        /* no body needed. the parameter passing does what we need. */
    end method.

    method override protected void ReceiveDataset(input phDataset as handle):
        BindReceivedDataset(dataset-handle phDataset).
    end method.
    
    /** Registers a customer. 
        
        @param character A customer name
        @param character A contact email address
        @param character The Customer's primary dealer
        @return integer The customer number for the new customer. */
    method public integer RegisterCustomer(input pcName as character,
                                           input pcEmail as character,
                                           input pcDealerCode as character):
        define variable oSaveResponse as ISaveResponse no-undo.
        
        EnableDatasetForUpdate().
        
        create eCustomer.
        assign eCustomer.Name = pcName
               eCustomer.CustomerId = '-1'
               eCustomer.DealerCode = pcDealerCode.
        
        create eContact.
        assign eContact.CustomerId = eCustomer.CustomerId
               eContact.ContactType = 'email-home'
               eContact.ContactDetail = pcEmail.
        
        DisableDatasetForUpdate().
        
        oSaveResponse = SaveData(BuildSaveRequest()).
        CheckForSaveError(oSaveResponse).
        
        /* Should be only one here */
        find first eCustomer no-error.
        Assert:ArgumentIsAvailable(buffer eCustomer:handle, 'New Customer').
        
        return eCustomer.CustNum.
    end method.
    
    /** Returns a salesrep code for a given customer.
    
        @param integer The customer number
        @return character The salesrep code */                                           
    method public character GetCustomerSalesrep(input piCustNum as integer):
        define variable oFetchRequest as IFetchRequest no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable cTableName as character no-undo.
        
        oFetchRequest = new FetchRequest(this-object:ComponentInfo:InstanceName).
        cTableName = 'eCustomer'.
        oTableRequest = new TableRequest(cTableName).
        oTableRequest:TableRequestType = TableRequestTypeEnum:NoChildren.
        oFetchRequest:TableRequests:Put(cTableName, oTableRequest).
        
        cast(oTableRequest, IQueryDefinition):AddFilter(cTableName,
                                              'CustNum',
                                              OperatorEnum:IsEqual,
                                              new String(string(piCustNum)),
                                              DataTypeEnum:Character,
                                              JoinEnum:And).
        FetchData(oFetchRequest).
        
        find eCustomer where 
             eCustomer.CustNum eq piCustNum
             no-error.
        Assert:ArgumentIsAvailable(buffer eCustomer:handle, 'Customer').
        
        return eCustomer.SalesrepCode.                                         
    end method.
    
end class.