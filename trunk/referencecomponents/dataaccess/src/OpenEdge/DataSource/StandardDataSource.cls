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
using OpenEdge.DataAccess.IDataAccess.
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
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.RowStateEnum.
using OpenEdge.Lang.String.

using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.DataSource.StandardDataSource abstract use-widget-pool inherits DataSource
        implements ITableOwner:
                    
    define protected property CurrentQuery as IQuery no-undo get. private set.
    
    /** The ABL DATA-SOURCE handle being used */
    define protected property DataSourceHandle as handle no-undo get. set.
    define protected property DataSourceAttached as logical no-undo get. set.
    
    constructor public StandardDataSource ():
        super().
    end constructor.
    
    /** Prepare with query, batchsize and more.
        
        @param ServiceMessageActionEnum The action that we're preparing the datasource for. 
               We may have different actions based on whether this is a Fetch or a Save.
        @param ITableRequest Parameters for the fetch (query modifications, page size etc).
        @param IDataAccess The DataAccess object making this request. The DAO can be used to
               resolve table- or field name mappings (from the Business Entity names to the 
               Data Source names.           */
    method override public void Prepare(input poAction as ServiceMessageActionEnum,
                                        input poRequest as ITableRequest,
                                        input poDAO as IDataAccess):
        super:Prepare(poAction, poRequest, poDAO).
        
        HandleDataTarget:fill-mode = FillMode:ToString().
    end method.
    
    /** Perform fetch: populate the previously-passed buffer from the
        physical data store.
        
        The caller needs to call GetData() afterwards if they want 
        any additional information about the fetch call (stuff that's
        in ITableContext).
        
        Note:
            - this method will not be called when Datasets are involved, 
        since the FILL() method will probably be called instead. The code below 
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
    
        @return ITableContext - the context for the request (num records, position etc). */
    method override public ITableResponse GetData():
        define variable oTableResponse as ITableResponse no-undo.
        define variable oTC as ITableContext no-undo.
        define variable hBuffer as handle no-undo.
        
        oTableResponse = new TableResponse(CurrentTableRequest:TableName).
                
        /* pop the target buffer into the context. not the 'database table' */
        if DataTargetType eq DataTypeEnum:Handle and
           DataTargetFormat eq DataFormatEnum:TempTable then
            hBuffer = HandleDataTarget.
        
        oTC = new TableContext(oTableResponse:TableName, hBuffer).
        oTableResponse:TableContext = oTC.
        
        /* update the context with the results of the fetch */
        @todo(task="implement", action="").
