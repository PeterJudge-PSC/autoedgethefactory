/** ------------------------------------------------------------------------
    File        : DataSource
    Purpose     : Default Datasource 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 11 20:09:22 EST 2010
    Notes       :  
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.IDataSource.
using OpenEdge.DataSource.DataSourceEventArgs.
using OpenEdge.DataSource.DataSourceEventEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.

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
using OpenEdge.Core.System.ArgumentError.
 
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.FillModeEnum.
using OpenEdge.Lang.RowStateEnum.
using OpenEdge.Lang.ABLSession.

using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.DataSource.DataSource abstract use-widget-pool
        implements IDataSource:
    
    /** The data transport type for this message. These may differ for request and response. */
    define protected property DataTargetFormat as DataFormatEnum no-undo get. private set.
    define protected property DataTargetType as DataTypeEnum no-undo get. private set.
    
    /** Individual data target stores. Manipulated by SetDataTarget(), and GetDataTarget() */
    define protected property HandleDataTarget as handle   no-undo get. private set.
    define protected property MemptrDataTarget as memptr   no-undo get. private set.
    define protected property LongCharDataTarget as longchar no-undo get. private set.    
    define protected property ObjectDataTarget as Object   no-undo get. private set.
    
    define protected property CurrentRequest as IServiceRequest no-undo get. set.
     
    /** The default Page or batch size for this datasource. Can be overridden
        by the page size on the table request. */
    define public property PageSize as integer no-undo get. set.
    
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
    
    constructor public DataSource ():
        CreateDataStore().
    end constructor.

    destructor public DataSource ():
        DeleteDataStore().
        ClearDataTarget().
    end destructor.
    
    /** Creates the actual datasource - this could be an ABL datasource, or some other 
        mechanism (XML or a service or something else). These are specific to each 
        datasource instance, and thus is abstract. 
        
        For example, for an ABL/ProDataSet data source:
            
            <code>
            
            CREATE DATA-SOURCE srcCar.
            </code>
      */
    method abstract protected void CreateDataStore().
    /* Deletes the datastore once done. */
    method abstract protected void DeleteDataStore().
    
    /** Attaches the actual datasource - this could be an ABL datasource, or some other 
        mechanism (XML or a service or something else). These are specific to each 
        datasource instance, and thus is abstract. 
        
        For example, for an ABL/ProDataSet data source:           
            <code>
            DATA-SOURCE srcCar:HANDLE:prefer-dataset = TRUE.
            hBuffer:ATTACH-DATA-SOURCE(DATA-SOURCE srcCar:HANDLE,"").
            </code>        */
    method abstract protected void AttachDataStoreToTarget().
    /** Detaches the datastore from the datatarget  */
    method abstract protected void DetachDataStoreFromTarget().
    
    /** Prepare with query, batchsize and more.
    
       @param ITableRequest Parameters for the fetch (query modifications, page size etc). */
    method abstract public void Prepare(input poRequest as ITableRequest).
    
    /** This SetDataTarget override is provided since the bulk of datatargets in ABL
        will be buffers (possibly datasets).
        
        An exception will be thrown if the handle has a type of anything other than 
        'buffer' or 'dataset'.  
        
        @param handle A buffer or dataset handle that is the data target. */
    method public void SetDataTarget(input phData as handle):
        define variable oDataTargetFormat as DataFormatEnum no-undo.
        
        case phData:type:
            when 'buffer' then oDataTargetFormat = DataFormatEnum:TempTable.
            when 'dataset' then oDataTargetFormat = DataFormatEnum:ProDataSet.
            otherwise 
                undo, throw new ArgumentError('Handle must be buffer or dataset', 'DataSource:SetDataTarget:phData').
        end case.
        
        SetDataTarget(string(phData), oDataTargetFormat, DataTypeEnum:Handle).
    end method.
    
    /** SetDataTarget() methods are called by the DataAccess object, to specify 
        the target for the DataSource's operations (usually the fill/fetch). 
        
        This data is formatted per the DataTargetFormat above;
        and is stored in the message as either LONGCHAR, MEMPTR, HANDLE or P.L.O. */
    method public void SetDataTarget(input pcData as longchar,
                                     input poDataTargetFormat as DataFormatEnum,
                                     input poDataTargetType as DataTypeEnum):
        assign DataTargetFormat = poDataTargetFormat
               DataTargetType = poDataTargetType.
                
        case poDataTargetType:
            when DataTypeEnum:Handle then HandleDataTarget = widget-handle(string(pcData)).
            when DataTypeEnum:Memptr then copy-lob pcData to MemptrDataTarget.
            when DataTypeEnum:ProgressLangObject then ObjectDataTarget = ABLSession:Instance:ResolveWeakReference(integer(pcData)).
            when DataTypeEnum:LongChar then LongCharDataTarget = pcData.
        end case.
        
        /* Now attach the physical data store to the data target */
        AttachDataStoreToTarget().                                                            
    end method.
    
        /** Clears the Datatarget and associated properties */
    method public void ClearDataTarget():
        DetachDataStoreFromTarget().
        
        assign HandleDataTarget = ?
               ObjectDataTarget = ?
               LongCharDataTarget = ?
               
               DataTargetFormat = ?
               DataTargetType = ?
               .
        set-size(MemptrDataTarget) = 0.
    end method.
    
    /** A helper for retrieving the data target in longchar form again. Performs
        the inverse of the SetDataTarget() method; this is basically just a STRING()
        of the value or reference.
        
        @return longchar
     */
    method public longchar GetDataTarget():
        define variable cValue as longchar no-undo.
        
        case DataTargetType:
            when DataTypeEnum:Handle then cValue = string(HandleDataTarget).
            when DataTypeEnum:Memptr then copy-lob MemptrDataTarget to cValue.
            when DataTypeEnum:ProgressLangObject then cValue = string(integer(ObjectDataTarget)).
            when DataTypeEnum:LongChar then cValue = LongCharDataTarget.
        end case.
        
        return cValue.
    end method.
    
    /** Perform fetch: populate the data target from the physical data store. */        
    method abstract public void FetchData().
    
    /** Called on completion of a data fetch request, typically by the data access object.
        @return ITableContext - the context for the request (num records, position etc). */
    method abstract public ITableResponse GetData().
    
    /** Saves all records in the buffer argument to the physical data store. This
        buffer comes from the DataAccess object.
    
        @return ITableResponse The response to the save operation. */
    method abstract public ITableResponse SaveData().
    
    /* Save events */
    method protected void OnBeforeSaveTransaction(input pcRowKey as character extent):
        this-object:BeforeSaveTransaction:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnBeforeSave (input pcRowKey as character extent):
        this-object:BeforeSave:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnAfterSave(input pcRowKey as character extent):
        this-object:AfterSave:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnAfterSaveTransaction(input pcRowKey as character extent):
        this-object:AfterSaveTransaction:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnBeforeFill():
        define variable cDummy as character extent no-undo.
        
        this-object:BeforeFill:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        cDummy)).
    end method.

    method protected void OnBeforeRowFill(input pcRowKey as character extent):
        this-object:BeforeRowFill:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnAfterRowFill(input pcRowKey as character extent):
        this-object:AfterRowFill:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        pcRowKey)).
    end method.
    
    method protected void OnAfterFill():
        define variable cDummy as character extent no-undo.
        
        this-object:AfterFill:Publish(
                this-object,
                new DataSourceEventArgs(
                        DataSourceEventEnum:BeforeSaveTransaction,
                        this-object:DataTargetFormat,
                        this-object:DataTargetType,                        
                        GetDataTarget(),
                        cDummy)).
    end method.
    
end class.