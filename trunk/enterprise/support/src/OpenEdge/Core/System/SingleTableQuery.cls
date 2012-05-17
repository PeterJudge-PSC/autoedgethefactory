/** ------------------------------------------------------------------------
    File        : SingleTableQuery
    Purpose     : Specialised query for use with the temp-tables 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 09 09:57:49 EST 2012
    Notes       :  
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.ITableOwner.

using OpenEdge.Lang.Collections.TypedCollection.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.

class OpenEdge.Core.System.SingleTableQuery inherits Query
        implements ITableOwner:
    
    /** The handle to the ABL table that this query operates against. This can
        be a handle to any table (temp-table, database). */
    define public property Table as handle no-undo get. private set.
    
    constructor public SingleTableQuery(input phTableBuffer as handle):
        super(this-object, new QueryDefinition()).
        
        Assert:ArgumentNotNull(phTableBuffer, 'ABL Buffer').
        assign this-object:Table = phTableBuffer
               this-object:BuildQuery = false.
        
        this-object:Initialize().
    end constructor.
    
    method protected void Initialize():
        /* We need a buffer handle for this query */
        Assert:ArgumentNotNull(this-object:Table, 'ABL Buffer').
        
        /* top-level buffer */               
        Definition:AddBuffer(this-object:Table:name,
                             this-object:Table:table,
                             QueryTypeEnum:Each,
                             LockModeEnum:NoLock).
        
        /* fix (as in finalise or baseline, not as in repair) the definition */
        Rebase().
        
        /* Always prepare this query. */
        QueryElementsChanged = QueryElementsChanged + QueryElementEnum:Buffer:Value.        
        BuildQuery = true.
        BuildQuery(QueryHandle).
    end method.
    
    method override protected void DeleteQuery():
        /* don't delete the buffers since we're using 'direct' buffers, rather than creating named buffers */
        if valid-handle(QueryHandle) then
            delete object QueryHandle.
    end method.    
    
    method override protected handle GetQueryBuffer(input pcTableName as character,
                                                    input pcBufferName as character):
        define variable hBuffer as handle no-undo.
        
        /* First check the buffer name, then the table name. We should always be able to
           find a handle by buffer name, but just in case we can't, we check the table too.
           
           We start with the buffer because we can have multiple buffers on one table in
           a single query. */    
        hBuffer = GetBufferBuffer(pcBufferName).
        if not valid-handle(hBuffer) then
            hBuffer = GetTableBuffer(pcTableName).
        
        return hBuffer.
    end method.

    /* ITableOwner implementation */
    method public handle GetTableHandle(input pcTableName as character):
        return GetTableBuffer(pcTableName).
    end method.
    
    method protected handle GetTableBuffer(input pcTableName as character):
        define variable hBuffer as handle no-undo.
        
        if this-object:Table:table ne pcTableName then
            hBuffer = ?.
        else
            hBuffer = this-object:Table.
        
        return hBuffer.
    end method.
    
    method protected handle GetBufferBuffer(input pcBufferName as character):
        define variable hBuffer as handle no-undo.
        
        if this-object:Table:name ne pcBufferName then
            hBuffer = ?.
        else
            hBuffer = this-object:Table.
        
        return hBuffer.
    end method.

    method override public character GetBufferTableName(input pcBufferName as character):
        define variable hBuffer as handle no-undo.
        
        if this-object:Table:name ne pcBufferName then
            hBuffer = ?.
        else
            hBuffer = this-object:Table.
        
        return hBuffer:table.

    end method.
end class.