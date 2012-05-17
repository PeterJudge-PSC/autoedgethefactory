/** ------------------------------------------------------------------------
    File        : IQueryElementResolver
    Purpose     : Provides an a means to map query elements  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 09 12:49:22 EST 2012
    Notes       : * DataAccess objects are responsible for  field- and table-
                    name mappings between the business entity and the data source
                    objects. The BE might work with 'eEmployee' and the DS with 'employee';
                    this mapping is held in the DA and accessed via this interface.
                  * Also used by the DataSource.TrackingTableQuery for mapping
                    before- and after-buffer elements. 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.QuerySort.

interface OpenEdge.Core.System.IQueryElementResolver:
    
    
    /** Resolves table and field names from the Business Entity into a physical table and field 
        names in the DataSource. The values passed in here are usually taken from the ITableRequest 
        that's part of the IServiceRequest.
        
        @param character A table name in the business entity (ie. not resolved)
        @param character A field name in the business entity (ie. not resolved).
        @return character[] The [db.][table.]field name in the datasource. If the array has an extent
                of 1, then it's a field in the input table; if 2 then in the same Db.
                [1] = FieldName
                [2] = TableName
                [3] = DB Name               */
    method public character extent ResolveFieldName (input pcSourceTable as character,
                                                     input pcSourceField as character).
    
    /** Resolves a query filter on the data access/entity ("eTable.Field = 'someValue' ") to a filter on the 
        DB/datasource ("Table.Field = 'someValue'). This is typically for more complex transformations than
        just a simple field and/or table name mappes: for example, where one filter in the entity maps to
        multiple filters in the DB.
        
        @param QueryFilter The source/business entity filter to transform. 
        @return QueryFilter[] The filter clause(s) on the DB query that the source filter resolves to */
    method public QueryFilter extent ResolveFilter(input poSourceFilter as QueryFilter).

    /** Resolves a query Join on the data access/entity ("eTable.Field = eTable2.Field") to a Join on the 
        DB/datasource ("Table.Field = dbTable2.Field"). This is typically for more complex transformations than
        just a simple field and/or table name mappes: for example, where one Join in the entity maps to
        multiple Joins in the DB.
        
        @param QueryJoin The source/business entity Join to transform.
        @return QueryJoin[] The Join clause(s) on the DB query that the source Join resolves to */
    method public QueryJoin extent ResolveJoin(input poSourceJoin as QueryJoin).

    /** Resolves a query sort on the data access/entity ("by eTable.Field ") to a sort on the 
        DB/datasource ("By Table.Field"). This is typically for more complex transformations than
        just a simple field and/or table name mappings
        
        @param QuerySort The source/business entity sort to transform.
        @return QuerySort[] The sort clause(s) on the DB query that the source sort resolves to */
    method public QuerySort extent ResolveSort(input poSourceSort as QuerySort).    
  
end interface.