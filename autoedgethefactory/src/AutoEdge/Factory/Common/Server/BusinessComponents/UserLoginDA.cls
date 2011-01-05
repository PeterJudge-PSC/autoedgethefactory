/** ------------------------------------------------------------------------
    File        : UserLoginDA
    Purpose     : DataAccess object for User Logins
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 22 10:08:00 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.StandardDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.CallbackNameEnum.

class AutoEdge.Factory.Common.Server.BusinessComponents.UserLoginDA inherits StandardDataAccess: 

	constructor public UserLoginDA(input poDataSources as IMap ):
		super (input poDataSources).
	end constructor.
		
	constructor public UserLoginDA (  ):
		super ().
	end constructor.

    /** Resolves a table name from the Business Entity into a physical table name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The table name in the datasource. */
    method override public character ResolveTableName (input pcBETable as character):
        case pcBETable:
            when 'eUserLogin' then return 'ApplicationUser'.
        end case.
    end method.
    
    /** Add ABL callbacks to a buffer handle for an action.
    
        @param handle The buffer on which to attach the callback
        @param ServiceMessageActionEnum The action being performed.
        
        @return Logical value indicating whether there are any callbacks set for the buffer */
    method override protected logical AddBufferCallbacks(input phBuffer as handle,
                                                         input poServiceMessageAction as ServiceMessageActionEnum):
            /* Example below */
            case poServiceMessageAction:
                when ServiceMessageActionEnum:FetchData then
                do:
                     phBuffer:set-callback(CallbackNameEnum:AfterRowFill:ToString(), 'AfterRowFillCallback', this-object).
                end.
                when ServiceMessageActionEnum:SaveData then
                do:
                    /*  
                    OpenEdge.DataSource.DataSource:SubscribeDataSourceEvents(
                        cast(DataSources:Get(phBuffer:name), IDataSource,
                        this-object).
                    */
                end.
            end case.
    end method.
    
    method public void AfterRowFillCallback(input dataset-handle phEntity):
        define variable hBuffer as handle no-undo.
        define variable hField as handle no-undo.
        define variable hDBBuffer as handle no-undo.
        
        hBuffer = phEntity:get-buffer-handle('eUserLogin').
        hField = hBuffer:buffer-field('UserCategory').
        
        /* user category */
        hDBBuffer = hBuffer:data-source:get-source-buffer(1).
        
        if hDBBuffer::CustomerId ne '' then
            hField:buffer-value = hField:buffer-value + ',Customer'. 
        if hDBBuffer::EmployeeId ne '' then
            hField:buffer-value = hField:buffer-value + ',Employee'. 
        if hDBBuffer::SupplierId ne '' then
            hField:buffer-value = hField:buffer-value + ',Supplier'. 
        hField:buffer-value = left-trim(hField:buffer-value, ',').
    end method.
        
end class.