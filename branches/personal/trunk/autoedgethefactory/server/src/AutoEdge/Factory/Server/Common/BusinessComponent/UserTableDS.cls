/** ------------------------------------------------------------------------
    File        : UserTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 10:08:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using AutoEdge.Factory.Common.CommonInfrastructure.UserTypeEnum.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataSource.DataSourceQuery.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.IQueryDefinition.

using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Server.Common.BusinessComponent.UserTableDS use-widget-pool inherits StandardDataSource: 
    define override protected property PrimaryTable as handle no-undo 
        get():
            if not valid-handle(PrimaryTable) then
                PrimaryTable = buffer ApplicationUser:handle.
            return PrimaryTable.
        end get.
    set.
    
    constructor public UserTableDS(input poComponentInfo as IComponentInfo):
        super (input poComponentInfo).
    end constructor.
    
    method override protected void CreateDataStore():
        define variable hABLDataSource as handle no-undo.
        define variable hUserBuffer as handle no-undo.
        define variable hLocaleBuffer as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
        
        create data-source hABLDataSource.
        oDSQuery = new DataSourceQuery(hABLDataSource).
        ABLDataSources:Put(ServiceMessageActionEnum:FetchData, oDSQuery).
        
        create buffer hUserBuffer for table buffer ApplicationUser:handle
                buffer-name substitute('ApplicationUser_&1-&2',
                             string(hABLDataSource),
                             string(int(ServiceMessageActionEnum:FetchData))).
        hABLDataSource:add-source-buffer(hUserBuffer, hUserBuffer:keys).
        
        create buffer hLocaleBuffer for table buffer Locale:handle
                buffer-name substitute('Locale_&1-&2',
                             string(hABLDataSource),
                             string(int(ServiceMessageActionEnum:FetchData))).
        
        hABLDataSource:add-source-buffer(hLocaleBuffer, hLocaleBuffer:keys).
        oDSQuery:Definition:AddJoin('ApplicationUser', 'LocaleId',
                                    OperatorEnum:IsEqual,
                                    'Locale', 'LocaleId',
                                    JoinEnum:And).
        
        /* We're ready to parse the ABLDatasource and construct the query definition.
            
           This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        cast(oDSQuery, DataSourceQuery):Initialize().

        create data-source hABLDataSource.
        oDSQuery = new DataSourceQuery(hABLDataSource).
        ABLDataSources:Put(ServiceMessageActionEnum:SaveData, oDSQuery).
        
        create buffer hUserBuffer for table buffer ApplicationUser:handle
                buffer-name substitute('ApplicationUser_&1-&2',
                             string(hABLDataSource),
                             string(int(ServiceMessageActionEnum:SaveData))).
        hABLDataSource:add-source-buffer(hUserBuffer, hUserBuffer:keys).
        
        create buffer hLocaleBuffer for table buffer Locale:handle
                buffer-name substitute('Locale_&1-&2',
                             string(hABLDataSource),
                             string(int(ServiceMessageActionEnum:SaveData))).
        
        hABLDataSource:add-source-buffer(hLocaleBuffer, hLocaleBuffer:keys).
        oDSQuery:Definition:AddJoin('ApplicationUser', 'LocaleId',
                                    OperatorEnum:IsEqual,
                                    'Locale', 'LocaleId',
                                    JoinEnum:And).
        
        /* We're ready to parse the ABLDatasource and construct the query definition.
            
           This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        cast(oDSQuery, DataSourceQuery):Initialize().
        
        super:CreateDataStore().
    end method.

    method override protected void AttachDataStoreToTarget(input poServiceMessageAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        define variable hLocaleBuffer as handle no-undo.
        define variable oDSQuery as DataSourceQuery no-undo.
        
/*
        case poServiceMessageAction:
            when ServiceMessageActionEnum:FetchData then
            do:
*/
                oDSQuery = cast(ABLDataSources:Get(poServiceMessageAction), DataSourceQuery). 
                hABLDataSource = oDSQuery:ABLDataSource. 
                hABLDataSource:prefer-dataset = true.
                hLocaleBuffer = oDSQuery:GetTableBuffer('Locale').
                
                TargetBuffer:attach-data-source(hABLDataSource,
                        substitute('&1.LocaleName,&2.Name',
                                    TargetBuffer:name,
                                    hLocaleBuffer:name)).
                
                AttachedActions:Add(poServiceMessageAction).
    end method.
    
    method override protected void UpdateForeignKeys( input phDbBuffer as handle, input phSourceBuffer as handle ):
        define variable oUserType as UserTypeEnum no-undo.

        define buffer lbLocale for Locale.
        define buffer lbTenant for Tenant.
        define buffer lbCustomer for Customer.
        define buffer lbEmployee for Employee.
        define buffer lbSupplier for Supplier.
        
		super:UpdateForeignKeys(input phDbBuffer, input phSourceBuffer).
		
        find lbLocale where
             lbLocale.Name eq phSourceBuffer:after-buffer::LocaleName
             no-lock no-error.
        /* default to the Tenant locale */
        if not available lbLocale then
        do:
            find lbTenant where
                 lbTenant.TenantId eq phDbBuffer::TenantId
                 no-lock no-error.
            phDbBuffer::PrimaryLocaleId = lbTenant.LocaleId.                
        end.
        
        case UserTypeEnum:EnumFromString(phSourceBuffer:after-buffer::LocaleName):
            when UserTypeEnum:Customer then
            do:
                find lbCustomer where
                     lbCustomer.TenantId eq phDbBuffer::TenantId and
                     lbCustomer.CustNum eq int(phSourceBuffer:after-buffer::UserCode)
                     no-lock no-error.
                if available lbCustomer then
                    phDbBuffer::CustomerId = lbCustomer.CustomerId.                     
            end.
            when UserTypeEnum:Employee then
            do:
                find lbEmployee where
                     lbEmployee.TenantId eq phDbBuffer::TenantId and
                     lbEmployee.EmpNum eq int(phSourceBuffer:after-buffer::UserCode)
                     no-lock no-error.
                if available lbEmployee then
                    phDbBuffer::EmployeeId = lbEmployee.EmployeeId.                     
            end.
            when UserTypeEnum:Supplier then
            do:
                find lbSupplier where
                     lbSupplier.Code eq phSourceBuffer:after-buffer::UserCode
                     no-lock no-error.
                if available lbSupplier then
                    phDbBuffer::SupplierId = lbSupplier.SupplierId.
            end.
        end case.
    end method.
    
end class.