/** ------------------------------------------------------------------------
    File        : TrackingTableQuery
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 09 12:46:04 EST 2012
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.IQueryElementResolver.
using OpenEdge.Core.System.SingleTableQuery.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.QuerySort.

class OpenEdge.DataSource.TrackingTableQuery inherits SingleTableQuery
        implements IQueryElementResolver:
    
	constructor public TrackingTableQuery ( input phTableBuffer as handle ):
		super (input phTableBuffer).
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
    method public character extent ResolveFieldName (input pcSourceTable as character, input pcSourceField as character):        
        define variable cFieldName as character extent 2 no-undo.
        
        assign cFieldName[1] = pcSourceField
               cFieldName[2] = pcSourceTable.
               
        if valid-handle(this-object:Table:after-buffer) then
            cFieldName[2] = this-object:Table:after-buffer:name.
        
        return cFieldName.
    end method.

    /* ITableOwner implementation */
    method override public handle GetTableHandle(input pcTableName as character):
        if valid-handle(this-object:Table:after-buffer) and
           this-object:Table:after-buffer:name eq pcTableName then
            return this-object:Table.           
        else
            return ?.
    end method.
    
    /** Resolves a query filter on the data access/entity ("eTable.Field = 'someValue' ") to a filter on the 
        DB/datasource ("Table.Field = 'someValue'). This is typically for more complex transformations than
        just a simple field and/or table name mappes: for example, where one filter in the entity maps to
        multiple filters in the DB.
        
        @param QueryFilter The source/business entity filter to transform. 
        @return QueryFilter[] The filter clause(s) on the DB query that the source filter resolves to */
    method public QueryFilter extent ResolveFilter(input poSourceFilter as QueryFilter):
        define variable oResolvedFilter as QueryFilter extent 1 no-undo.
        define variable cResolvedFieldName as character extent no-undo.
        
        /* Resolve any mapping between DB and ProDataSet*/
        cResolvedFieldName = ResolveFieldName(poSourceFilter:BufferName, poSourceFilter:FieldName).
        /* [PJ] eOrder.OrderStatus -> StatusDetail.Code */
        /* [PJ] eOrder.OrderNum -> Order.OrderNum */
        
        /* Use handle:NAME since the table name is what's returned in from ResolveFieldName() */
        oResolvedFilter[1] = new QueryFilter(
                                    cResolvedFieldName[2],
                                    cResolvedFieldName[1],
                                    poSourceFilter:Operator,
                                    poSourceFilter:FieldValue,
                                    poSourceFilter:FieldType,
                                    poSourceFilter:JoinType).
        
        return oResolvedFilter.
    end method.

    /** Resolves a query Join on the data access/entity ("eTable.Field = eTable2.Field") to a Join on the 
        DB/datasource ("Table.Field = dbTable2.Field"). This is typically for more complex transformations than
        just a simple field and/or table name mappes: for example, where one Join in the entity maps to
        multiple Joins in the DB.
        
        @param QueryJoin The source/business entity Join to transform.
        @return QueryJoin[] The Join clause(s) on the DB query that the source Join resolves to */
    method public QueryJoin extent ResolveJoin(input poSourceJoin as QueryJoin).
        define variable oResolvedJoin as QueryJoin extent 1 no-undo.
        define variable cResolvedFieldName as character extent no-undo.
        define variable cResolvedJoinFieldName as character extent no-undo.
        
        /* Resolve any mapping between DB and ProDataSet*/
        cResolvedFieldName = ResolveFieldName(poSourceJoin:BufferName, poSourceJoin:FieldName).
        cResolvedJoinFieldName = ResolveFieldName(poSourceJoin:JoinBufferName, poSourceJoin:JoinFieldName).
        
        oResolvedJoin[1] = new QueryJoin(
                                cResolvedFieldName[2],
                                cResolvedFieldName[1],
                                poSourceJoin:Operator,
                                cResolvedJoinFieldName[2],
                                cResolvedJoinFieldName[1],
                                poSourceJoin:JoinType).
        
        return oResolvedJoin.
    end method.
    
    /** Resolves a query sort on the data access/entity ("by eTable.Field ") to a sort on the 
        DB/datasource ("By Table.Field"). This is typically for more complex transformations than
        just a simple field and/or table name mappings
        
        @param QuerySort The source/business entity sort to transform.
        @return QuerySort[] The sort clause(s) on the DB query that the source sort resolves to */
    method public QuerySort extent ResolveSort(input poSourceSort as QuerySort).
        define variable oResolvedSort as QuerySort extent 1 no-undo.
        define variable cResolvedFieldName as character extent no-undo.
        
        oResolvedSort[1] = new QuerySort(
                                cResolvedFieldName[2],
                                cResolvedFieldName[1],
                                poSourceSort:Direction).
        
        return oResolvedSort.
    end method.      
    
end class.