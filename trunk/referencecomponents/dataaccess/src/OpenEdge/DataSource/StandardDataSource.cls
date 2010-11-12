/** ------------------------------------------------------------------------
    File        : StandardDataSource
    Purpose     : Datasource that populates a buffer using an ABL query
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Thu Feb 11 20:09:22 EST 2010
    Notes       : * The QueryDefinition of this datasource is the 'base query';
                    the TableRequest adds to it for filtering. 
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.DataSource.

using OpenEdge.DataSource.DataSourceEventArgs.
using OpenEdge.DataSource.DataSourceEventEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.IQuery.
 
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.RowStateEnum.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.DataSource.StandardDataSource abstract use-widget-pool inherits DataSource
        implements ITableOwner:
        
    define protected property CurrentQuery as IQuery no-undo get. private set.
    
    constructor public StandardDataSource ():
        super().
    end constructor.
    
    /** Prepare with query, batchsize and more.
    
       @param ITableRequest Parameters for the fetch (query modifications, page size etc). */
    method override public void Prepare(input poRequest as ITableRequest):
        /* Here we transform the query on the ITableRequest and map from (say)
                eSalesrep.QuoteJanuary to sports2000.SalesRep.MonthQuota[1]
           */
        
        CurrentQuery = new Query(this-object, cast(poRequest, IQueryDefinition)).
        
        HandleDataTarget:fill-mode = FillMode:ToString().
        
        CurrentQuery:Prepare().
    end method.
    
    /** Perform fetch: populate the previously-passed buffer from the
        physical data store.
        
        The caller needs to call GetData() afterwards if they want 
        any additional information about the fetch call (stuff that's
        in ITableContext).
        
        Note:
            - this method will not be called when Datasets are involved, 
        since the FILL() method will probably be called instead. THe code below 
        is for illustrative purposes.
            - there are no events (before-fill etc) fired since this code
        doesn't use prodataset; we should therefor create our own events and 
        fire them if we so desire.          */
    method override public void FetchData():
        define variable lAvailable as logical no-undo.
        define variable cRowKey as character extent no-undo.
        
        CurrentQuery:Open().
        
        lAvailable = CurrentQuery:GetFirst().
        if lAvailable then
            OnBeforeFill().
        
        do while lAvailable:
            cRowKey = CurrentQuery:GetCurrentRowKey().
            /* Get values and populate this-object:HandleDataTarget */
            OnBeforeRowFill(cRowKey).
            HandleDataTarget:buffer-create().
            HandleDataTarget:buffer-copy(CurrentQuery:QueryHandle:get-buffer-handle(HandleDataTarget:name)).
            HandleDataTarget:buffer-release().
            OnAfterRowFill(cRowKey).
            lAvailable = CurrentQuery:GetNext().
        end.
        OnAfterFill().
        
        CurrentQuery:Close().
    end method.
    
    /** Called on completion of a data fetch request, typically by the data access object.
    
        @return ITableContext - the context for the request (num records, position etc).    
      */
    method override public ITableResponse GetData():
        define variable oTableResponse as ITableResponse no-undo.
        define variable oTC as ITableContext no-undo.
        
        oTableResponse = new TableResponse(cast(CurrentRequest, ITableRequest):TableName).
        oTC = new TableContext(oTableResponse:TableName, ?).
        
        oTableResponse:TableContext = oTC.
        
        /* update the context with the results of the fetch */
        @todo(task="implement", action="").
        oTC:PageSize = CurrentQuery:NumRows.
        
        return oTableResponse.
        finally:
            ClearDataTarget().
            CurrentQuery = ?.
            CurrentRequest = ?.
        end finally.
    end method.    
    
    /** Saves all records in the buffer argument to the physical data store. This
        buffer comes from the DataAccess object.
    
        @return ITableResponse The response to the save operation. */
    method override public ITableResponse SaveData():
        define variable hQuery as handle no-undo.
        define variable hBeforeBuffer as handle no-undo.
        define variable hBeforeQry as handle no-undo.
        define variable oTableResponse as ITableResponse no-undo.
        
        hBeforeBuffer = HandleDataTarget:before-buffer.
        
        create query hBeforeQry.
        hBeforeQry:set-buffers(hBeforeBuffer).
        hBeforeQry:query-prepare(" for each " + hBeforeBuffer:NAME).
        hBeforeQry:query-open().
        hBeforeQry:get-first().
        
        do while not hBeforeQry:query-off-end:
            /* Find the after-table row for this before-table row so that
               the validation logic can look at it (SAVE-ROW-CHANGES doesn't
               need it; it can do this on its own). If it's a Delete, then
               there *is* no after-table row. */
            if not hBeforeBuffer:row-state eq RowStateEnum:Deleted:Value then
                HandleDataTarget:find-by-rowid(hBeforeBuffer:after-rowid).
        
            SaveRowData(Query:GetCurrentRowKey(hQuery)).
            
            hBeforeQry:get-next().
        end.
        
        oTableResponse = new TableResponse(HandleDataTarget:name).
        oTableResponse:HasError = HandleDataTarget:error.
        oTableResponse:ErrorText = HandleDataTarget:error-string.
        
        return oTableResponse.
        finally:
            hBeforeQry:query-close().
            delete object hBeforeQry no-error.
            delete object hBeforeBuffer no-error.
            hBeforeBuffer = ?.            
        end finally.
    end method.
    

    /** Save data contained in the passed buffer to the database, in this case.
    
        @param character[] An array of keys allowing us to find one or more rows 
        in the physical data store.  */
    method protected void SaveRowData(input pcRowKey as character extent):
        define variable hDataSource as handle     no-undo.
        define variable iBufferIndex as integer    no-undo.
        
        /*HandleDataTarget = phSourceBuffer.*/
        
        
        OnBeforeSaveTransaction(pcRowKey).
        do transaction on error undo, throw :                       
            OnBeforeSave(pcRowKey).
        
            if not HandleDataTarget:error then
            do:
                /* save changes to the buffers in the datasource that should not be ignored */ 
                hDataSource = HandleDataTarget:data-source.
                do iBufferIndex = 1 to HandleDataTarget:num-source-buffers :
                    HandleDataTarget:save-row-changes(iBufferIndex).
                end.
                
                if not HandleDataTarget:error then
                    OnAfterSave(pcRowKey).
            end.    /* error */
        end.    /* transaction */
        
        OnAfterSaveTransaction(pcRowKey).
        
        finally:
            ClearDataTarget().
        end finally.
    end method.

    /** IQuery:ITableOwner implementation. The table name passed in here will be the
        name of the database table (say) that this data source uses to populate
        the table represented by the HandleDataTarget property.
        
        @param character A table or buffer name. The implementer will
        know how to interpret the name. The name passed in is the name
        that the query will use together with its IQueryDefinition.
        
        @return A buffer handle corresponding to the requested name. */
    method abstract public handle GetTableHandle(input pcTableName as character).    


end class.