/** ------------------------------------------------------------------------
    File        : CustomerDA
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jun 16 10:59:07 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.StandardDataAccess.
using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataSource.DataSourceEventArgs.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Server.Common.BusinessComponent.CustomerDA inherits StandardDataAccess: 
		
	constructor public CustomerDA(input poDataSources as IMap):
		super (input poDataSources).
	end constructor.

	constructor public CustomerDA (  ):
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
        
        if pcSourceTable eq 'eCustomer' and pcSourceField eq 'DealerCode' then
            assign cFieldName[1] = 'Code'
                   cFieldName[2] = 'Dealer'.
        else
        if pcSourceTable eq 'eCustomer' and pcSourceField eq 'SalesrepCode' then
            assign cFieldName[1] = 'Code'
                   cFieldName[2] = 'Salesrep'.
        else
        if pcSourceTable eq 'eCustomer' and pcSourceField eq 'PrimaryLocale' then
            assign cFieldName[1] = 'Name'
                   cFieldName[2] = 'Locale'.
        else
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
                when ServiceMessageActionEnum:SaveData then
                    poDataSource:AfterSave:Subscribe(eCustomerAfterSaveCallback).
            end case.
    end method.
    
    method public void eCustomerAfterSaveCallback(input poSender as IDataSource, input poEventArgs as DataSourceEventArgs):
        define variable hSourceBuffer as handle no-undo.
        define variable hDBBuffer as handle no-undo.
        define variable hChildBuffer as handle no-undo.
        define variable oTenantId as String no-undo.
        define variable iCustNum as integer no-undo.
        define variable cCustomerId as character no-undo.
        
        define variable hCustomerDBBuffer as handle no-undo.
        define variable hContactEntityBuffer as handle no-undo.
        
        hSourceBuffer = widget-handle(string(poEventArgs:DataTarget)).
        
        case hSourceBuffer:name:
            /* We want to get the CustomerId from, and propogate that to the child records,
               for propert writing to the DB */
            when 'eCustomer' then
            do:
                hCustomerDBBuffer = hSourceBuffer:data-source:get-source-buffer(1). 
                hChildBuffer = DatasetHandle:get-buffer-handle('eContact').
                if hChildBuffer:available then
                    hChildBuffer::CustomerId = hCustomerDBBuffer::CustomerId.
                
                hChildBuffer = DatasetHandle:get-buffer-handle('eAddress').
                if hChildBuffer:available then
                    hChildBuffer::CustomerId = hCustomerDBBuffer::CustomerId.
            end.
        end case.
    end method.
    
end class.