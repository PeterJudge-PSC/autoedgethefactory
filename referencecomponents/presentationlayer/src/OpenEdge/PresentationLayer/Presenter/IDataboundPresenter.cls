/** ------------------------------------------------------------------------
    File        : IDataboundPresenter
    Purpose     : Interface for presenter for databound mvp triads
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 06 14:13:18 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.PresentationLayer.Presenter.IDataboundPresenter.
using OpenEdge.PresentationLayer.Model.IModel.
using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Common.ModelErrorEventArgs.
using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using OpenEdge.PresentationLayer.Common.NavigationPanelEventArgs.
using OpenEdge.PresentationLayer.Common.UpdatePanelEventArgs.
using OpenEdge.PresentationLayer.Common.UndoActionEventArgs.
using OpenEdge.PresentationLayer.Common.DataFetchEventArgs.

using OpenEdge.CommonInfrastructure.Common.UpdateActionEnum.
using OpenEdge.CommonInfrastructure.Common.IComponentCollection.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Lang.FindTypeEnum.

using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.Presenter.IDataboundPresenter:
    /** Events */
    define public event NavigationPanelStateChanged signature void (input poComponent as IComponent, input poEventArgs as NavigationPanelEventArgs).
    define public event UpdatePanelStateChanged signature void (input poComponent as IComponent, input poEventArgs as UpdatePanelEventArgs).
    define public event DataFetchError  signature void (input poComponent as IComponent, input poEventArgs as ModelErrorEventArgs).
    define public event DataCommitError signature void (input poComponent as IComponent, input poEventArgs as ModelErrorEventArgs).    
    define public event DataSaveError   signature void (input poComponent as IComponent, input poEventArgs as ModelErrorEventArgs).
    define public event DataDeleteError signature void (input poComponent as IComponent, input poEventArgs as ModelErrorEventArgs).
    define public event AddUndoAction   signature void (input poComponent as IComponent, input poEventArgs as UndoActionEventArgs).
    
    /**  Event handlers */
    @todo(task="from ClientServiceManager  (EventArgs or more specific?)").
    method public void DataFetchedHandler (input poComponent as IComponent, input poEventArgs as DataFetchEventArgs).
    
    /* query events - Note: Query/ModelQuery does not implement IComponent  */
    method public void QueryClosedHandler(input poQuery as IModelQuery, input poEventArgs as EventArgs).
    method public void QueryOpenedHandler(input poQuery as IModelQuery, input poEventArgs as EventArgs).
    method public void QueryRepositionedHandler(input poQuery as IModelQuery, input poEventArgs as EventArgs).
    
    /** Get individual field values */
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pcValue as char).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pcValue as char extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pcValue as longchar).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pcValue as longchar extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output phValue as handle).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output phValue as handle extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output piValue as int).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output piValue as int extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output piValue as int64).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output piValue as int64 extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pdValue as decimal).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output pdValue as decimal extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as date).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as date extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as datetime).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as datetime extent).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as datetime-tz).    
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output ptValue as datetime-tz extent).    
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output prValue as raw).
    method public void GetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, output prValue as raw extent).
    
    /** Set individual field values */
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pcValue as char).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pcValue as char extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pcValue as longchar).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pcValue as longchar extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input phValue as handle).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input phValue as handle extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input piValue as int).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input piValue as int extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input piValue as int64).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input piValue as int64 extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pdValue as decimal).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input pdValue as decimal extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as date).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as date extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as datetime).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as datetime extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as datetime-tz).    
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input ptValue as datetime-tz extent).    
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input prValue as raw).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input prValue as raw extent).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input poValue as Object).
    method public logical SetValue(input poModelService as IComponentInfo, input pcRecordKey as char, input pcBuffer as char, input pcField as char, input poValue as Object extent).
    
    /** manage selection */
    method public integer GetNumSelectedRows(input poModelService as IComponentInfo, input pcQueryName as char).
    method public character extent GetSelectedRowKey(input poModelService as IComponentInfo, input pcQueryName as char, input piSelect as int).
    
    /* piSelect is selection ordinal - not query */
    method public void ClearSelection(input poModelService as IComponentInfo, input pcQueryName as char).
    method public void SelectCurrentRow(input poModelService as IComponentInfo, input pcQueryName as char).
    method public void SelectRow(input poModelService as IComponentInfo, input pcQueryName as char, input pcRowKey as character extent).
    method public void DeselectCurrentRow(input poModelService as IComponentInfo, input pcQueryName as char).
    method public void DeselectRow(input poModelService as IComponentInfo, input pcQueryName as char, input pcRowKey as character extent).
    
    /** use default query (create a default IQueryDefinition from table ) */
    method public void CreateQuery(input poModelService as IComponentInfo,
                                   input pcQueryName as char,
                                   input pcTableName as char).
    /** These are only meant to be called by another Presenter, NOT any Views */
    method public void CreateQuery(input poModelService as IComponentInfo,
                                   input pcQueryName as char,
                                   input poQueryDefinition as IQueryDefinition).
    
    method public void DeleteQuery(input poModelService as IComponentInfo, input pcQuery as char).
    method public IQueryDefinition GetQueryDefinition(input poModelService as IComponentInfo, input pcQuery as char).
    method public IModelQuery GetQuery(input poModelService as IComponentInfo, input pcQuery as char).
    
    method public void OpenQuery(input poModelService as IComponentInfo, input pcQuery as char).
    method public void ReopenQuery(input poModelService as IComponentInfo, input pcQuery as char).
    method public void CloseQuery(input poModelService as IComponentInfo, input pcQuery as char).    
    
    method public logical GetFirst(input poModelService as IComponentInfo, input pcQuery as char).
    method public logical GetPrev(input poModelService as IComponentInfo, input pcQuery as char).
    method public logical GetNext(input poModelService as IComponentInfo, input pcQuery as char).
    method public logical GetLast(input poModelService as IComponentInfo, input pcQuery as char).
    method public logical GetRowAtKey(input poModelService as IComponentInfo, input pcQuery as char, input pcRowKey as char extent).
    method public logical GetRowAtPosition(input poModelService as IComponentInfo, input pcQuery as char, input piPos as int).
    method public logical GetRowWhere(input poModelService as IComponentInfo,
                                      input pcQuery as char,
                                      input poQueryDefinition as IQueryDefinition,
                                      input poFindType as FindTypeEnum).
      
    /* Fetches data for all Models */
    method public void FetchData ().    
    /* Fetches data for specified Model(s) */
    method public void FetchData (input poModelService as IComponentInfo).
    method public void FetchData (input poModelService as IComponentInfo extent).
    
    method public void CommitData().    /* all */
    method public void CommitData(input poModelService as IComponentInfo). /* one */
    method public void CommitData(input poModelService as IComponentInfo extent).  /* many */
    
    /* Model Operations */
    method public character AddRecord(input poModelService as IComponentInfo, input pcQuery as char, pcTable as char).
    method public void SaveRecord(input poModelService as IComponentInfo, input pcQuery as char, pcTable as char).
    method public void DeleteRecord(input poModelService as IComponentInfo, input pcQuery as char, pcTable as char).
    method public void UndoAction(input poModelService as IComponentInfo,
                                  input pcQuery as char,
                                  input pcTable as char,
                                  input poAction as UpdateActionEnum,
                                  input pcCurrentRowKey as char extent).
end interface.