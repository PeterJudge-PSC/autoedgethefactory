/*------------------------------------------------------------------------
    File        : IModel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Dec 18 15:51:15 EST 2008
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Model.IModel.
using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using OpenEdge.PresentationLayer.Common.ModelErrorEventArgs.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.Core.System.IQueryDefinition.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.Model.IModel /* inherits IComponent */:
    define public property ErrorBuffer as character extent no-undo get. set.
    
    /* The name of the service from which this Model gets its data */
    define public property ServiceName as character no-undo get.
    
    method public handle GetBindingHandle(pcQuery as char).
       
    /* Events */ 
    
    /* These are local (on model's datastore) events */
    define public event DataAdd     signature void (poSender as IComponent, poEventArgs as ModelEventArgs). /* ModelEventArgs -> ???EventArgs */
    define public event DataDelete  signature void (poSender as IComponent, poEventArgs as ModelEventArgs).
    define public event DataSave    signature void (poSender as IComponent, poEventArgs as ModelEventArgs).
    
    /**  Event handlers */
    @todo(task="from ClientServiceManager  EventArgs or more specific?").
    /* This fires after ReceiveData (should not fire when presenter subscribes) */ 
    method public void DataFetchedHandler (poComponent as IComponent,poEventArgs as EventArgs).
    /** fetch data 
      */
    /* Fetch data for all tables */ 
    method public void FetchData().
    /* Fetch data for a table request (including children)  */ 
    method public void FetchData(poTableRequest as ITableRequest).
    /* Fetch data for all queries */
    method public void FetchDataForQueries().
    
    /* Fetch data for a table request (including children)  */ 
    method public void FetchDataForQueries(poTableRequest as ITableRequest).
    
    /** BuildRequest 
        Allows you to bundle requests for multiple datasets. The Corresponding response need to 
        be passed to ReceiveData. This is typically managed through the ClientServiceManager. */   
    
    /* build request for all tables */
    method public IFetchRequest BuildRequest().
    
    /* build request for specified tables */
    method public IFetchRequest BuildRequest(pcTables as char extent).
    
    /* build request for all queries */
    method public IFetchRequest BuildRequestFromQueries().
    
    /* build request for specified queries */
    method public IFetchRequest BuildRequestFromQueries(pcTables as char extent).
    
    /* Receive data from service 
       Should only deal with the response data and information 
       The actual action (i.e. openquery/closequery) should be handled in DataFetchedHandler, 
       which could be subscribed here or by the presenter   
       (the class should probably implement a protected AfterReceiveData hook, since
        data could need to be manipulated before the event fires )*/
    method public void ReceiveData (poResponse as IFetchResponse).
  
    method public void CommitData().
    method public void CollectChanges().
    method public logical MergeChanges(pcQuery as char).
    
    /* Get field values  */
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pcValue as char).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pcValue as char extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pcValue as longchar).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pcValue as longchar extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output phValue as handle).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output phValue as handle extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output piValue as int).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output piValue as int extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output piValue as int64).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output piValue as int64 extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pdValue as decimal).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output pdValue as decimal extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as date).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as date extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as datetime).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as datetime extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as datetime-tz).    
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output ptValue as datetime-tz extent).    
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output prValue as raw).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output prValue as raw extent).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output poValue as Object).
    method public void GetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, output poValue as Object extent).

    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pcValue as char).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pcValue as char extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pcValue as longchar).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pcValue as longchar extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, phValue as handle).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, phValue as handle extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, piValue as int).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, piValue as int extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, piValue as int64).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, piValue as int64 extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pdValue as decimal).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, pdValue as decimal extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as date).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as date extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as datetime).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as datetime extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as datetime-tz).    
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, ptValue as datetime-tz extent).    
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, prValue as raw).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, prValue as raw extent).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, poValue as Object).
    method public logical SetValue(pcBufferName as char, pcRecordKey as char,  pcFieldName as char, poValue as Object extent).
    
    /* Query manipulation */
    /* create default querydefinition for table */ 
    method public void CreateQuery(pcQueryName as char, pcTable as char).
    method public void CreateQuery(pcQueryName as char, poQueryDefinition as IQueryDefinition).
    method public IModelQuery GetQuery(pcQueryName as char).
    method public void DeleteQuery(pcQuery as char).
    
    /* Record operations */
    method public character AddRecord(pcBufferName as char).
    method public void SaveRecord(pcBufferName as char, pcRecordKey as char).    
    method public void DeleteRecord(pcBufferName as char, pcRecordKey as char).
    
    method public void ValidateField(pcAction as integer,
                                     pcFieldName as char,
                                     phBeforeField as handle,
                                     phAfterField as handle).
    
    /* ProDataset-based Models will use callbacks to do this */
    method public void ValidateRow (pcAction as integer,
                                    phBeforeBuffer as handle,
                                    phAfterBuffer as handle).
    
    method public ModelErrorEventArgs ProcessModelErrors(pcBufferName as char).
    
end interface.