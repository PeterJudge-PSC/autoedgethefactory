/** ------------------------------------------------------------------------
    File        : StandardDataSource
    Purpose     : DataSource that populates a BE based on an ABL DB Table
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
using OpenEdge.DataSource.DataSourceQuery.

using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.SecurityManager.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ServiceManager.

using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.QueryBuffer.
using OpenEdge.Core.System.QuerySort.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.

using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.RowStateEnum.
using OpenEdge.Lang.String.

using Progress.Lang.SysError.
using Progress.Lang.Class.
using Progress.Lang.Object.


class OpenEdge.DataSource.StandardDataSource abstract use-widget-pool inherits DataSource:
    
    define protected property SecurityManager as ISecurityManager no-undo
        get():
            if not valid-object(SecurityManager) then
                SecurityManager = cast(cast(ABLSession:Instance:SessionProperties:Get(ServiceManager:ServiceManagerType), IServiceManager)
                                        :StartService(OpenEdge.CommonInfrastructure.Common.SecurityManager:SecurityManagerType), ISecurityManager).
            return SecurityManager.
        end get.
        set.
    
    /** The primary DB table that this IDataSource reads and writes to and from. There
        might be more than one source buffer for the ABL DATA-SOURCE, but this one is
        this IDataSource object's reason for existence (basically). */
    define abstract protected property PrimaryTable as handle no-undo get. set.
    
    /** The default field name in the schmema used to apply a tenant filter. By default,
        this is used with the Primary table; subsidiary tables should join off the primary
        table's values, although there's no requirement for that (ie they could also build
        their own tenant filters, in slightly different ways if needed). The defaults should
        suffice for most cases. I think. */
    define protected property TenantFilterFieldName as character no-undo get. set.
    
    /** The ABL DATA-SOURCE handles being used */
    define protected property ABLDataSources  as IMap no-undo get. set.
    define protected property AttachedActions as ICollection no-undo get. set.

	constructor public StandardDataSource(input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).

        assign ABLDataSources = new Map()
               AttachedActions = new Collection()
               TenantFilterFieldName = 'TenantId'.
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
        
        case poAction:
            when ServiceMessageActionEnum:FetchData then PrepareFetchData(poRequest, poDAO).
            when ServiceMessageActionEnum:SaveData then PrepareSaveData(poRequest, poDAO).
        end case.
    end method.
    
    /** Specific handling for FetchData requests.
        
        @param ITableRequest The current request
        @param IDataAccess The data access object making the request */
    method protected void PrepareFetchData(input poRequest as ITableRequest,
                                           input poDAO as IDataAccess):
        define variable cWhereClause as character no-undo.
        define variable hABLDataSource as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
        
        /* We want to add any extra filter/paging etc data from the request to the base query */
        oDSQuery = cast(ABLDataSources:Get(ServiceMessageActionEnum:FetchData), IQuery).
        
        FilterQueryPerRequest(oDSQuery:Definition, poRequest, poDAO).
        oDSQuery:Prepare().
        
        /* If there is more than one buffer in the query, set the QUERY attribute on the ABL DATA-SOURCE.
           If not, we'll set the FILL-WHERE-STRING if applicable. In all likelihood, we will have some form
           of filtering in 10.,2B at any rate, because of multi-tenancy having to be enforced in the application
           (ie here) */
        if oDSQuery:Definition:NumBuffers gt 1 then
            cast(oDSQuery, DataSourceQuery):ABLDataSource:query = oDSQuery:QueryHandle.
        else
        do:
            cWhereClause = oDSQuery:Definition:GetFilter(poDAO:ResolveTableName(poRequest:TableName)).
            
            if cWhereClause ne '' then
                cast(oDSQuery, DataSourceQuery):ABLDataSource:fill-where-string = ' where ' + cWhereClause.
        end.
        
        HandleDataTarget:fill-mode = FillMode:ToString().
    end method.
    
    /** Specific handling for SaveData requests.
        
        @param ITableRequest The current request
        @param IDataAccess The data access object making the request */
    method protected void PrepareSaveData(input poRequest as ITableRequest,
                                          input poDAO as IDataAccess):
        define variable oDSQuery as IQuery no-undo.
        
        oDSQuery = cast(ABLDataSources:Get(ServiceMessageActionEnum:SaveData), IQuery).
        
        /* If there is more than one buffer in the query, set the QUERY attribute on the ABL DATA-SOURCE.
           If not, we'll set the SAVE-WHERE-STRING if applicable. In all likelihood, we will have some form
           of filtering in 10.,2B at any rate, because of multi-tenancy having to be enforced in the application
           (ie here) */ 
        if oDSQuery:Definition:NumBuffers gt 1 then
            cast(oDSQuery, DataSourceQuery):ABLDataSource:query = oDSQuery:QueryHandle.
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
        define variable oDSQuery as IQuery no-undo.
        
        oDSQuery = cast(ABLDataSources:Get(CurrentActionType), IQuery).
        oDSQuery:Open().
        
        lAvailable = oDSQuery:GetFirst().
        if lAvailable then
            OnBeforeFill().
        
        do while lAvailable:
            cRowKey = oDSQuery:GetCurrentRowKey().
            HandleDataTarget:buffer-create().
            
            /* Get values and populate this-object:HandleDataTarget */
            OnBeforeRowFill(cRowKey).
            HandleDataTarget:buffer-copy(oDSQuery:QueryHandle:get-buffer-handle(HandleDataTarget:name)).
            OnAfterRowFill(cRowKey).
            
            HandleDataTarget:buffer-release().
            lAvailable = oDSQuery:GetNext().
        end.
        OnAfterFill().
        
        oDSQuery:Close().
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
/*        oTC:PageSize = CurrentDataStoreQuery:NumRows.*/
        
        return oTableResponse.
        finally:
            ClearDataTarget().
            
            /* go back to the base definition */
            cast(ABLDataSources:Get(CurrentActionType), IQuery):Reset().
            
            assign CurrentTableRequest = ?
                   CurrentActionType = ?
                   CurrentDAO = ?.
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
        define variable oDSQuery as DataSourceQuery no-undo.
        
        /* we know we want to deal with a handle */
        hBuffer = ConvertTargetToHandle().
        hBeforeBuffer = hBuffer:before-buffer.
        
        create query hBeforeQry.
        hBeforeQry:set-buffers(hBeforeBuffer).
        hBeforeQry:query-prepare(' for each ' + hBeforeBuffer:name ).
        hBeforeQry:query-open().
        hBeforeQry:get-first().
        
        oDSQuery = cast(ABLDataSources:Get(ServiceMessageActionEnum:SaveData), DataSourceQuery).
        
        oTableResponse = new TableResponse(CurrentTableRequest:TableName).
        
        do while not hBeforeQry:query-off-end:
            /* Find the after-table row for this before-table row so that
               the validation logic can look at it (SAVE-ROW-CHANGES doesn't
               need it; it can do this on its own). If it's a Delete, then
               there *is* no after-table row. 
               
               if not hBeforeBuffer:row-state eq RowStateEnum:Deleted:Value then
               hBuffer:find-by-rowid(hBeforeBuffer:after-rowid).
               
               The RowKey we use is the row key for the Business Entity table and
               not the DB table. */
            
            if not hBeforeBuffer:row-state eq RowStateEnum:Deleted:Value then
                hBuffer:find-by-rowid(hBeforeBuffer:after-rowid).
            else
                hBuffer = hBeforeBuffer.
            
            SaveSingleRow(oTableResponse,   /* for errors */
                          hBeforeBuffer,    /* contains changed data */
                          oDSQuery,         /* datasource/datastore query (ie how to find DB record) */
                          Query:GetBufferRowKey(hBuffer) ).  /* row keys of source (ie prodataset actual buffer) */
            
            hBeforeQry:get-next().
        end.
        
        return oTableResponse.
        finally:
            hBeforeQry:query-close().
            
            delete object hBeforeQry no-error.
            delete object hBeforeBuffer no-error.
            hBeforeBuffer = ?.
            
            ClearDataTarget().
            
            /* go back to the base definition */
            cast(ABLDataSources:Get(ServiceMessageActionEnum:SaveData), IQuery):Reset().
            
            assign CurrentTableRequest = ?
                   CurrentActionType = ?
                   CurrentDAO = ?.
        end finally.
    end method.
    
    /** Constructs a where clause for saving a record to the database.  
        
        @param integer The ordinal position of the buffer in the datasource. Usually (?) 1.
        @param character The source buffer's keys.
        @param handle The source/prodataset before buffer
        @return character A WHERE clause for the datasource buffer  */
        
    method protected character BuildBufferKeyClause(input pcDatasourceBufferName as character,
                                                    input poDSQuery as DataSourceQuery,
                                                    input phSourceBuffer as handle):
        define variable oFilters as ICollection no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oFilter as QueryFilter no-undo.
        define variable cWhereString as character no-undo.
        define variable cFieldValue as character no-undo.
        define variable hField as handle no-undo.
        
        /* get the base where string */
        cWhereString = cast(poDSQuery, IQuery):Definition:GetFilter(pcDatasourceBufferName).
        if cWhereString eq ? or cWhereString eq '' then
            cWhereString = ' where true '. 
        
        oFilters = cast(poDSQuery:SourceKeyFilters:Get(new String(pcDatasourceBufferName)), ICollection).                                                            
        oIterator = oFilters:Iterator().
        do while oIterator:HasNext():
            oFilter = cast(oIterator:Next(), QueryFilter).
            
            /* first try to get the value from the source buffer */
            hField = phSourceBuffer:buffer-field(
                            CurrentDAO:ResolveFieldName(pcDatasourceBufferName, oFilter:FieldName)) no-error.
            
            if valid-handle(hField) then
                cFieldValue = hField:buffer-value.
            
            /* The key filters have a &1 as a field value, for just this purpose. */
            cWhereString = cWhereString + substitute(oFilter:ToString(), cFieldValue).
        end.
        
        message this-object this-object:GetClass():TypeName program-name(1) program-name(2) skip(2)
        cWhereString
        
        view-as alert-box error title '[PJ DEBUG]'.
        
        return cWhereString.
    end method.

    /** Save data for the current row to the database.
        
        @param ITableResponse The table response object for this save request. Used in case of errors.
        
        @param handle The buffer containing the date being saved (the source buffer).
               This is usually the before-image buffer from the Business Entity.
        
        @param DataSourceQuery The query used to find the actual for the ABL Data-source 
        
        @param character The key field values for the source buffer above. We don't derive these from 
               the source buffer since if it is indeed the BEFORE-BUFFER, the keys are the ROWID used 
               to get to the AFTER-BUFFER, and NOT the keys on the actual Business Entity buffer.   */
    method protected void SaveSingleRow(input poTableResponse as ITableResponse,
                                        input phSourceBuffer as handle,
                                        input poDSQuery as DataSourceQuery,
                                        input pcSourceRowKey as character):
                                                    
        define variable iBufferIndex as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oFilter as QueryFilter no-undo.
        define variable hTargetBuffer as handle no-undo.
        define variable hABLDataSource as handle no-undo.
        define variable cRowKey as character extent 1 no-undo.
        
        cRowKey[1] = pcSourceRowKey.
        
        OnBeforeSaveTransaction(cRowKey).
        if phSourceBuffer:error then
            poTableResponse:ErrorText:Put(
                    new String(cRowKey[1]),
                    new String(phSourceBuffer:error-string)).
        else
        do transaction on error undo, throw:
            OnBeforeSave(cRowKey).
            /* errors can be raised by setting the error flag or by throwing an error. */
            if phSourceBuffer:error then
                poTableResponse:ErrorText:Put(
                        new String(cRowKey[1]),
                        new String(phSourceBuffer:error-string)).
            else
            do:
                assign hABLDataSource = cast(ABLDataSources:Get(CurrentActionType), DataSourceQuery):ABLDataSource
                       iMax = hABLDataSource:num-source-buffers.
                do iBufferIndex = 1 to iMax:
                    /* build the where string */
                    hABLDataSource:save-where-string(iBufferIndex) 
                            = BuildBufferKeyClause(
                                    hABLDataSource:get-source-buffer(iBufferIndex):name,   /* for identification */
                                    poDSQuery, /* for filters */
                                    phSourceBuffer).    /* for data */                                                                            
                    /* do save */
                    phSourceBuffer:save-row-changes(iBufferIndex).
                end.
                
                if phSourceBuffer:error then
                    poTableResponse:ErrorText:Put(
                            new String(cRowKey[1]),
                            new String(phSourceBuffer:error-string)).
                else
                do:
                    OnAfterSave(cRowKey).

                    /* make sure we commit the changes. */
                    phSourceBuffer:buffer-release().
                    
                    if phSourceBuffer:error then
                        poTableResponse:ErrorText:Put(
                                new String(cRowKey[1]),
                                new String(phSourceBuffer:error-string)). 
                end.                    
            end.    /* error */
        end.    /* transaction */
        
        OnAfterSaveTransaction(cRowKey).
        if phSourceBuffer:error then
            poTableResponse:ErrorText:Put(
                    new String(cRowKey[1]),
                    new String(phSourceBuffer:error-string)).
        
        /* If the DataSource validation events throw an error, make sure to add 
           the error to the the buffer and response object. */
           
        /** catch and propogate any ABL errors */
        catch eSysErr as SysError:
            phSourceBuffer:error = true.
            phSourceBuffer:error-string = eSysErr:GetMessage(1).
            
            poTableResponse:ErrorText:Put(
                    new String(cRowKey[1]),
                    new String(phSourceBuffer:error-string)).
        end catch.
        finally:
            if phSourceBuffer:error then
                phSourceBuffer:rejected = true.
        end finally.
    end method.
    
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
    
    method protected void FilterQueryPerRequest(input poQueryDefinition as IQueryDefinition,
                                                input poRequest as ITableRequest,
                                                input poDAO as IDataAccess):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oBuffer as QueryBuffer no-undo.
        define variable oFilter as QueryFilter no-undo.
        define variable oJoin as QueryJoin no-undo.
        define variable oSort as QuerySort no-undo.
        define variable oElements as Object extent no-undo.
        define variable oDefinition as IQueryDefinition no-undo.
        define variable cResolvedBuffer as character no-undo.
        
        oElements = cast(poRequest, IQueryDefinition):GetQueryElements().
        iMax = extent(oElements).
        
        do iLoop = 1 to iMax:
            case oElements[iLoop]:GetClass():
                when Class:GetClass('OpenEdge.Core.System.QueryBuffer') then
                do:
                    oBuffer = cast(oElements[iLoop], QueryBuffer).
                    poQueryDefinition:AddBuffer(
                        poDAO:ResolveTableName(oBuffer:Name),
                        poDAO:ResolveTableName(oBuffer:TableName),
                        oBuffer:QueryType,
                        oBuffer:LockMode).
                end.

                when Class:GetClass('OpenEdge.Core.System.QueryFilter') then
                do:
                    oFilter = cast(oElements[iLoop], QueryFilter).
                    cResolvedBuffer = poDAO:ResolveTableName(oFilter:BufferName). 
                    poQueryDefinition:AddFilter(
                        cResolvedBuffer,
                        poDAO:ResolveFieldName(oFilter:BufferName, oFilter:FieldName),
                        oFilter:Operator,
                        oFilter:FieldValue,
                        oFilter:FieldType,
                        oFilter:JoinType).
                end.

                when Class:GetClass('OpenEdge.Core.System.QueryJoin') then
                do:
                    oJoin = cast(oElements[iLoop], QueryJoin).
                    poQueryDefinition:AddJoin(
                        poDAO:ResolveTableName(oJoin:BufferName),
                        poDAO:ResolveFieldName(oJoin:BufferName, oJoin:FieldName),
                        oJoin:Operator,
                        poDAO:ResolveTableName(oJoin:JoinBufferName),
                        poDAO:ResolveFieldName(oJoin:JoinBufferName, oJoin:JoinFieldName),
                        oJoin:JoinType).
                end.

                when Class:GetClass('OpenEdge.Core.System.QuerySort') then                
                do:
                    oSort = cast(oElements[iLoop], QuerySort).
                    poQueryDefinition:AddSort(
                        poDAO:ResolveTableName(oSort:BufferName),
                        poDAO:ResolveFieldName(oSort:BufferName, oSort:FieldName),
                        oSort:Direction).
                end.
            end case.
        end.
    end method.
    
    /** Adds filtering by tenant to for a given action. 
        
        @param ServiceMessageActionEnum The current request's action type. */
    method override protected void AddTenantFilter(input poAction as ServiceMessageActionEnum):                              
        define variable oDSQuery as IQuery no-undo.
        define variable oFilter as QueryFilter no-undo.
        define variable hField as handle no-undo.
        
        oDSQuery = cast(ABLDataSources:Get(poAction), IQuery).
        
        /* always try to filter by tenant */
        if SecurityManager:IsManagedSession then
            /* no-error since this field may not exist */
            hField = PrimaryTable:buffer-field(TenantFilterFieldName) no-error.
        
        if valid-handle(hField) then
            oFilter = new QueryFilter(
                            PrimaryTable:Name,
                            TenantFilterFieldName,
                            OperatorEnum:IsEqual,
                            cast(SecurityManager:CurrentUserContext:TenantId:Get(new String(PrimaryTable:dbname)), String),
                            DataTypeEnum:LongChar,
                            JoinEnum:And).
        
        if valid-object(oFilter) then
            oDSQuery:Definition:AddFilter(oFilter).
    end method.
    
    method override protected void CreateDataStore():
        define variable hABLDataSource as handle no-undo.
        define variable oDSQuery as IQuery no-undo.
    
        if not ABLDataSources:ContainsKey(ServiceMessageActionEnum:FetchData) then
        do:
            create data-source hABLDataSource.
            hABLDataSource:add-source-buffer(PrimaryTable, PrimaryTable:keys).
            
            ABLDataSources:Put(ServiceMessageActionEnum:FetchData, 
                               new DataSourceQuery(hABLDataSource)).
        end.
        
        /* Use a simple datasource using the PrimaryTable and its keys */
        if not ABLDataSources:ContainsKey(ServiceMessageActionEnum:SaveData) then
        do:
            create data-source hABLDataSource.
            hABLDataSource:add-source-buffer(PrimaryTable, PrimaryTable:keys).
            
            ABLDataSources:Put(ServiceMessageActionEnum:SaveData, 
                               new DataSourceQuery(hABLDataSource)).
        end.
    end method.
    
    method override protected void DeleteDataStore():
        define variable oIterator as IIterator no-undo.
        define variable oAction as ServiceMessageActionEnum no-undo.
        
        oIterator = ABLDataSources:KeySet:Iterator().
        
        do while oIterator:HasNext():
            oAction = cast(oIterator:Next(), ServiceMessageActionEnum).
            
            /* detach first, just in case */
            DetachDataStoreFromTarget(oAction).
            delete object cast(ABLDataSources:Remove(oAction), DataSourceQuery):ABLDataSource no-error.
        end.
    end method.
    
    method override protected void AttachDataStoreToTarget(input poServiceMessageAction as ServiceMessageActionEnum):
        define variable hABLDataSource as handle no-undo.
        
        hABLDataSource = cast(ABLDataSources:Get(poServiceMessageAction), DataSourceQuery):ABLDataSource. 
        hABLDataSource:prefer-dataset = true.
        ConvertTargetToHandle():attach-data-source(hABLDataSource).
        
        AttachedActions:Add(poServiceMessageAction).
    end method.
    
    method override protected void DetachDataStoreFromTarget(input poServiceMessageAction as ServiceMessageActionEnum):
        if AttachedActions:Contains(poServiceMessageAction) then
        do:
            ConvertTargetToHandle():detach-data-source().
            AttachedActions:Remove(poServiceMessageAction). 
        end.
    end method.
    
    method protected void OnBeforeRowFill(input pcRowKey as character extent,
                                          input phSourceBuffer as handle,
                                          input phTargetBuffer as handle):
        
        OnBeforeRowFill(new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.

end class.