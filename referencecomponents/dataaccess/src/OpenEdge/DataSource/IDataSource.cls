/** ------------------------------------------------------------------------
    File        : IDataSource
    Purpose     : General Datasource interface.
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Wed Feb 10 01:30:45 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.DataSource.DataSourceEventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Lang.FillModeEnum.
using Progress.Lang.Object.

interface OpenEdge.DataSource.IDataSource: /* inherits IQuery */

    /* DataSource Fetch/Fill events. These map to ProDataSet callbacks, although the events below are only fired
       in cases where PerformFetch() is called. This is typically not the case for ProDataSets, since the PDS:Fill()
       method will be called from the DataAccess, rather than the Datasource. */
    define public event BeforeFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event BeforeRowFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterRowFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterFill signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    
    /* DataSource Save/Commit events */
    define public event BeforeSaveTransaction signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event BeforeSave            signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterSave             signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    define public event AfterSaveTransaction  signature void(input poSender as Object, input poEventArgs as DataSourceEventArgs).
    
    /** The default Page or batch size for this datasource. Can be overridden
        by the page size on the table request. */
    define property PageSize as integer no-undo get. set.
    
    /** The default Fill mode for fetch requests. */
    define property FillMode as FillModeEnum no-undo get. set.
    
    /** Prepare with query, batchsize and more.

        @param ITableRequest Parameters for the fetch (query modifications, page size etc). */
    method public void PrepareForFetch(/*input phBuffer as handle,*/ input poRequest as ITableRequest).

    /** The SetDataTarget() methods are called by the DataAccess object, to specify 
        the target for the DataSource's operations (usually the fill/fetch). 
        
        This data is formatted per the MessageDataFormat above;
        and is stored in the message as either LONGCHAR, MEMPTR, HANDLE or P.L.O. */
    method public void SetDataTarget(input pmData as longchar,
                                     input poMessageDataFormat as DataFormatEnum).
    method public void SetDataTarget(input pmData as memptr,
                                     input poMessageDataFormat as DataFormatEnum).
    method public void SetDataTarget(input phData as handle,
                                     input poMessageDataFormat as DataFormatEnum).
    method public void SetDataTarget(input poData as Object,
                                     input poMessageDataFormat as DataFormatEnum).
    
    /** Perform fetch: populate the previously-passed buffer from the
        physical data store.
        
        The caller needs to call GetData() afterwards if they want 
        any additional information about the fetch call (stuff that's
        in ITableContext). */
    method public void PerformFetch().
    
    /** Retrieves the results of a fetch */
    method public ITableResponse GetData().
    
    /** Saves all data in the buffer passed in.
    
        @param handle The buffer containing data to save. */
    method public void SaveData (input phBuffer as handle).
    
end interface.