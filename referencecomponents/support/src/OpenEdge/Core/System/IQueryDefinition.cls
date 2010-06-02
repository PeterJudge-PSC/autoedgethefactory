/*------------------------------------------------------------------------
    File        : IQueryDefinition
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 27 16:06:04 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

interface OpenEdge.Core.System.IQueryDefinition:
    /* Allows us to optimize building of queries (ie we don't need to create a new buffer).
       The setting of the *Changed properties to FALSE is an exogenous event: whoever's
       using this object needs to do that. It will probably happen on open. */
    define public event QueryDefinitionChanged signature void (poQueryDefinition as IQueryDefinition, poEventArgs as QueryDefinitionEventArgs).
                           
    define public property QueryBlockType as EnumMember no-undo get. set.   /* OpenEdge.Core.System.QueryBlockTypeEnum */
    define public property NumBuffers as integer no-undo get.
    
    /* Old-school */    
    method public void ClearAll().
    method public void ClearBuffers().
    method public void ClearFilters().
    method public void ClearSort().
    method public void ClearJoins().
    
    method public void SetBuffers(pcBuffer as char extent, pcTable as char extent).
    method public void SetBuffers(pcBuffer as char extent).
    
    method public void AddBuffer(pcBuffer as char).
    method public void AddBuffer(pcBuffer as char, pcTable as char).    
    method public void AddBuffer(pcBuffer as char,
                                 pcTable as char,
                                 poQueryType as EnumMember,
                                 poLockMode as EnumMember).
    
    /* IQuery will use these methods when constructing an ABL query */
    method public character extent GetBufferList().
    method public character extent GetBufferList(output pcTables as char extent,
                                                 output poQueryTypes as EnumMember extent,
                                                 output poLockModes as EnumMember extent).

    method public void SetBufferTable(pcBuffer as char, pcTable as char).
    method public void SetBufferLockMode(pcBuffer as char, piLockMode as EnumMember).   /* OpenEdge.System.Core.LockModeEnum  */
    method public void SetBufferQueryType(pcBuffer as char, poQueryType as EnumMember). /* OpenEdge.System.Core.QueryTypeEnum */
    
    method public character GetBufferTable(pcBuffer as char).
    method public EnumMember GetBufferLockMode(pcBuffer as char).    /* OpenEdge.System.Core.LockModeEnum */
    method public EnumMember GetBufferQueryType(pcBuffer as char).   /* OpenEdge.System.Core.QueryTypeEnum */
    
    @todo(task="Refactor AddFilter to have type-specific signatures; remove need to pass DataTypeEnum. ").
    method public void AddFilter (pcBufferName as char,
                                  pcFieldName as char,
                                  poOperator as EnumMember,        /* OpenEdge.Lang.OperatorEnum: =,<,> etc */
                                  pcFieldValue as char,
                                  poFieldType as EnumMember,       /* OpenEdge.Core.System.DataTypeEnum */
                                  poJoinType as EnumMember   ).    /* OpenEdge.Lang.JoinEnum: AND, OR etc */
    
    method public void AddJoin (pcBufferName as char,
                                pcFieldName as char,
                                poOperator as EnumMember,          /* OpenEdge.Lang.OperatorEnum: =,<,> etc */
                                pcJoinBufferName as char,
                                pcJoinFieldName as char,
                                poJoinType as EnumMember).         /* OpenEdge.Lang.JoinEnum: AND, OR etc */
    
    method public void AddSort (pcBufferName as char,
                                pcFieldName as char,
                                poSortDirection as EnumMember).     /* OpenEdge.Lang.SortDirectionEnum */

    method public void AddSort (pcBufferName as char,
                                pcFieldName as char,
                                poSortDirection as EnumMember,     /* OpenEdge.Lang.SortDirectionEnum */
                                piOrder as integer).
                                
    /* Methods returning query elements for all buffers in default (added-to-def) order */
    method public character GetQueryString().    
    method public character GetSort().
    
    /* WHERE clause elements per buffer. Filter and Join have
       no real meaning outside of the per-buffer context. */
    method public character GetFilter(pcBufferName as character).
 
    
    /* Methods returning query elements for buffers in arg order */
    method public character GetQueryString(pcBufferName as char extent).
    method public character GetSort(pcBufferName as character extent).
    
    
end interface.
