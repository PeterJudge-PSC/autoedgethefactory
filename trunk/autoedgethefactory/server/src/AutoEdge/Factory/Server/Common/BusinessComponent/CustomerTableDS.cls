/** ------------------------------------------------------------------------
    File        : CustomerTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jun 16 11:02:20 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataSource.DataSourceQuery.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.IQuery.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.

class AutoEdge.Factory.Server.Common.BusinessComponent.CustomerTableDS inherits StandardDataSource: 

    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                create buffer PrimaryTable for table buffer Customer:handle.
            
            return PrimaryTable.
        end get.
        set.

	constructor public CustomerTableDS ( input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
	end constructor.

    method override protected void CreateDataStore():
        define variable hABLDataSource as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
        define variable hCustomerBuffer as handle no-undo.
        define variable hSalesrepBuffer as handle no-undo.
        define variable hEmployeeBuffer as handle no-undo.
        define variable hDealerBuffer as handle no-undo.
        define variable hLocaleBuffer as handle no-undo.

        create data-source hABLDataSource.
        oDSQuery = new DataSourceQuery(hABLDataSource).
        ABLDataSources:Put(ServiceMessageActionEnum:FetchData, oDSQuery).
        
        /* Make sure we have a uniquely-named buffer, for those cases where this datasource object's instances' 
           lifecycles overlap. The ABL requires only a single named buffer/data-source set at a time. */
        create buffer hCustomerBuffer for table buffer Customer:handle
            buffer-name substitute('Customer_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).
        
        hABLDataSource:add-source-buffer(hCustomerBuffer, hCustomerBuffer:keys).

        create buffer hSalesrepBuffer for table buffer Salesrep:handle
            buffer-name substitute('Salesrep_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hSalesrepBuffer, hSalesrepBuffer:keys).
        oDSQuery:Definition:AddJoin(hSalesrepBuffer:name, 'SalesrepId',
                                    OperatorEnum:IsEqual,
                                    hCustomerBuffer:name, 'SalesrepId',
                                    JoinEnum:And).

        create buffer hEmployeeBuffer for table buffer Employee:handle
            buffer-name substitute('Employee_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hEmployeeBuffer, hEmployeeBuffer:keys).
        oDSQuery:Definition:AddJoin(hEmployeeBuffer:name, 'EmployeeId',
                                    OperatorEnum:IsEqual,
                                    hSalesrepBuffer:name, 'EmployeeId',
                                    JoinEnum:And).
        
        create buffer hDealerBuffer for table buffer Dealer:handle
            buffer-name substitute('Dealer_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hDealerBuffer, hDealerBuffer:keys).
        oDSQuery:Definition:AddJoin(hDealerBuffer:name, 'DealerId',
                                    OperatorEnum:IsEqual,
                                    hEmployeeBuffer:name, 'DealerId',
                                    JoinEnum:And).

        create buffer hLocaleBuffer for table buffer Locale:handle
            buffer-name substitute('Locale_&1-&2',
                         string(hABLDataSource),
                         string(int(ServiceMessageActionEnum:FetchData))).

        hABLDataSource:add-source-buffer(hLocaleBuffer, hLocaleBuffer:keys).
        oDSQuery:Definition:AddJoin(hCustomerBuffer:name, 'PrimaryLocaleId',
                                    OperatorEnum:IsEqual,
                                    hLocaleBuffer:name, 'LocaleId',
                                    JoinEnum:And).
        
        /* We're ready to parse the ABLDatasource and construct the query definition.
               
           This is the query definition we'll always use. There should not be any user- or request- specific
           filtering/joining in this definition, since we don't know what the lifespan of this datasource object 
           is. The SaveData or FetchData request will be done on the behest of a user and so will add it's own 
           filters (like tenancy) to the query that is used to service the request. */
        cast(oDSQuery, DataSourceQuery):Initialize().
        
        /* let the simple save be created */        
        super:CreateDataStore().
    end method.
    
    method override protected void AttachDataStoreToTarget(input poAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        define variable hCustomerBuffer as handle no-undo.
        define variable hSalesrepBuffer as handle no-undo.
        define variable hDealerBuffer as handle no-undo.
        define variable hLocaleBuffer as handle no-undo.
        define variable oDSQuery as DataSourceQuery no-undo.
        define variable cPairsList as character no-undo.
        
        case poAction:
            when ServiceMessageActionEnum:FetchData then
            do:
                oDSQuery = cast(ABLDataSources:Get(poAction), DataSourceQuery).
                hCustomerBuffer = oDSQuery:GetTableBuffer('Customer').
                hSalesrepBuffer = oDSQuery:GetTableBuffer('Salesrep').
                hDealerBuffer = oDSQuery:GetTableBuffer('Dealer').
                hLocaleBuffer = oDSQuery:GetTableBuffer('Locale').
                
                @todo(task="implement", action="validate that the target buffer fields exist in the target buffer").
                /* &1 is the eCustomer/TargetBuffer; aka businessentity Customer table*/
                cPairsList = '&1.SalesrepCode,&2.Code'
                           + ',&1.DealerCode,&3.Code'
                           + ',&1.PrimaryLocale,&4.Name'.
                
                hABLDataSource = oDSQuery:ABLDataSource.
                hABLDataSource:prefer-dataset = true.
                this-object:TargetBuffer:attach-data-source(hABLDataSource,
                            substitute(cPairsList,
                                       TargetBuffer:name,
                                       hSalesrepBuffer:name,
                                       hDealerBuffer:name,
                                       hLocaleBuffer:name)).
                AttachedActions:Add(poAction).
            end.
            otherwise
                /* on save we're just updating the Customer table */
                super:AttachDataStoreToTarget(poAction).
        end case.
    end method.
    
    /** Update (add or modify) any foreign key values that aren't easily
        mappable from the source dataset/temp-table
        
        @param handle The DB buffer being operated on        
        @param handle The source (typically before-image) buffer handle. */
    method override protected void UpdateForeignKeys(input phDbBuffer as handle,
                                                     input phSourceBuffer as handle):
        define buffer lbLocale for Locale.
        define buffer lbTenant for Tenant.
        define buffer lbCustomer for Customer.
        define buffer lbSalesrep for Salesrep.
        define buffer lbDealer for Dealer.
        define buffer lbDepartment for Department.
        define buffer lbEmployee for Employee.
        
        super:UpdateForeignKeys(input phDbBuffer, input phSourceBuffer).
        
        find lbLocale where
             lbLocale.Name eq phSourceBuffer:after-buffer::PrimaryLocale
             no-lock no-error.
        /* default to the Tenant locale */
        if not available lbLocale then
        do:
            find lbTenant where
                 lbTenant.TenantId eq phDbBuffer::TenantId
                 no-lock no-error.
            phDbBuffer::PrimaryLocaleId = lbTenant.LocaleId.                
        end.
        else
            phDbBuffer::PrimaryLocaleId = lbLocale.LocaleId.
        
        find lbSalesrep where
             lbSalesrep.TenantId eq phDbBuffer::TenantId and
             lbSalesrep.Code eq phSourceBuffer:after-buffer::SalesrepCode
             no-lock no-error.
        
        if available lbSalesrep then
            phDbBuffer::SalesrepId = lbSalesrep.SalesrepId.
        else
        do:
            /* add default */
            find lbDealer where
                 lbDealer.TenantId eq phDbBuffer::TenantId and
                 lbdealer.Code eq phSourceBuffer:after-buffer::DealerCode
                 no-lock no-error.
            if available lbDealer then
                find first lbDepartment where
                           lbDepartment.TenantId eq lbDealer.TenantId and
                           lbDepartment.Name eq 'sales'
                           no-lock no-error.
            if available lbDepartment then
                find first lbEmployee where
                           lbEmployee.DealerId eq lbDealer.DealerId and
                           lbEmployee.DepartmentId eq lbDepartment.DepartmentId and
                           lbEmployee.TenantId eq lbDealer.TenantId
                           no-lock no-error.
            if available lbEmployee then                           
                find first lbSalesrep where
                           lbSalesrep.EmployeeId eq lbEmployee.EmployeeId and
                           lbSalesrep.TenantId eq lbEmployee.TenantId
                           no-lock no-error.
            if available lbSalesrep then
                phDbBuffer::SalesrepId = lbSalesrep.SalesrepId.
        end.
    end method.
    
    method override protected void AddPrimaryKeys(input phDbBuffer as handle,
                                                  input phSourceBuffer as handle):
        define buffer lbCustomer for Customer.
        
        super:AddPrimaryKeys(phDbBuffer, phSourceBuffer).
        
        case phDbBuffer:table:
            when 'Customer' then
            do:
                phDbBuffer::CustomerId = GetNextOpaqueId(phDbBuffer:name).
                
                /* get the last custnum per tenant */
                for each lbCustomer where
                         lbCustomer.TenantId eq phDbBuffer::TenantId
                         no-lock
                         by lbCustomer.CustNum desc:
                    phDbBuffer::CustNum = lbCustomer.CustNum + 1.
                    leave.
                end.
            end.
        end case.
    end method.
    
end class.