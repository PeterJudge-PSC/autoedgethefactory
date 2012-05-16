/** ------------------------------------------------------------------------
    File        : DealerDA
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 25 14:39:56 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataAccess.StandardDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Lang.CallbackNameEnum.
using OpenEdge.Lang.Collections.IMap.

class AutoEdge.Factory.Server.Common.BusinessComponent.DealerDA inherits StandardDataAccess: 

	constructor public DealerDA ( input poDataSources as IMap ):
		super (input poDataSources).
	end constructor.
		
	constructor public DealerDA (  ):
		super ().
	end constructor.

    /** Resolves a field name from the Business Entity into a physical field name in the
        DataSource. The values passed in here are usually taken from the ITableRequest that's
        part of the IServiceRequest.
        
        @param character A table name in the business entity (not resolved)
        @param character A field name in the business entity
        @return character[] The [db.][table.]field name in the datasource. If the array has an extent
                of 1, then it's a field in the input table; if 2 then in the same Db.
                [1] = FieldName
                [2] = TableName
                [3] = DB Name               */
    method override public character extent ResolveFieldName (input pcSourceTable as character, input pcSourceField as character):        
        define variable cFieldName as character extent 2 no-undo.
        
        assign cFieldName[1] = pcSourceField
               cFieldName[2] = substring(pcSourceTable, 2).
        
        return cFieldName.
    end method.

    /** Add ABL callbacks to a buffer handle for an action.
    
        @param handle The buffer on which to attach the callback
        @param ServiceMessageActionEnum The action being performed.
        
        @return Logical value indicating whether there are any callbacks set for the buffer */
    method override protected void AddBufferCallbacks(input phBuffer as handle,
                                                      input poServiceMessageAction as ServiceMessageActionEnum,
                                                      input poDataSource as IDataSource):
            /* Example below */
            case poServiceMessageAction:
                when ServiceMessageActionEnum:FetchData then
                do:
                    if phBuffer:name eq 'eDealer' then 
                        phBuffer:set-callback(CallbackNameEnum:AfterRowFill:ToString(),
                                              'AfterRowFillCallback',
                                              this-object).
                end.                                           
            end case.
    end method.
    
    method public void AfterRowFillCallback(input dataset-handle phEntity):
        define variable hBuffer as handle no-undo.
        define variable hSalesrepBuffer as handle no-undo.
        define variable hDBBuffer as handle no-undo.
        
        define buffer lbAddressDetail for AddressDetail.
        define buffer lbState for State.
        define buffer lbContactDetail for ContactDetail.
        define buffer lbSalesrep for Salesrep.
        define buffer lbDepartment for Department.
        define buffer lbEmployee for Employee.
        
        /* specify the item type */
        hBuffer = phEntity:get-buffer-handle('eDealer').
        hDBBuffer = hBuffer:data-source:get-source-buffer(1).
        
        /*field StreetAddress as character*/
        find lbAddressDetail where
             lbAddressDetail.AddressDetailId eq hDBBuffer::StreetAddressId
             no-lock no-error.
        if available lbAddressDetail then
            hBuffer::StreetAddress = lbAddressDetail.AddressLine1 + ', '
                                   + lbAddressDetail.AddressLine2 + ', '
                                   + lbAddressDetail.City + ', '
                                   + lbAddressDetail.PostalCode + ' '
                                   + lbAddressDetail.State + ', '
                                   + lbAddressDetail.CountryCode.
        
        /*field SalesEmail as character*/
        find lbContactDetail where
             lbContactDetail.ContactDetailId eq hDBBuffer::SalesEmailContactId
             no-lock no-error.
        if available lbContactDetail then
            hBuffer::SalesEmail = lbContactDetail.Detail. 
        
        /*field InfoEmail as character*/
        find lbContactDetail where
             lbContactDetail.ContactDetailId eq hDBBuffer::InfoEmailContactId
             no-lock no-error.
        if available lbContactDetail then
            hBuffer::InfoEmail = lbContactDetail.Detail. 
        
        /*field PhoneNumber as character*/
        find lbContactDetail where
             lbContactDetail.ContactDetailId = hDBBuffer::SwitchboardPhoneNumberId
             no-lock no-error.
        if available lbContactDetail then
            hBuffer::PhoneNumber = lbContactDetail.Detail.
        /* Salesreps */
        /* NOTE: this should be its own DataSource */
        hSalesrepBuffer = phEntity:get-buffer-handle('eSalesrep').
        for each lbDepartment where
                 lbDepartment.TenantId eq hDBBuffer::TenantId and
                 lbDepartment.Name eq 'sales'
                 no-lock,
            each lbEmployee where
                 lbEmployee.TenantId eq lbDepartment.TenantId and
                 lbEmployee.DepartmentId eq lbDepartment.DepartmentId and
                 lbEmployee.DealerId eq hDBBuffer::DealerId
                 no-lock,
            each lbSalesrep where
                 lbSalesrep.TenantId eq lbEmployee.TenantId and
                 lbSalesrep.EmployeeId eq lbEmployee.EmployeeId
                 no-lock:
            hSalesrepBuffer:buffer-create().
                hSalesrepBuffer::DealerId = hDBBuffer::DealerId.
                hSalesrepBuffer::Code = lbSalesrep.Code.
                hSalesrepBuffer::Quota = lbSalesrep.AnnualQuota.
                hSalesrepBuffer::Region = lbSalesrep.SalesRegion.
            hSalesrepBuffer:buffer-release().                      
        end.
    end method.
    
end class.