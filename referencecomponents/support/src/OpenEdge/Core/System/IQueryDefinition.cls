/** ------------------------------------------------------------------------
    File        : IQueryDefinition
    Purpose     : INterface for query definition: the decomposed parts of a query. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 27 16:06:04 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.SortDirectionEnum.

interface OpenEdge.Core.System.IQueryDefinition:
    /* Allows us to optimize building of queries (ie we don't need to create a new buffer).
       The setting of the *Changed properties to FALSE is an exogenous event: whoever's
       using this object needs to do that. It will probably happen on open. */
    define public event QueryDefinitionChanged signature void (input poQueryDefinition as IQueryDefinition,
                                                               input poEventArgs as QueryDefinitionEventArgs).
                           
    define public property QueryBlockType as QueryBlockTypeEnum no-undo get. set.
    define public property NumBuffers as integer no-undo get.
    
    /* Old-school */    
    method public void ClearAll().
    method public void ClearBuffers().
    method public void ClearFilters().
    method public void ClearSort().
    method public void ClearJoins().
    
    method public void SetBuffers(input pcBuffer as character extent, input pcTable as character extent).
    method public void SetBuffers(input pcBuffer as character extent).
    
    method public void AddBuffer(input pcBuffer as character).
    method public void AddBuffer(input pcBuffer as character, input pcTable as character).    
    method public void AddBuffer(input pcBuffer as character,
                                 input pcTable as character,
                                 input poQueryType as QueryTypeEnum,
                                 input poLockMode as LockModeEnum).
    
    /* IQuery will use these methods when constructing an ABL query */
    method public character extent GetBufferList().
    method public character extent GetBufferList(output pcTables as char extent,
                                                 output poQueryTypes as QueryTypeEnum extent,
                                                 output poLockModes as LockModeEnum extent).

    method public void SetBufferTable(input pcBuffer as character, input pcTable as character).
    method public void SetBufferLockMode(input pcBuffer as character, input poLockMode as LockModeEnum).   /* OpenEdge.System.Core.LockModeEnum  */
    method public void SetBufferQueryType(input pcBuffer as character, input poQueryType as QueryTypeEnum). /* OpenEdge.System.Core.QueryTypeEnum */
    
    method public character GetBufferTable(input pcBuffer as character).
    method public LockModeEnum GetBufferLockMode(input pcBuffer as character).    /* OpenEdge.System.Core.LockModeEnum */
    method public QueryTypeEnum GetBufferQueryType(input pcBuffer as character).
    
    @todo(task="Refactor AddFilter to have type-specific signatures; remove need to pass DataTypeEnum. ").
    method public void AddFilter (input pcBufferName as character,
                                  input pcFieldName as character,
                                  input poOperator as OperatorEnum,
                                  input pcFieldValue as character,
                                  input poFieldType as DataTypeEnum,       /* OpenEdge.Core.System.DataTypeEnum */
                                  input poJoinType as JoinEnum).
    
    method public void AddJoin (input pcBufferName as character,
                                input pcFieldName as character,
                                input poOperator as OperatorEnum,
                                input pcJoinBufferName as character,
                                input pcJoinFieldName as character,
                                input poJoinType as JoinEnum).
    
    method public void AddSort (input pcBufferName as character,
                                input pcFieldName as character,
                                input poSortDirection as SortDirectionEnum).

    method public void AddSort (input pcBufferName as character,
                                input pcFieldName as character,
                                input poSortDirection as SortDirectionEnum,
                                input piOrder as integer).
                                
    /* Methods returning query elements for all buffers in default (added-to-def) order */
    method public character GetQueryString().    
    method public character GetSort().
    
    /* WHERE clause elements per buffer. Filter and Join have
       no real meaning outside of the per-buffer context. */
    method public character GetFilter(input pcBufferName as character).
 
    
    /* Methods returning query elements for buffers in arg order */
    method public character GetQueryString(input pcBufferName as char extent).
    method public character GetSort(input pcBufferName as character extent).
    
    
end interface.
