/** ------------------------------------------------------------------------
    File        : IQuery
    Purpose     : Interface for standard query wrapper/object
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 31 16:33:06 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.System.RowPositionEnum.   
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Lang.FindTypeEnum.

interface OpenEdge.Core.System.IQuery:
      
    define public property QueryHandle as handle no-undo get.
    define public property QueryDefinition as IQueryDefinition no-undo get.
    define public property NumRows as integer no-undo get.
    define public property CurrentRow as integer no-undo get.
    define public property RowPosition as RowPositionEnum no-undo get.
    define public property TableOwner as ITableOwner no-undo get.
    
    /* Constructs an ABL query based on the existing QueryDefinition */
    method public void OpenQuery().
    method public logical CloseQuery().
        
    method public logical ReopenQuery().
    method public logical ReopenQuery(pcRowKey as char extent).
    method public logical ReopenQuery(piRow as integer).
    
    /* position to rowid specified by keys */
    method public logical RepositionQuery(pcRowKey as char extent).
    /* reposition to row number */
    method public logical RepositionQuery(piRow as integer).    
    /* navigate through query */
    method public logical GetFirst().
    method public logical GetNext().
    method public logical GetLast().
    method public logical GetPrev().
    
    /* Use method since we can't add a get override for the entire array as property. */
    method public character extent GetRowKey(piPosition as int).
    method public character extent GetRowKeyWhere(poQueryDefinition as IQueryDefinition,poFindType as FindTypeEnum).
    
    method public character extent GetCurrentRowKey().
    method public character extent GetFirstRowKey().
    method public character extent GetNextRowKey().
    method public character extent GetLastRowKey().
    method public character extent GetPrevRowKey().
    
    method public character GetCurrentBufferKey(pcBufferName as char).
    method public character GetBufferTableName(pcBufferName as char).
    
end interface.