/** ------------------------------------------------------------------------
    File        : IQuery
    Purpose     : interface for standard query wrapper/object
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
    method public logical ReopenQuery(input pcRowKey as character extent).
    method public logical ReopenQuery(input piRow as integer).
    
    /* position to rowid specified by keys */
    method public logical RepositionQuery(input pcRowKey as character extent).
    /* reposition to row number */
    method public logical RepositionQuery(input piRow as integer).    
    /* navigate through query */
    method public logical GetFirst().
    method public logical GetNext().
    method public logical GetLast().
    method public logical GetPrev().
    
    /* Use method since we can't add a get override for the entire array as property. */
    method public character extent GetRowKey(input piPosition as integer).
    method public character extent GetRowKeyWhere(input poQueryDefinition as IQueryDefinition,    
                                                  input poFindType as FindTypeEnum).
    
    method public character extent GetCurrentRowKey().
    method public character extent GetFirstRowKey().
    method public character extent GetNextRowKey().
    method public character extent GetLastRowKey().
    method public character extent GetPrevRowKey().
    
    method public character GetCurrentBufferKey(input pcBufferName as character).
    method public character GetBufferTableName(input pcBufferName as character).
    
end interface.