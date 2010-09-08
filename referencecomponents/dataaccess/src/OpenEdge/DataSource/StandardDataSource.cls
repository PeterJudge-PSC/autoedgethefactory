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

using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataSource.DataSourceEventArgs.
using OpenEdge.DataSource.DataSourceEventEnum.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.IQuery. 

using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.RowStateEnum.

using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.DataSource.StandardDataSource abstract use-widget-pool /*inherits Query*/ 
        implements IDataSource, ITableOwner:
    
    /** The default Page or batch size for this datasource. Can be overridden
        by the page size on the table request. */
    define public property PageSize as integer no-undo get. set.
    
    /** Buffer handle for the temp-table being operated on. Likely to change for 
        each operation  */
    define protected property BufferHandle as handle no-undo get. set.

    /** The data transport type for this message. These may differ for request and response. */
    define private variable MessageDataFormat as DataFormatEnum no-undo.    
    define private variable moMessageDataType as DataTypeEnum no-undo.
    define private variable mhDataTarget as handle   no-undo.
    define private variable mmDataTarget as memptr   no-undo.
    define private variable mcDataTarget as longchar no-undo.
    define private variable moDataTarget as Object   no-undo.


    /** The fill mode for the data fetch (merge etc). */     
    define public property FillMode as FillModeEnum no-undo get. set.
    
    /* DataSource Fetch/Fill events */
    define public event BeforeFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event BeforeRowFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterRowFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    
    /* DataSource Save/Commit events */
    define public event BeforeSaveTransaction signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event BeforeSave            signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterSave             signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterSaveTransaction  signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    
    define private variable moCurrentRequest as IServiceRequest no-undo.
    define private variable moCurrentQuery as IQuery no-undo.
    
    constructor public StandardDataSource ():
        AttachDataStore().
    end constructor.
    
    /** Attaches the actual datasource - this could be an ABL datasource, or some other 
        mechanism (XML or a service or something else). These are specific to each 
        datasource instance, and thus is abstract. 
        
        For example, for an ABL/ProDataSet data source:
            
            <code>
            DEFINE DATA-SOURCE srcCar FOR Car .
            DATA-SOURCE srcCar:HANDLE:prefer-dataset = TRUE.
            hBuffer:ATTACH-DATA-SOURCE(DATA-SOURCE srcCar:HANDLE,"").
            </code>        
        */
    method abstract protected void AttachDataStore().
    
    /** Prepare with query, batchsize and more.
       
       @param ITableRequest Parameters for the fetch (query modifications, page size etc). */
    method public void PrepareForFetch(input poRequest as ITableRequest):
        
        moCurrentQuery = new Query(this-object, cast(poRequest, IQueryDefinition)).
        
/*        BufferHandle = phBuffer.*/
        BufferHandle:fill-mode = FillMode:ToString().
    end method.
    
