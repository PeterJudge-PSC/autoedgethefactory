/** ------------------------------------------------------------------------
    File        : Query
    Purpose     : General query object/wrapper
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jul 31 16:34:19 EDT 2009
    Notes       : The buffers this query uses could also theoretically
                  be encapsulated. This is left as an exercise for the
                  reader :) 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.RowPositionEnum.
using OpenEdge.Core.System.QueryElementEnum.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.UnsupportedOperationError.

using OpenEdge.Lang.FindTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.

using Progress.Lang.Error.

class OpenEdge.Core.System.Query use-widget-pool 
    implements IQuery:

    /* The model or other component that holds this query. We need it in case of callbacks. */ 
    define public property TableOwner as ITableOwner no-undo  get. protected set.
    
    define public property QueryHandle as handle no-undo get. protected set.
    
    /* Query only has one QueryDefinition associated with it. Once it's created, we can
       manipulate to our hearts' content, but the object instance stays the same. */
    define public property QueryDefinition as IQueryDefinition no-undo get. protected set.
    
    /* This is the base or initial definition used to create this query. It's 
       a copy of the QueryDef passed in to the ctor, and should not be changed. */
    define protected property BaseQueryDefinition as IQueryDefinition no-undo get. set.
    
    define public property NumRows as int no-undo
        get():
            define variable iNumRows as int no-undo.
            
            if valid-handle(QueryHandle) and QueryHandle:is-open then
                iNumRows = QueryHandle:num-results.
            else
                iNumRows = -1.
            
            return iNumRows.
        end get.
    
    define public property CurrentRow as integer no-undo 
        get():
            define variable iCurrentRow as int no-undo.
            
            if valid-handle(QueryHandle) and QueryHandle:is-open then
                iCurrentRow = QueryHandle:current-result-row.
            else
                iCurrentRow = -1.
            
            return iCurrentRow.
        end get.
        
    define public property RowPosition as RowPositionEnum no-undo
        get():
            define variable oRowPosition as RowPositionEnum no-undo.
                
            if not QueryHandle:is-open or
               QueryHandle:current-result-row eq 0 then
                oRowPosition = RowPositionEnum:None.
            else
                if QueryHandle:current-result-row eq 1 then
                    oRowPosition = RowPositionEnum:IsFirst. 
                else
                    if QueryHandle:current-result-row eq QueryHandle:num-results then
                        if oRowPosition eq RowPositionEnum:IsFirst then
                            oRowPosition = RowPositionEnum:IsFirstAndLast.
                        else
                            oRowPosition = RowPositionEnum:IsLast. 
                    else
                        oRowPosition = RowPositionEnum:NotFirstOrLast.
            
            return oRowPosition.
        end get.
    
    define protected property BuildQuery as logical no-undo get. set.
    
    constructor public Query(poTableOwner as ITableOwner, poQueryDefinition as IQueryDefinition):
        assign QueryDefinition = poQueryDefinition
               TableOwner = poTableOwner
               BaseQueryDefinition = cast(poQueryDefinition:Clone(), IQueryDefinition)
               
               /* Obviously, we'll need to build the query at some point. */
               BuildQuery = true.
        
        /* If someone changes the query, we want to know about it so that when we
           (re)open a query, we know whether to rebuild the query string again (or 
           not). */
        QueryDefinition:QueryDefinitionChanged:Subscribe(QueryDefinitionChangedHandler).
    end constructor.
    
    method public void OpenQuery():
        OpenQuery(QueryHandle).
    end method.
    
    method protected void OpenQuery(phQuery as handle):
        /* Build called since the defs may have changed.
           Build checks whether it needs to do anything. */
        BuildQuery(phQuery).
        
        if valid-handle(phQuery) then
        do:
            if phQuery:is-open then
                phQuery:query-close().
            phQuery:query-open().
        end.
    end method.
    
    method public logical CloseQuery():
        return CloseQuery(QueryHandle).
    end method.
    
    method protected logical CloseQuery(phQuery as handle):
        if valid-handle(phQuery) and phQuery:is-open then
            return phQuery:query-close().
        else 
            return false. 
    end method.
               
    method public logical RepositionQuery(piRow as int):
        return RepositionQuery(QueryHandle, piRow).
    end method.
    
    method protected logical RepositionQuery(phQuery as handle, piRow as int):
        if piRow gt 0 then
        do:
            phQuery:reposition-to-row(piRow).
            
            /* deal with non-scrolling queries */
            if not phQuery:get-buffer-handle(phQuery:num-buffers):available then
                phQuery:get-next().
            return phQuery:get-buffer-handle(1):available.           
        end.
        
        return false.
    end method.
    
    method protected logical RepositionQuery (phQuery as handle, prRecord as rowid extent):
        if prRecord[1] ne ? then
        do:
            /* Workaround for bug */
            if extent(prRecord) eq 1 then
                phQuery:reposition-to-rowid(prRecord[1]).
            else
                phQuery:reposition-to-rowid(prRecord).
            
            /* deal with non-scrolling queries */
            if not phQuery:get-buffer-handle(phQuery:num-buffers):available then
                phQuery:get-next().
                    
            return phQuery:get-buffer-handle(1):available.
        end.
        return false.
    end method.
    
    method public logical RepositionQuery (pcRowKey as char extent):
        return RepositionQuery(QueryHandle, pcRowKey).
    end method.
    
    method protected logical RepositionQuery (phQuery as handle, pcRowKey as char extent):
        define variable rCurrentRow as rowid extent no-undo.
        define variable iExtent as integer no-undo.
        define variable hBuffer as handle no-undo.

        extent(rCurrentRow) = extent(pcRowKey).
        rCurrentRow = ?.
        
        do iExtent = 1 to extent(pcRowKey):
            if pcRowKey[iExtent] eq '' or 
               pcRowKey[iExtent] eq ? then
                next.
            
            if pcRowKey[iExtent] begins 'where' then
            do:
                hBuffer = phQuery:get-buffer-handle(iExtent).
                hBuffer:find-unique(pcRowKey[iExtent]) no-error.
                if hBuffer:available then
                    rCurrentRow[iExtent] = hBuffer:rowid.
            end.
            else
                rCurrentRow[iExtent] = to-rowid(pcRowKey[iExtent]).
        end.    /* loop through where */
        
        return RepositionQuery(phQuery, rCurrentRow).
    end method.
            
    method public logical ReopenQuery():
        return ReopenQuery(QueryHandle).
    end method.
    
    method protected logical ReopenQuery(phQuery as handle):
        return ReopenQuery(Query:GetCurrentRowKey(phQuery)).
    end method.
    
    method public logical  ReopenQuery(pcRowKey as char extent):
        return ReopenQuery(QueryHandle, pcRowKey).
    end method.
    
    method protected logical ReopenQuery(phQuery as handle, pcRowKey as char extent ):
        OpenQuery(phQuery).
        return RepositionQuery(phQuery, pcRowKey).
    end method.
    
    method public logical ReopenQuery(piRow as integer):
        return ReopenQuery(QueryHandle, piRow).
    end method.
    
    method protected logical ReopenQuery(phQuery as handle, piRow as integer):
        OpenQuery(phQuery).
        return RepositionQuery(phQuery, piRow).
    end method.
    
    method public character extent GetCurrentRowKey():
        return Query:GetCurrentRowKey(QueryHandle).
    end method.
    
    method static public character extent GetCurrentRowKey(phQuery as handle):
        define variable cKeyWhere as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iFields as integer no-undo.
        define variable cKeys as character no-undo.
        define variable hBuffer as handle no-undo.
        
        if valid-handle(phQuery) and phQuery:is-open then
        do:
            extent(cKeyWhere) = phQuery:num-buffers.
            
            do iLoop = 1 to phQuery:num-buffers:
                hBuffer = phQuery:get-buffer-handle(iLoop).
                if not hBuffer:available then
                do:
                    cKeyWhere[iLoop] = ?.
                    leave.
                end.
                
                cKeys = hBuffer:keys.
                if cKeys eq 'Rowid' then
                    cKeyWhere[iLoop] = string(hBuffer:rowid). 
                else
                do iFields = 1 to num-entries(cKeys):
                    cKeyWhere[iLoop] = cKeyWhere[iLoop]
                                     + (if iFields eq 1 then 'where ' else ' and ')
                                     + hBuffer:name + '.' + entry(iFields, cKeys)
                                     + ' = ' + quoter(hBuffer:buffer-field(entry(iFields, cKeys)):buffer-value)
                                     .
                end.    /* key fields */
            end.
        end.
        else
            assign extent(cKeyWhere) = 1
                   cKeyWhere = ?.
        
        return cKeyWhere.
    end method.
    
    method public character extent GetFirstRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetFirst(hQuery).
        
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetNextRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetNext(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetLastRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetLast(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetPrevRowKey().
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        GetPrev(hQuery).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetRowKey(piPosition as int):
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        RepositionQuery(hQuery, piPosition).
                
        return Query:GetCurrentRowKey(hQuery).
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    end method.
    
    method public character extent GetRowKeyWhere(poQueryDefinition as IQueryDefinition, poFindType as FindTypeEnum):
        define variable hQuery as handle no-undo.
        
        hQuery = CloneQuery(QueryHandle).
        
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
        
        finally:
            CloseQuery(hQuery).
            delete object hQuery no-error.
        end finally.
    
    end method.
    
    /* We may clone this query in order to get row keys from a result without
       causing the 'real' query to reposition. This may be used when performing
       multi-select operations in the UI, where we don't want to move off the
       current record. Note that these actions may be expensive, because of the
       cost of creating, opening, etc the query. */
    method protected handle CloneQuery(phSource as handle):
        define variable hQueryClone as handle no-undo.        
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        create query hQueryClone.
        iMax = phSource:num-buffers.
        
        do iLoop  = 1 to iMax:
            hQueryClone:add-buffer(phSource:get-buffer-handle(iLoop)).
        end.
        hQueryClone:query-prepare(phSource:prepare-string).
        
        return hQueryClone.
    end method. 
        
    destructor public Query():
        QueryDefinition:QueryDefinitionChanged:Unsubscribe(QueryDefinitionChangedHandler).
        
        DeleteQuery().
    end destructor.
    
    method public void QueryDefinitionChangedHandler(input poSender as IQueryDefinition, input poArgs as QueryDefinitionEventArgs):
        /* Ignore prebult PDS queries wrt buffer changes. We only want
           to react to filter, sort, join changes.
           
           Don't touch the buffers if we aren't able to create them via a TableOwner.
           
           This is a shortcut, since BuildQuery checks for this
           sort of thing. */
        if poArgs:Element eq QueryElementEnum:Buffer and
           not valid-object(TableOwner) then
            BuildQuery = false.
        else
            BuildQuery = true.
    end.
    
    method protected void DeleteQuery():
        define variable iLoop as integer no-undo.
                
        /* don't delete PDS auto queries */
        if valid-object(TableOwner) and
           valid-handle(QueryHandle) then
        do:
            do iLoop = 1 to QueryHandle:num-buffers:
                delete object QueryHandle:get-buffer-handle(iLoop).
            end.
            
            delete object QueryHandle.
        end.        
    end method.
    
    method protected void BuildQuery(phQuery as handle):
        define variable cBuffers as character extent no-undo.
        define variable cTables as character extent no-undo.
        define variable oQueryTypes as QueryTypeEnum extent no-undo.
        define variable oLockModes as LockModeEnum extent no-undo.
        define variable hBuffer as handle no-undo.
        define variable iExtent as integer no-undo.
        define variable hTable as handle no-undo.
        
        /* nothing to do here. */
        if not BuildQuery then
            return.
        
        if not valid-handle(phQuery) then
            create query phQuery.
        
        /* (re)build the query's buffers.
           don't delete the query since the consumer of this query may use the 
           handle as a name (and probably does, in fact) so we don't want to mess 
           with that. 
           Don't touch the buffers if we aren't able to create them via a TableOwner. */
        if valid-object(TableOwner) then
        do:
            /* Clean up after ourselves. Note that this only removes the
               named buffer used for the query, and not the underlying buffer
               itself. */
            do iExtent = 1 to phQuery:num-buffers:
                delete object phQuery:get-buffer-handle(iExtent) no-error.
            end.
            
            /* And now add the new buffer(s) */
            cBuffers = QueryDefinition:GetBufferList(output cTables,
                                                     output oQueryTypes,
                                                     output oLockModes).
            
            do iExtent = 1 to extent(cBuffers):
                create buffer hBuffer
                    for table TableOwner:GetTableHandle(cTables[iExtent])  
                    buffer-name cBuffers[iExtent].
                
                if iExtent eq 1 then
                    phQuery:set-buffers(hBuffer).
                else
                    phQuery:add-buffer(hBuffer).
            end.
        end.
        
        phQuery:query-prepare(QueryDefinition:GetQueryString()).
        
        /* for this query, we're at rest */
        BuildQuery = false.
    end method.
    
    method public logical GetFirst():
        return GetFirst(QueryHandle).
    end method.
    
    method protected logical GetFirst(phQuery as handle):
        RepositionQuery(phQuery, 1).
                                
        return phQuery:get-buffer-handle(1):available.
    end method.
                
    method public logical GetNext():
        return GetNext(QueryHandle).
    end method.
    
    method protected logical GetNext(phQuery as handle):
        RepositionQuery(phQuery, phQuery:current-result-row + 1).
        
        return phQuery:get-buffer-handle(1):available.
    end method.
    
    method public logical GetLast():
        return GetLast(QueryHandle).
    end method.
    
    method protected logical GetLast(phQuery as handle):
        RepositionQuery(phQuery:num-results).
        
        return phQuery:get-buffer-handle(1):available.            
    end method.
        
    method public logical GetPrev():
        return GetPrev(QueryHandle).
    end method.
    
    method protected logical GetPrev(phQuery as handle):
        RepositionQuery(max(phQuery:current-result-row - 1, 1)).
        
        return phQuery:get-buffer-handle(1):available.
    end method.
    
    method public character extent GetRowKeyWhere(poQueryDefinition as IQueryDefinition).
        @todo(task="implement").
    end method.
    
    method public character GetCurrentBufferKey(pcBufferName as char):
        define variable cRowKey as char extent no-undo.
        define variable cKey as char no-undo.
        define variable cBuffers as char extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign cRowKey = GetCurrentRowKey()
               iMax = QueryHandle:num-buffers
               cKey = ?.
        
        /* Unable to determine row key (query might not be open) */
        if extent(cRowKey) eq 1 and cRowKey[1] eq ? then
            cKey = ?.
        else
        do iLoop = 1 to iMax while cKey eq ?:
            if QueryHandle:get-buffer-handle(iLoop):name eq pcBufferName then
                cKey = cRowKey[iLoop].
        end.
        
        return cKey.        
    end method.
    
    method public character GetBufferTableName(pcBufferName as char):
        define variable cTable as character no-undo. 
        cTable = QueryHandle:get-buffer-handle(pcBufferName):table.

        @todo(task="improve message in unsupported Error  or create new Error").
        catch e as Error:
              if valid-handle(QueryHandle) then 
                  undo, throw new InvalidValueSpecifiedError(e,"buffer name","~"" + pcBufferName + "~"").    
                else
                  undo, throw new UnsupportedOperationError(e,"buffer name","~"" + pcBufferName + "~"").   
        end catch.
        finally:
           return cTable.
        end.
    end method.
    
end class.