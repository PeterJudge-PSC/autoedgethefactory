 /*------------------------------------------------------------------------
    File        : DataboundPresenter
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 06 14:12:00 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Presenter.IDataboundPresenter.
using OpenEdge.PresentationLayer.Presenter.Presenter.
using OpenEdge.CommonInfrastructure.Common.UpdateActionEnum.
using OpenEdge.PresentationLayer.Model.IModel.
using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Model.OperationDoneForContextError.
using OpenEdge.PresentationLayer.View.IView.
using OpenEdge.PresentationLayer.Common.ModelErrorEventArgs.
using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using OpenEdge.PresentationLayer.Common.NavigationPanelEventArgs.
using OpenEdge.PresentationLayer.Common.UpdatePanelEventArgs.
using OpenEdge.PresentationLayer.Common.UndoActionEventArgs.
using OpenEdge.PresentationLayer.Common.DataFetchEventArgs.
using OpenEdge.CommonInfrastructure.Common.UpdateActionEnum.

using OpenEdge.CommonInfrastructure.Common.IServiceCollection.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.IQuery.
using OpenEdge.Lang.FindTypeEnum.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.PresentationLayer.Presenter.DataboundPresenter abstract inherits Presenter 
                    implements IDataboundPresenter:
    
    define protected property Models as IServiceCollection no-undo get. set.
    
    /* Events */
    define public event NavigationPanelStateChanged signature void (poComponent as IComponent, poEventArgs as NavigationPanelEventArgs).
    define public event UpdatePanelStateChanged signature void (poComponent as IComponent, poEventArgs as UpdatePanelEventArgs).
    
    define public event DataFetchError  signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    define public event DataCommitError signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).    
    define public event DataSaveError   signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    define public event DataDeleteError signature void (poComponent as IComponent, poEventArgs as ModelErrorEventArgs).
    
    define public event AddUndoAction signature void (poComponent as IComponent, poEventArgs as UndoActionEventArgs).
    
    constructor public DataboundPresenter(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    constructor public DataboundPresenter(poServiceManager as IServiceManager,
                                          poComponentInfo as IComponentInfo,
                                          poModel as IModel extent):
        super(poServiceManager, poComponentInfo).
        
        AddModel(poModel, false).
    end constructor.
    
    /** Assume that this is called externally, and that we want the models
        initialized.
        
        @param poModel The IModel being added to the Presenter
      */
    method public void AddModel(poModel as IModel):
        AddModel(poModel, true).
    end method.
    
    method protected void AddModel(poModel as IModel, plInit as logical):
        Assert:ArgumentNotNull(poModel, 'Model').
        
        if not valid-object(Models) then 
            Models = new IServiceCollection().
        
        Models:Put(cast(cast(poModel, IComponent):ComponentInfo, IComponentInfo), poModel).
        
        if plInit then
            cast(poModel, IComponent):Initialize().
    end method.
    
    /** The 'bulk' adding of models is assumed to be done at init by injection (via InjectABL).
    
        @param poModel An array of IModel objects to add to the Presenter
      */
    method public void AddModel(poModel as IModel extent):
        AddModel(poModel, true).
    end method.
    
    method public void AddModel(poModel as IModel extent, plInit as logical):
        define variable iMax as integer no-undo.
        define variable iLoop as integer no-undo.
        
        Assert:ArgumentNotNull(poModel, 'Models').
        
        iMax = extent(poModel).
        do iLoop = 1 to iMax:
            AddModel(poModel[iLoop], plInit).
        end.
    end method.
    
    method public void ClearSelection(poModelService as IComponentInfo, pcQueryName as character ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void CommitData(  ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void CommitData(poModelService as IComponentInfo ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void CommitData(poModelService as IComponentInfo extent ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void CreateQuery(poModelService as IComponentInfo, pcQueryName as character,pcTableName as character ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DataReceivedHandler(poComponent as IComponent,poEventArgs as EventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DeselectCurrentRow(poModelService as IComponentInfo, pcQueryName as character ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DeselectRow(poModelService as IComponentInfo, pcQueryName as character, pcRowKey as character extent):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void FetchData(  ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public integer GetNumSelectedRows(poModelService as IComponentInfo, pcQueryName as character ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public logical GetRowAtKey(poModelService as IComponentInfo,pcQuery as character, pcRowKey as character extent):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public logical GetRowAtPosition(poModelService as IComponentInfo,pcQuery as character,piPos as integer ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public logical GetRowWhere(poModelService as IComponentInfo,pcQuery as character,poQueryDefinition as OpenEdge.Core.System.IQueryDefinition,poFindType as FindTypeEnum):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public character extent GetSelectedRowKey(poModelService as IComponentInfo, pcQueryName as character,piSelect as integer ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void OnNavigationPanelStateChanged (poEventArgs as NavigationPanelEventArgs):
        NavigationPanelStateChanged:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
    
    method public void OnUpdatePanelStateChanged (poEventArgs as UpdatePanelEventArgs):
        UpdatePanelStateChanged:Publish(cast(this-object, IComponent), poEventArgs). 
    end method.
    
    method public void OnDataFetchError (poEventArgs as ModelErrorEventArgs):
        DataFetchError:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
    
    method public void OnDataCommitError (poEventArgs as ModelErrorEventArgs):
        DataCommitError:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
        
    method public void OnDataSaveError (poEventArgs as ModelErrorEventArgs):
        DataSaveError:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
    
    method public void OnDataDeleteError (poEventArgs as ModelErrorEventArgs):
        DataDeleteError:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
    
    method public void OnAddUndoAction (poEventArgs as UndoActionEventArgs):
        AddUndoAction:Publish(cast(this-object, IComponent), poEventArgs).
    end method.
    
    method public void QueryClosedHandler(poQuery as IModelQuery,poEventArgs as EventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public void QueryOpenedHandler(poQuery as IModelQuery,poEventArgs as EventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public void QueryRepositionedHandler(poQuery as IModelQuery,poEventArgs as EventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public void SelectCurrentRow(poModelService as IComponentInfo, pcQueryName as character ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public void SelectRow(poModelService as IComponentInfo, pcQueryName as character, pcRowKey as character extent):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method override public void Initialize():
        InitializeModels().
        
        super:Initialize().
    end method.
    
    method protected void InitializeModels():
        define variable oModel as IModel no-undo.
        define variable oIterator as IIterator no-undo. 
        
        @todo(task="Get request ID for FetchData ").
        oIterator = Models:Values:Iterator().
        do while oIterator:HasNext():
            oModel = cast(oIterator:Next(), IModel).
            
            InitializeModel(oModel).
            
            @todo(task="Add to FetchData request").
            /*
            BuildModelRequest(oModel).
            */
        end.
        
        @todo(task="Execute FetchData request").
    end method.
    
    method protected void InitializeModel(poModel as IModel):
        cast(poModel, IComponent):Initialize().
        
        @todo(task="Client Service Manager publishes").
/**     
        poModel:DataFetch:Subscribe(this-object:DataFetchHandler).
        poModel:DataCommit:Subscribe(this-object:DataCommitHandler).
**/        
        poModel:DataAdd:Subscribe(this-object:DataAddHandler).
        poModel:DataDelete:Subscribe(this-object:DataDeleteHandler).
        poModel:DataSave:Subscribe(this-object:DataSaveHandler).
    end method.
    
    method public IModel GetModel(poModelService as IComponentInfo):
        return cast(Models:Get(poModelService), IModel).
    end method.
                
    method public IModel GetModel (poModelService as class Class):
        return GetModel(new ComponentInfo(poModelService)).
    end method.
    
    method override public void DestroyComponent():
        define variable oIterator as IIterator no-undo.
        define variable oModel  as IModel no-undo.
        
        super:DestroyComponent().
        
        if valid-object(Models) then
        do:
            oIterator = Models:Values:Iterator().
            do while oIterator:HasNext():
                oModel = cast(oIterator:Next(), IModel).
    /*                oModel:DataFetch:Unsubscribe(this-object:DataFetchHandler).*/
    /*                oModel:DataCommit:Unsubscribe(this-object:DataCommitHandler).*/
    
                oModel:DataAdd:Unsubscribe(this-object:DataAddHandler).
                oModel:DataDelete:Unsubscribe(this-object:DataDeleteHandler).
                oModel:DataSave:Unsubscribe(this-object:DataSaveHandler).
                
                /* Remove the model from the  collection. Releasing the reference 
                   will let the GC take it's course (unless there's a cached or 
                   singleton componentm, which is possible with Models). */
                Models:Remove(oModel).
            end.
        end.
    end method.
    
    /* Speaking to the Model, getting data */
    method public void FetchData (poModelService as IComponentInfo extent):
        define variable iExtent as integer no-undo.
                
        do iExtent = 1 to extent(poModelService):
            FetchData(poModelService[iExtent]).
        end.
    end method.
    
    method public void FetchData (poModelService as IComponentInfo):
        FetchData(GetModel(poModelService)).
    end method.
    
    method public void FetchData (poModel as IModel):
        define variable cErrorBuffer as character extent no-undo.
        define variable iLoop        as int       no-undo.
        
        poModel:FetchData().
                
        /* no-error needed in case there are no errors ie the ErrorBuffer 
           is extent not fixed */
        cErrorBuffer = poModel:ErrorBuffer no-error.
        
        if extent(cErrorBuffer) ne ? then
        do iLoop = 1 to extent(cErrorBuffer):
            DataFetchError:Publish(cast(this-object, IComponent), poModel:ProcessModelErrors(cErrorBuffer[iLoop])).
        end.
        
        catch oDoneForContextError as OperationDoneForContextError:
            if ApplicationError:ShowDebugMessages then
                oDoneForContextError:ShowError().
        end catch.
        
        @todo(task="implement").

/**         
        finally:
            /* Whoever calls FetchData needs to reopen and reposition their query.
               If we previously got a OperationDoneForContextError we know that
               we didn't get any new data. */
            poModel:OnDataFetch(new DataFetchEventArgs(
                poModel:GetClass():TypeName,
                /* New data fetched? */
                not valid-object(oDoneForContextError))).
        end finally.
**/        
    end method.
    
    method public handle GetBindingHandle(poModelService as IComponentInfo, pcQueryName as char):
        return GetModel(poModelService):GetBindingHandle(pcQueryName).
    end method.
    
    method public void OpenQuery(poModelService as IComponentInfo, pcQuery as char):
        cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):OpenQuery().
    end method.
    
    method public void CloseQuery(poModelService as IComponentInfo, pcQuery as char):
        cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):CloseQuery().
    end method.        
        
    method public void ReopenQuery(poModelService as IComponentInfo, pcQuery as char):
        cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):ReopenQuery().
    end method.
                
    method public logical GetFirst(poModelService as IComponentInfo, pcQuery as char):
        define variable lAvailable as logical no-undo.
        
        lAvailable = cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):GetFirst().
        DataRefresh(new ModelEventArgs(poModelService, pcQuery)).
        
        return lAvailable.
    end method.
    
    method public logical GetPrev(poModelService as IComponentInfo, pcQuery as char):
        define variable lAvailable as logical no-undo.
        
        lAvailable = cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):GetPrev().
        DataRefresh(new ModelEventArgs(poModelService, pcQuery)).
        
        return lAvailable.
    end method.
    
    method public logical GetNext(poModelService as IComponentInfo, pcQuery as char):
        define variable lAvailable as logical no-undo.
        
        lAvailable = cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):GetNext().
        DataRefresh(new ModelEventArgs(poModelService, pcQuery)).
        
        return lAvailable.
    end method.
    
    method public logical GetLast(poModelService as IComponentInfo, pcQuery as char):
        define variable lAvailable as logical no-undo.
        
        lAvailable = cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):GetLast().
        DataRefresh(new ModelEventArgs(poModelService, pcQuery, ?)).
        
        return lAvailable.
    end method.
    
    method public IQueryDefinition GetQueryDefinition(poModelService as IComponentInfo, pcQuery as char):
        return cast(GetModel(poModelService):GetQuery(pcQuery), IQuery):QueryDefinition.
    end method.
    
    method public void CreateQuery(poModelService as IComponentInfo,
                                   pcQueryName as character,
                                   poQueryDefinition as IQueryDefinition):
        GetModel(poModelService):CreateQuery(pcQueryName, poQueryDefinition).
    end method.
    
    method public IModelQuery GetQuery(poModelService as IComponentInfo, pcQuery as char):
        return GetModel(poModelService):GetQuery(pcQuery).
    end method.
    
    method public void DeleteQuery(poModelService as IComponentInfo, pcQuery as char).
        GetModel(poModelService):DeleteQuery(pcQuery).
    end method.
        
    /* Get values from Model */ 
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pcValue as character ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pcValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pcValue as char extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pcValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as date ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as date extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as datetime ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as datetime extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as datetime-tz ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output ptValue as datetime-tz extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pdValue as decimal ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pdValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pdValue as decimal extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pdValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output phValue as handle ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output phValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output phValue as handle extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output phValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output piValue as integer ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output piValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output piValue as integer extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output piValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output piValue as int64 ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output piValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output piValue as int64 extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output piValue).
    end method.
    
    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pcValue as longchar ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pcValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output pcValue as longchar extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output pcValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output prValue as raw ):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output prValue).
    end method.

    method public void GetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, output prValue as raw extent):
        GetModel(poModelService):GetValue(pcRecordKey, pcBufferName, pcFieldName, output prValue).
    end method.

    method public void DataFetchedHandler (poSender as IComponent, poEventArgs as DataFetchEventArgs):
        DataFetched(poEventArgs).
    end method.
    
    method public void DataAddHandler (poSender as IComponent, poEventArgs as ModelEventArgs):
        DataRefresh(poEventArgs).
    end method.
    
    method public void DataDeleteHandler (poSender as IComponent, poEventArgs as ModelEventArgs):
        DataRefresh(poEventArgs).
    end method.
    
    method public void DataSaveHandler(poSender as IComponent, poEventArgs as ModelEventArgs):
        DataRefresh(poEventArgs).
    end method.
    
    method public void DataCommitHandler(poSender as IComponent, poEventArgs as ModelEventArgs):
        DataRefresh(poEventArgs).
    end method.
    
    method protected void DataFetched(poEventArgs as DataFetchEventArgs):
        define variable oView as IView no-undo.
        
        oView = this-object:View.
        if valid-object(oView) then
            oView:DataFetched(poEventArgs:ModelService, poEventArgs:NewData).
    end method.
        
    method protected void DataRefresh (poEventArgs as ModelEventArgs):
        define variable oModel      as IModel    no-undo.
        define variable oView       as IView     no-undo.
        define variable cCurrentRow as character extent no-undo.
        
        oModel = GetModel(poEventArgs:ModelService).
        oView = this-object:View.
        
        /* The view knows which queries it's navigating, and will decide
           if anything needs to be done. Note that the query on which the
           operation was performed has already been updated if needed. */
        if valid-object(oView) then           
            oView:DataRefreshed(poEventArgs:ModelService,
                poEventArgs:QueryName,
                poEventArgs:ModelAction).
        
        NavigationPanelStateChanged:Publish(cast(this-object, IComponent),
            new NavigationPanelEventArgs(
            poEventArgs:ModelService,
            poEventArgs:QueryName,
            cast(oModel:GetQuery(poEventArgs:QueryName), IQuery):RowPosition)).
        
        UpdatePanelStateChanged:Publish(cast(this-object, IComponent),
            new UpdatePanelEventArgs(
            poEventArgs:ModelService,
            poEventArgs:QueryName,
            poEventArgs:TableName)).
    end method.
        
    method public character AddRecord(poModelService as IComponentInfo, pcQuery as char, pcTable as char):
        define variable oModel        as IModel    no-undo.
        define variable cCurrentRow   as character extent no-undo.
        define variable cNewRecordKey as character no-undo.
        
        /* AddRecord also reopens the query */
        oModel = GetModel(poModelService).
        cNewRecordKey = oModel:AddRecord(pcTable).
        
        cCurrentRow = cast(oModel:GetQuery(pcQuery), IQuery):GetCurrentRowKey().
        AddUndoAction:Publish(cast(this-object, IComponent),
            new UndoActionEventArgs(poModelService,
            pcQuery,
            pcTable,
            cCurrentRow,
            UpdateActionEnum:Add)).
        
/*        oModel:OnDataAdd(new ModelEventArgs(pcModel, pcQuery, pcTable, cCurrentRow)).*/
        
        return cNewRecordKey.
    end method.
    
    method public void SaveRecord(poModelService as IComponentInfo, pcQuery as char, pcBuffer as char):
        define variable cErrorBuffer as character extent no-undo.
        define variable iLoop        as integer   no-undo.
        define variable oModel       as IModel    no-undo.
        define variable oQuery       as IQuery    no-undo.
        define variable cCurrentRow  as character extent no-undo.
        
        /* Does a local update of the model from the view. Basically writes screen
           values to Model's temp-tables. Validates the local changes.
           
           Commit saves the record to the DB */
        
        /* Get values from the screen into the dataset */
        oModel = GetModel(poModelService).
        
        this-object:View:SaveData(poModelService, pcBuffer).
        oModel:SaveRecord(pcQuery, pcBuffer).
        
        cErrorBuffer = oModel:ErrorBuffer no-error.
                                                
        if extent(cErrorBuffer) ne ? then
        do iLoop = 1 to extent(cErrorBuffer):
            /* Only notify of the table we're working on. */
            if pcBuffer eq ? or cErrorBuffer[iLoop] eq pcBuffer then
                DataSaveError:Publish(cast(this-object, IComponent), oModel:ProcessModelErrors(cErrorBuffer[iLoop])).
        end.
        
        oQuery = cast(oModel:GetQuery(pcQuery), IQuery).
        cCurrentRow = oQuery:GetCurrentRowKey().
        oQuery:ReopenQuery(cCurrentRow).
        
        AddUndoAction:Publish(cast(this-object, IComponent),
            new UndoActionEventArgs(
                poModelService,
                pcQuery,
                pcBuffer,
                cCurrentRow,
                UpdateActionEnum:Save) ).
        
/*        oModel:OnDataSave(new ModelEventArgs(pcModel, pcQuery, pcBuffer, cCurrentRow)).*/
    end method.
    
    method public void CommitData(poModelService as IComponentInfo, pcQuery as char, pcTable as char):
        define variable cErrorBuffer as character extent no-undo.
        define variable iLoop        as integer   no-undo.
        define variable oModel       as IModel    no-undo.
        
        /* Make sure we write from the screen to the Model first. */
        SaveRecord(poModelService, pcQuery, pcTable).
        
        /* Commits Model's data to DB/service */
        oModel = GetModel(poModelService).
        
        oModel:CollectChanges().
        oModel:CommitData().
        
        /* no-error needed in case there are no errors ie the ErrorBuffer 
           is extent not fixed */
        cErrorBuffer = oModel:ErrorBuffer no-error.
        
        if extent(cErrorBuffer) ne ? then
        do iLoop = 1 to extent(cErrorBuffer):
            /* Only notify of the table we're working on. */
            if pcTable eq ? or cErrorBuffer[iLoop] eq pcTable then
                DataCommitError:Publish(cast(this-object, IComponent), oModel:ProcessModelErrors(cErrorBuffer[iLoop])).
        end.
        
        /* Merge reopens the query */
        oModel:MergeChanges(pcQuery).
        
        @todo(task="client service manager").
/* oModel:OnDataCommit(new ModelEventArgs(pcModel, pcQuery, pcTable)).*/
    end method.
                    
    /* Delete is local, like Save */
    method public void DeleteRecord(poModelService as IComponentInfo, pcQuery as char, pcTable as char):
        define variable cCurrentRow as character extent no-undo.
        define variable oModel      as IModel    no-undo.
        
        oModel = GetModel(poModelService).
        cCurrentRow = cast(oModel:GetQuery(pcQuery), IQuery):GetCurrentRowKey().
        
        /*        oQuery = GetQuery(pcQuery).                */
        /*        hQuery  = cast(oQuery, IQuery):QueryHandle.*/
        /*        iRow = max(hQuery:current-result-row - 1, 1).*/
        
/*        oModel:DeleteRecord(pcQuery, pcTable).*/
    end method.
    
    method public void RecordDeletedHandler(poSender as IComponent, poEventArgs as ModelEventArgs):
        define variable oModel as IModel no-undo.

        @todo(task="Refresh all queries").
        /*        hQuery:delete-result-list-entry().         */
        /*        cast(oQuery, IQuery):RepositionQuery(iRow).*/

                               
        AddUndoAction:Publish(cast(this-object, IComponent),
            new UndoActionEventArgs(
            poEventArgs:ModelService,
            poEventArgs:QueryName,
            poEventArgs:TableName,
            poEventArgs:CurrentRowKey,
            UpdateActionEnum:Delete)).
        
        /*        oModel:OnDataDelete(new ModelEventArgs(pcModel, pcQuery, pcTable, cCurrentRow)).*/
        
        oModel = cast(poSender, IModel).
/*        oModel:OnDataDelete(poEventArgs).*/
    end method.
         
    method public void UndoAction(poModelService as IComponentInfo, pcQuery as char, pcTable as char, poAction as UpdateActionEnum, pcCurrentRowKey as char extent):
        /* find row */
        @todo(task="undo the action (delete, revert, etc)").
        
        DataRefresh(new ModelEventArgs(poModelService, pcQuery, pcTable)).
    end method.
        
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pcValue as char):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pcValue).
    end method.
        
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pcValue as char extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pcValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pcValue as longchar):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pcValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pcValue as longchar extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pcValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, phValue as handle):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, phValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, phValue as handle extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, phValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, piValue as integer):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, piValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, piValue as integer extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, piValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, piValue as int64):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, piValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, piValue as int64 extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, piValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pdValue as decimal):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pdValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, pdValue as decimal extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, pdValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as date):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as date extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as datetime):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as datetime extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as datetime-tz):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.

    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, ptValue as datetime-tz extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, ptValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, prValue as raw):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, prValue).
    end method.

    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, prValue as raw extent):
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, prValue).
    end method.
    
    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, poValue as Object).
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, poValue).
    end method.

    method public logical SetValue(poModelService as IComponentInfo, pcRecordKey as char, pcBufferName as char, pcFieldName as char, poValue as Object extent).
        GetModel(poModelService):SetValue(pcRecordKey, pcBufferName, pcFieldName, poValue).
    end method.    
    
end class.