/** The SetDataTarget() methods are called by the DataAccess object, to specify 
        the target for the DataSource's operations (usually the fill/fetch). 
        
        This data is formatted per the MessageDataFormat above;
        and is stored in the message as either LONGCHAR, MEMPTR, HANDLE or P.L.O. */
    method public void SetDataTarget(input pmData as longchar,
                                     input poMessageDataFormat as DataFormatEnum):
    end method.
    
    method public void SetDataTarget(input pmData as memptr,
                                     input poMessageDataFormat as DataFormatEnum):
    end method.
    
    method public void SetDataTarget(input phData as handle,
                                     input poMessageDataFormat as DataFormatEnum):
    end method.
    
    method public void SetDataTarget(input poData as Object,
                                     input poMessageDataFormat as DataFormatEnum):
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
    method public void PerformFetch():
        define variable lAvailable as logical no-undo.
        
        moCurrentQuery:OpenQuery().
        
        lAvailable = moCurrentQuery:GetFirst().
        if lAvailable then
            OnBeforeFill(?).
            
        do while lAvailable:
            /* Get values and populate this-object:BufferHandle */
            OnBeforeRowFill(BufferHandle).
            BufferHandle:buffer-create().
            BufferHandle:buffer-copy(moCurrentQuery:QueryHandle:get-buffer-handle(BufferHandle:name)).
            BufferHandle:buffer-release().
            OnAfterRowFill(BufferHandle).
            lAvailable = moCurrentQuery:GetNext().
        end.
        OnAfterFill(?).
        
        moCurrentQuery:CloseQuery().
    end method.
    
    /** Called on completion of a data fetch request, typically by the data access object.
    
        @return ITableContext - the context for the request (num records, position etc).    
      */
    method final public ITableResponse GetData():
        define variable oTableResponse as ITableResponse no-undo.
        
        oTableResponse = new TableResponse(cast(moCurrentRequest, ITableRequest):TableName).
        cast(oTableResponse, ITableContext):NumRows = moCurrentQuery:NumRows.
        
        @todo(task="implement", action="").
        cast(oTableResponse, ITableContext):NextPosition = ?.
        cast(oTableResponse, ITableContext):PrevPosition = ?.
        
        return oTableResponse.
        finally:
            BufferHandle = ?.
            moCurrentQuery = ?.
            moCurrentRequest = ?.
        end finally.
    end method.
    
    /** Saves all records in the buffer argument to the physical data store. This
        buffer comes from the DataAccess object.
    
        @param handle The buffer being saved.   */
    method public void SaveData(input phBuffer as handle):
    
        define variable hQuery as handle no-undo.
        define variable hBeforeBuffer as handle no-undo.
        define variable hBeforeQry as handle no-undo.
        
                
        hBeforeBuffer = phBuffer:before-buffer.
        
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
                phBuffer:find-by-rowid(hBeforeBuffer:after-rowid).
        
            SaveData(phBuffer, Query:GetCurrentRowKey(hQuery)).
            
            hBeforeQry:get-next().
        end.
        
        finally:
            hBeforeQry:query-close().
            delete object hBeforeQry no-error.
            BufferHandle = ?.
        end finally.
    end method.
    

    /** Save data contained in the passed buffer to the database, in this case.
    
        @param character[] An array of keys allowing us to find one or more rows 
        in the physical data store.  */
    method public void SaveData(input phSourceBuffer as handle,
                                input pcRowKey as character extent):
        define variable hDataSource as handle     no-undo.
        define variable iBufferIndex as integer    no-undo.
        
        BufferHandle = phSourceBuffer.
        
        OnBeforeSaveTransaction(phSourceBuffer).
        do transaction on error undo, throw :                       
            OnBeforeSave(phSourceBuffer).
        
            if not phSourceBuffer:error then
            do:
                /* save changes to the buffers in the datasource that should not be ignored */ 
                hDataSource = phSourceBuffer:data-source.
                do iBufferIndex = 1 to hDataSource:num-source-buffers :
                    phSourceBuffer:save-row-changes(iBufferIndex).
                end.
                
                if not phSourceBuffer:error then
                    OnAfterSave(phSourceBuffer).
            end.    /* error */
        end.    /* transaction */
        
        OnAfterSaveTransaction(phSourceBuffer).
        
        finally:
            BufferHandle = ?.
        end finally.
    end method.
    
    /** Find the 
    
        @param character[] An array of keys allowing us to find one or more rows 
        in the physical data store.  */
    method abstract protected void FindSourceData(input pcRowKey as character extent).
    
    /* Save events */    
    method protected void OnBeforeSaveTransaction (input phBuffer as handle):
        this-object:BeforeSaveTransaction:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:BeforeSaveTransaction, phBuffer)).
    end method.

    method protected void OnBeforeSave (input phBuffer as handle):
        this-object:BeforeSave:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:BeforeSave, phBuffer)).
    end method.
    
    method protected void OnAfterSave (input phBuffer as handle):
        this-object:AfterSave:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:AfterSave, phBuffer)).
    end method.
    
    method protected void OnAfterSaveTransaction (input phBuffer as handle):
        this-object:AfterSaveTransaction:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:AfterSaveTransaction, phBuffer)).
    end method.
    
    method protected void OnBeforeFill(input phBuffer as handle):
        this-object:BeforeFill:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:BeforeFill, phBuffer)).
    end method.

    method protected void OnBeforeRowFill (input phBuffer as handle):
        this-object:BeforeRowFill:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:BeforeRowFill, phBuffer)).
    end method.
    
    method protected void OnAfterRowFill (input phBuffer as handle):
        this-object:AfterRowFill:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:AfterRowFill, phBuffer)).        
    end method.
    
    method protected void OnAfterFill (input phBuffer as handle):
        this-object:AfterFill:Publish(
                this-object,
                new DataSourceEventArgs(DataSourceEventEnum:AfterFill, phBuffer)).        
    end method.
    
    /** IQuery:ITableOwner implementation. The table name passed in here will be the
        name of the database table (say) that this data source uses to populate
        the table represented by the BufferHandle property.
        
        @param character A table or buffer name. The implementer will
        know how to interpret the name. The name passed in is the name
        that the query will use together with its IQueryDefinition.
        
        @return A buffer handle corresponding to the requested name. */
	method abstract public handle GetTableHandle(input pcTableName as character).
	
end class.