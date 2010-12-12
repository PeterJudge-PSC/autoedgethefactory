/** ------------------------------------------------------------------------
    File        : OrderTableDS
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 16:23:04 EST 2010
    Notes       : 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.QueryFilter.

using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class AutoEdge.Factory.Order.OrderTableDS use-widget-pool inherits StandardDataSource: 
    
    define override protected property TableBuffer as handle no-undo
        get():
            if not valid-handle(TableBuffer) then
                TableBuffer = buffer Order:handle.
            return TableBuffer.
        end get.
        set.
    
    constructor public OrderTableDS():
        super ().
    end constructor.
    
    /** Prepare with query, batchsize and more.
        
        @param ITableRequest Parameters for the fetch (query modifications, page size etc).
        @param IDataAccess The DataAccess object making this request. The DAO can be used to
               resolve table- or field name mappings (from the Business Entity names to the 
               Data Source names.           */
    method override public void Prepare(input poAction as ServiceMessageActionEnum,
                                        input poRequest as ITableRequest,
                                        input poDAO as IDataAccess ):
        define variable oQD as IQueryDefinition no-undo.
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable cRequestBuffers as character extent no-undo.
        define variable cWhereClause as character no-undo.
        
        super:Prepare(poAction, poRequest, poDAO).
        
        case poAction:
            when ServiceMessageActionEnum:FetchData then
            do:
                cWhereClause = CurrentQuery:Definition:GetFilter('Order').
                if cWhereClause ne '' then
                    DataSourceHandle:fill-where-string = 'where ' + cWhereClause.
            end.
        end case.
    end method.
    
    method override public handle GetTableHandle(input pcTableName as character ):
        if pcTableName ne 'Order' then
            undo, throw new InvalidValueSpecifiedError('table',': must be "Order"').
        
        return TableBuffer.
    end method.

    method override protected void CreateDataStore(  ):
      create data-source DataSourceHandle.
      
      DataSourceHandle:add-source-buffer(TableBuffer, TableBuffer:keys).  
    end method.

    method override protected void DeleteDataStore(  ):
        delete object DataSourceHandle no-error.
    end method.

    method override protected void AttachDataStoreToTarget(  ):
        DataSourceHandle:prefer-dataset = true.
        ConvertTargetToHandle():attach-data-source(DataSourceHandle).
        DataSourceAttached = true.
    end method.

    method override protected void DetachDataStoreFromTarget():
        if DataSourceAttached then      
           ConvertTargetToHandle():detach-data-source().
        DataSourceAttached = false.
    end method.

	method override protected QueryFilter GetTenantFilter():
	    return new QueryFilter('Order',
	                           'TenantId',
	                           OperatorEnum:IsEqual,
	                           new String(TenantManager:CurrentTenantId),
                               DataTypeEnum:LongChar,
                               JoinEnum:And).
	end method.
	
end class.