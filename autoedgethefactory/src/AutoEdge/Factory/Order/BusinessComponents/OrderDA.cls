/** ------------------------------------------------------------------------
    File        : OrderDA
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 16:22:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAccess.StandardDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Lang.CallbackNameEnum.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Order.BusinessComponents.OrderDA inherits StandardDataAccess: 
    
    constructor public OrderDA (input poDataSources as IMap):
		super (input poDataSources).
	end constructor.
		
	constructor public OrderDA (  ):
		super ().
	end constructor.
	
    /** Resolves a table name from the Business Entity into a physical table name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The table name in the datasource. */
    method override public character ResolveTableName (input pcBETable as character):
        /* this DA assumes there's a direct mapping from eOrder to Order (or from any e<Table> to <Table>, really) */
        return substring(pcBETable, 2).
    end method.
    
    /** Resolves a field name from the Business Entity into a physical field name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The field name in the datasource. */    
    method override public character ResolveFieldName(input pcBETable as character, input pcBEField as character):
        return pcBEField.       
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
                     phBuffer:set-callback(CallbackNameEnum:AfterRowFill:ToString(), 'OrderAfterRowFillCallback', this-object).
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
    
    method public void OrderAfterRowFillCallback(input dataset-handle phEntity):
        define variable hBuffer as handle no-undo.
        
        hBuffer = phEntity:get-buffer-handle('eOrder').
        
        /* update */
        find first StatusDetail where
                   StatusDetail.StatusDetailId = hBuffer::StatusId
                   no-lock.
        hBuffer::OrderStatus = StatusDetail.Description.
        
        find first Customer where
                   Customer.CustomerId = hBuffer::CustomerId
                   no-lock.
        hBuffer::CustomerName = Customer.Name.         

    end method.
    
end class.