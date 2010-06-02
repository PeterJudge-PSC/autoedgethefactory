/*------------------------------------------------------------------------
    File        : IDataboundPresenter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 06 14:13:18 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.PresentationLayer.Presenter.IDataboundPresenter.
using OpenEdge.PresentationLayer.Model.IModel.
using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Common.ModelErrorEventArgs.
using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using OpenEdge.PresentationLayer.Common.NavigationPanelEventArgs.
using OpenEdge.PresentationLayer.Common.UpdatePanelEventArgs.
using OpenEdge.PresentationLayer.Common.UndoActionEventArgs.
using OpenEdge.PresentationLayer.Common.DataFetchEventArgs.

using OpenEdge.CommonInfrastructure.Common.IComponentCollection.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.PresentationLayer.Presenter.IDataboundPresenter:
    /** Events */
    define public event NavigationPanelStateChanged signature void (poComponent as IComponent, poEventArgs as NavigationPanelEventArgs).
    define public event UpdatePanelStateChanged signature void (poComponent as IComponent, poEventArgs as UpdatePanelEventArgs).
    define public event DataFetchError  signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    define public event DataCommitError signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).    
    define public event DataSaveError   signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    define public event DataDeleteError signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    define public event AddUndoAction   signature void (poComponent as IComponent, poEventArgs as UndoActionEventArgs).
    
    /**  Event handlers */
    @todo(task="from ClientServiceManager  (EventArgs or more specific?)").
    method public void DataFetchedHandler (poComponent as IComponent, poEventArgs as DataFetchEventArgs).
    
    /* query events - Note: Query/ModelQuery does not implement IComponent  */
    method public void QueryClosedHandler (poQuery as IModelQuery, poEventArgs as EventArgs).
    method public void QueryOpenedHandler (poQuery as IModelQuery, poEventArgs as EventArgs).
    method public void QueryRepositionedHandler (poQuery as IModelQuery, poEventArgs as EventArgs).
    
    /** Get individual field values */
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pcValue as char).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pcValue as char extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pcValue as longchar).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pcValue as longchar extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output phValue as handle).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output phValue as handle extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output piValue as int).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output piValue as int extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output piValue as int64).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output piValue as int64 extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pdValue as decimal).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output pdValue as decimal extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as date).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as date extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as datetime).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as datetime extent).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as datetime-tz).    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output ptValue as datetime-tz extent).    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output prValue as raw).
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, output prValue as raw extent).
    
    /** Set individual field values */
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pcValue as char).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pcValue as char extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pcValue as longchar).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pcValue as longchar extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, phValue as handle).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, phValue as handle extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, piValue as int).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, piValue as int extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, piValue as int64).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, piValue as int64 extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pdValue as decimal).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, pdValue as decimal extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as date).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as date extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as datetime).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as datetime extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as datetime-tz).    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, ptValue as datetime-tz extent).    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, prValue as raw).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, prValue as raw extent).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, poValue as Object).
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBuffer as char, pcField as char, poValue as Object extent).
    
    /** manage selection */
    method public integer GetNumSelectedRows(poModelService as IComponentInfo, pcQueryName as char).
    method public character extent GetSelectedRowKey(poModelService as IComponentInfo, pcQueryName as char, piSelect as int).
    
    /* piSelect is selection ordinal - not query */
    method public void ClearSelection(poModelService as IComponentInfo, pcQueryName as char).
    method public void SelectCurrentRow(poModelService as IComponentInfo, pcQueryName as char).
    method public void SelectRow(poModelService as IComponentInfo, pcQueryName as char,pcRowKey as character extent).
    method public void DeselectCurrentRow(poModelService as IComponentInfo, pcQueryName as char).
    method public void DeselectRow(poModelService as IComponentInfo, pcQueryName as char,pcRowKey as character extent).
    
    /** use default query (create a default IQueryDefinition from table ) */
    method public void CreateQuery(poModelService as IComponentInfo,
                                   pcQueryName as char,
                                   pcTableName as char).
    /** These are only meant to be called by another Presenter, NOT any Views */
    method public void CreateQuery(poModelService as IComponentInfo,
                                   pcQueryName as char,
                                   poQueryDefinition as IQueryDefinition).
    
    method public void DeleteQuery(poModelService as IComponentInfo, pcQuery as char).
    method public IQueryDefinition GetQueryDefinition(poModelService as IComponentInfo, pcQuery as char).
    method public IModelQuery GetQuery(poModelService as IComponentInfo, pcQuery as char).
    
    method public void OpenQuery(poModelService as IComponentInfo, pcQuery as char).
    method public void ReopenQuery(poModelService as IComponentInfo, pcQuery as char).
    method public void CloseQuery(poModelService as IComponentInfo, pcQuery as char).    
    
    method public logical GetFirst(poModelService as IComponentInfo, pcQuery as char).
    method public logical GetPrev(poModelService as IComponentInfo, pcQuery as char).
    method public logical GetNext(poModelService as IComponentInfo, pcQuery as char).
    method public logical GetLast(poModelService as IComponentInfo, pcQuery as char).
    method public logical GetRowAtKey(poModelService as IComponentInfo, pcQuery as char, pcRowKey as char extent).
    method public logical GetRowAtPosition(poModelService as IComponentInfo, pcQuery as char, piPos as int).
    method public logical GetRowWhere(poModelService as IComponentInfo,
                                      pcQuery as char,
                                      poQueryDefinition as IQueryDefinition,
                                      poFindType as EnumMember).
      
    /* Fetches data for all Models */
    method public void FetchData ().    
    /* Fetches data for specified Model(s) */
    method public void FetchData (poModelService as IComponentInfo).
    method public void FetchData (poModelService as IComponentInfo extent).
    
    method public void CommitData().    /* all */
    method public void CommitData(poModelService as IComponentInfo). /* one */
    method public void CommitData(poModelService as IComponentInfo extent).  /* many */
    
    /* Model Operations */
    method public character AddRecord(poModelService as IComponentInfo, pcQuery as char, pcTable as char).
    method public void SaveRecord(poModelService as IComponentInfo, pcQuery as char, pcTable as char).
    method public void DeleteRecord(poModelService as IComponentInfo, pcQuery as char, pcTable as char).
    method public void UndoAction(poModelService as IComponentInfo,
                                  pcQuery as char,
                                  pcTable as char,
                                  poAction as EnumMember,
                                  pcCurrentRowKey as char extent).
end interface.