/*        oTC:PageSize = CurrentQuery:NumRows.*/
        
        return oTableResponse.
        finally:
            ClearDataTarget().
            CurrentQuery = ?.
            CurrentTableRequest = ?.
        end finally.
    end method.    
    
    /** Saves all records in the buffer argument to the physical data store. This
        buffer comes from the DataAccess object.
        
        This SaveData() call saves all records for a given table/buffer.
        
        @return ITableResponse The response to the save operation. */
    method override public ITableResponse SaveData():
        define variable oTableResponse as ITableResponse no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable hBeforeBuffer as handle no-undo.
        define variable hBeforeQry as handle no-undo.
        
        /* we know we want tod eal with a handle */
        hBuffer = ConvertTargetToHandle().
        hBeforeBuffer = hBuffer:before-buffer.
        
        create query hBeforeQry.
        hBeforeQry:set-buffers(hBeforeBuffer).
        hBeforeQry:query-prepare(" for each " + hBeforeBuffer:name).
        hBeforeQry:query-open().
        hBeforeQry:get-first().
        
        oTableResponse = new TableResponse(hBuffer:name).
        
        do while not hBeforeQry:query-off-end:
            /* Find the after-table row for this before-table row so that
               the validation logic can look at it (SAVE-ROW-CHANGES doesn't
               need it; it can do this on its own). If it's a Delete, then
               there *is* no after-table row. 
            if not hBeforeBuffer:row-state eq RowStateEnum:Deleted:Value then
                hBuffer:find-by-rowid(hBeforeBuffer:after-rowid).
               */
            SaveRowData(oTableResponse,
                        hBeforeBuffer,
                        Query:GetCurrentRowKey(hBeforeQry)).
            hBeforeQry:get-next().
        end.
        
        return oTableResponse.
        finally:
            hBeforeQry:query-close().
            
            delete object hBeforeQry no-error.
            delete object hBeforeBuffer no-error.
            hBeforeBuffer = ?.
                        
            ClearDataTarget().
            CurrentQuery = ?.
            CurrentTableRequest = ?.
        end finally.
    end method.

    /** Save data contained in the passed buffer to the database, in this case.
    
        Typically, there's only one key for the buffer.
        
        @param handle The buffer handle whose data is being committed.    
        @param character[] An array of unique keys that allow us to 
               find the row being saved. */
    method protected void SaveRowData(input poTableResponse as ITableResponse,      
                                      input phBuffer as handle,
                                      input pcRowKey as character extent):
        define variable iBufferIndex as integer no-undo.
        define variable iMax as integer no-undo.
                
        OnBeforeSaveTransaction(pcRowKey).
        if phBuffer:error then
            poTableResponse:ErrorText:Put(
                    new String(pcRowKey[1]),
                    new String(phBuffer:error-string)).
        else
        do transaction on error undo, throw:
            OnBeforeSave(pcRowKey).
            /* errors can be raised by setting the error flag or by throwing an error. */
            if phBuffer:error then
                poTableResponse:ErrorText:Put(
                        new String(pcRowKey[1]),
                        new String(phBuffer:error-string)). 
            else
            do:
                iMax = DataSourceHandle:num-source-buffers.
                do iBufferIndex = 1 to iMax: 
                    phBuffer:save-row-changes(iBufferIndex).
                end.
                /* make sure we commit the changes. */
                phBuffer:buffer-release().
                
                if phBuffer:error then
                    poTableResponse:ErrorText:Put(
                            new String(pcRowKey[1]),
                            new String(phBuffer:error-string)).
                else                
                do:
                    OnAfterSave(pcRowKey).
                    
                    if phBuffer:error then
                        poTableResponse:ErrorText:Put(
                                new String(pcRowKey[1]),
                                new String(phBuffer:error-string)). 
                end.                    
            end.    /* error */
        end.    /* transaction */
        
        OnAfterSaveTransaction(pcRowKey).
        if phBuffer:error then
            poTableResponse:ErrorText:Put(
                    new String(pcRowKey[1]),
                    new String(phBuffer:error-string)).
        
        /* If the DataSource validation events throw an error, make sure to add 
           the error to the the buffer and response object. */
           
        /** catch and propogate any ABL errors */
        catch eSysErr as SysError:
            phBuffer:error = true.
            phBuffer:error-string = eSysErr:GetMessage(1).
            
            poTableResponse:ErrorText:Put(
                    new String(pcRowKey[1]),
                    new String(phBuffer:error-string)).
        end catch.
        finally:
            if phBuffer:error then
                phBuffer:rejected = true.
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
    
    /** Override to ensure that we only allow handles - buffers or datasets - as data types here.  */
	method override public void SetDataTarget(input pcData as longchar,
	                                          input poDataTargetFormat as DataFormatEnum,
	                                          input poDataTargetType as DataTypeEnum):
        if not poDataTargetFormat:Equals(DataFormatEnum:ProDataSet) and
           not poDataTargetFormat:Equals(DataFormatEnum:TempTable) then                
                undo, throw new ArgumentError(
                        'The StandardDataSource only supports ProDataSets and Temp-tables for data targets',
                        'StandardDataSource:SetDataTarget:input poDataTargetFormat as DataFormatEnum').
        
		super:SetDataTarget(pcData, poDataTargetFormat, poDataTargetType).
	end method.
	
	/* this could be pushed up */
	method protected handle ConvertTargetToHandle():
	    define variable hTarget as handle no-undo.
	    
	    case DataTargetType:
	        when DataTypeEnum:Handle then
	        do:
        	    case DataTargetFormat:
                    when DataFormatEnum:ProDataSet then
                        hTarget = HandleDataTarget:get-buffer-handle(CurrentTableRequest:TableName).
                    when DataFormatEnum:TempTable then
                        hTarget = HandleDataTarget.
                end case.
            end.    /* handle */
            /* other need to be implemented */
            when DataTypeEnum:Memptr then .
            when DataTypeEnum:ProgressLangObject then .
            when DataTypeEnum:LongChar then .
        end case.
        
	    return hTarget.
    end method.
    
end class.