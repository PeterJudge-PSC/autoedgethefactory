/** ------------------------------------------------------------------------
    File        : DataContainer
    Purpose     : General class defining ProDatSet-based DataContainers, which will be extended
                  by a Presentation Layer Model or a Business Component BusinessEntity.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 17 15:13:27 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.IDataContainerEvents.
using OpenEdge.Core.DataContainer.IDataContainer.
using OpenEdge.Core.DataContainer.IDataContainerQuery.
using OpenEdge.Core.DataContainer.DataContainer.
using OpenEdge.Core.DataContainer.DataContainerActionEnum.
using OpenEdge.Core.DataContainer.DataContainerQuery.
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.ITableOwner.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.DataContainer.DataContainer abstract 
        implements IDataContainer, IDataContainerEvents, ITableOwner:
            
    define static public property IDataContainerType as class Class no-undo get. private set.            
        
/* Events */
    /** Fired after a record has been added to the model.
    
        @param IComponent The Model sending the event
        @param DataContainerErrorEventArgs Arguments pertinent to the event   */
    define public event DataAdd signature void (input poSender as Object,
                                                input poEventArgs as DataContainerActionEventArgs).
    
    /** Allows raising of the DataAdd event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the event.  */
    method protected void OnDataAdd(input poEventArgs as DataContainerActionEventArgs):
        this-object:DataAdd:Publish(this-object, poEventArgs).
    end method.
    
    /** This event fires when an error occurs when data is added to the model. 
    
        @param IComponent The model sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */        
    define public event DataAddError signature void (input poSender as Object,
                                                     input poEventArgs as DataContainerErrorEventArgs).

    /** Allows raising of the DataAddError event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the error event.  */
    method protected void OnDataAddError (input poEventArgs as DataContainerErrorEventArgs):
        this-object:DataAddError:Publish(this-object, poEventArgs).
    end method.
    
    /** Fired after a record has been removed
    
        @param IComponent The Model sending the event
        @param EventArgs Arguments pertinent to the event   */
    define public event DataDelete signature void (input poSender as Object,
                                                   input poEventArgs as DataContainerActionEventArgs).

    /** Allows raising of the DataDelete event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the event.  */
    method protected void OnDataDelete(input poEventArgs as DataContainerActionEventArgs):
        this-object:DataDelete:Publish(this-object, poEventArgs).
    end method.

    /** This event fires when an error occurs when data is deleted from the model
    
        @param IComponent The model sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    define public event DataDeleteError signature void (input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).

    /** Allows raising of the DataDeleteError event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the error event.  */
    method protected void OnDataDeleteError(input poEventArgs as DataContainerErrorEventArgs):
        this-object:DataDeleteError:Publish(this-object, poEventArgs).
    end method.

    /** Fired after a record has been saved to the model (local save, 
        not a commit).
        
        @param IComponent The Model sending the event
        @param EventArgs Arguments pertinent to the event   */
    define public event DataSave signature void (input poSender as Object,
                                                 input poEventArgs as DataContainerActionEventArgs).

    /** Allows raising of the DataSave event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the event.  */
    method protected void OnDataSave(input poEventArgs as DataContainerActionEventArgs):
        this-object:DataSave:Publish(this-object, poEventArgs).
    end method.
    
    /** This event fires when an error occurs when data is saved locally
    
        @param IComponent The model sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    define public event DataSaveError signature void (input poSender as Object,
                                                      input poEventArgs as DataContainerErrorEventArgs).

    /** Allows raising of the DataSaveError event by derived classes. 
        
        @param DataContainerErrorEventArgs Arguments for the error event.  */
    method protected void OnDataSaveError(input poEventArgs as DataContainerErrorEventArgs):
        this-object:DataSaveError:Publish(this-object, poEventArgs).
    end method.
    
    /** (mandatory) A collection for ModelQueries associated with this Model. 
        Creation is done via the CreateQuery() API. */
    define public property DataContainerQueries as IMap no-undo
        get():
            if not valid-object(DataContainerQueries) then
                DataContainerQueries = new TypedMap(
                            String:Type,
                            Class:GetClass('OpenEdge.Core.DataContainer.IDataContainerQuery')).
            return DataContainerQueries.
        end get.
        private set.

    constructor static DataContainer():        
        DataContainer:IDataContainerType = Class:GetClass('OpenEdge.Core.DataContainer.IDataContainer').
    end constructor.
    
	constructor public DataContainer():
		super().
	end constructor.
	
    /** Returns a list of table name in the DataContainer. Each datastore has its
        own way of listing these, so the implementation is left to them.
        
        @return character An array of all the table names in this DataContainer. */
    method abstract protected character extent GetTableNames().	
    
@region(name="Query manipulation").
    /** Create a default query for table
        
        @param character A name to use for the query  (optional)
        @param character The table on which to create the query. More complex queries should use
                         IQueryDefinition.
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input pcQueryName as character,
                                              input pcTableName as character):
        define variable oQueryDefinition as IQueryDefinition no-undo.
        
        oQueryDefinition = new QueryDefinition().
        oQueryDefinition:AddBuffer(pcTableName).
        
        return CreateQuery(pcQueryName, oQueryDefinition).                                                  
    end method.

    /** Create a query with the specified definition.
        
        @param IQueryDefinition The definition (buffers, joins etc) for the query.
        @param handle An existing ABL query (from a ProDataset/ProBindingSource for example)
        @param character A name to use for the query (optional).
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input poQueryDefinition as IQueryDefinition,
                                                  input phQuery as handle,
                                                  input pcQueryName as character):
        define variable oDMQ as IDataContainerQuery no-undo.
        
        oDMQ = cast(DataContainerQueries:Get(new String(pcQueryName)), IDataContainerQuery).
        if not valid-object(oDMQ) then
        do:
            oDMQ = new DataContainerQuery(this-object /*IDataContainer and ITableOwner*/,
                                 pcQueryName,
                                 phQuery,
                                 poQueryDefinition).
            DataContainerQueries:Put(new String(oDMQ:QueryName), oDMQ).
        end.
        
        return oDMQ.
    end method.
    
    /** Create a query with the specified definition.
        
        @param character A name to use for the query (optional).
        @param IQueryDefinition The definition (buffers, joins etc) for the query.
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input pcQueryName as character,
                                              input poQueryDefinition as IQueryDefinition):
        return CreateQuery(poQueryDefinition, ?, pcQueryName).
    end method.
    
@region(name="Local record operations").
    /** Add a record locally to the DataContainer
        
        @param character The name of the table in the DataContainer to which to add a record.
        @return character The unique record key of the newly-added record.  */
    method public character AddRecord(input pcTableName as character):
        define variable cNewRecordKey as character no-undo.
        
        BeforeAddRecord(pcTableName).
        cNewRecordKey = DoAddRecord(pcTableName).
        AfterAddRecord(pcTableName, cNewRecordKey).
        
        return cNewRecordKey.        
    end method.

/** Add a record locally to the DataContainer
        
        @param character The name of the child table in the DataContainer to which to add a record.
        @param character The name of the parent table in the DataContainer to which to add a record.
        @param character The unique record key of the parent record
        @return character The unique record key of the newly-added record.  */
    method public character AddChildRecord(input pcTableName as character,
                                           input pcParentTableName as character,
                                           input pcParentRecordKey as character):
        FindTableByKey(pcParentTableName, pcParentRecordKey).
        
        return AddRecord(pcTableName).                                               
    end method.
        
    /** Find a record in the DataContainer by (unique) key. 
        
        @param character The table name 
        @param character The record key for the record being found.
        @return logical Indicates whether the record specified was found. */    
    method abstract protected logical FindTableByKey(input pcBufferName as character, input pcRecordKey as character).
                                                   
    /** Actions performed before we add a record.
        
        @param character The name of the table being added. */
    @method(virtual="true").
    method protected void BeforeAddRecord(input pcTableName as character):
    end method.
    
    /** Perform the actual add of the record to the Model. This is an abstract method
        since the physical Model will know exactly how to add a record (ie buffer in DatasetModel),
        whereas this class has no concept of the physical data store. 
        
        @param The table name of the record being added.
        @return character The record key of the newly-added record.     */
    method abstract protected character DoAddRecord(input pcTableName as character).
    
    /** Actions performed after we add a record.
        
        @param character The name of the table being added.
        @param character The unique key for the newly-added record. */
    method protected void AfterAddRecord(input pcTableName as character, input pcNewRecordKey as char):
        ValidateRow(DataContainerActionEnum:Add, pcTableName, pcNewRecordKey).
        
        OnDataAdd(new DataContainerActionEventArgs(
                    this-object,
                    DataContainerActionEnum:Add,
                    pcTableName,
                    pcNewRecordKey)).
    end method.
    
    /** Save a record locally to the DataContainer. 
        
        @param character The name of the table in the DataContainer being saved.
        @param character The unique record key of the record.  */
    method public void SaveRecord(input pcTableName as character, input pcRecordKey as character):
        BeforeSaveRecord(pcTableName, pcRecordKey).
        DoSaveRecord(pcTableName, pcRecordKey).
        AfterSaveRecord(pcTableName, pcRecordKey).        
    end method.

    /** Actions performed before a record is saved.
        
        @param character The name of the table in the Model being saved.
        @param character The unique record key of the record.  */    
    @method(virtual="true").        
    method protected void BeforeSaveRecord(input pcTableName as character, input pcRecordKey as character):
    end method.
    
    /** Perform the actual save of the record to the Model. This is an abstract method
        since the physical Model will know exactly how to save a record (ie buffer in DatasetModel),
        whereas this class has no concept of the physical data store. 

        @param character The name of the table in the Model being saved.
        @param character The unique record key of the record.  */
    method abstract protected void DoSaveRecord(input pcTableName as character, input pcRecordKey as character).
    
    /** Actions performed after a record has been saved.
        
        @param character The name of the table in the Model being saved.
        @param character The unique record key of the record.  */
    method protected void AfterSaveRecord(input pcTableName as character, input pcRecordKey as character):
        OnDataSave(new DataContainerActionEventArgs(
                    this-object,
                    DataContainerActionEnum:Save,
                    pcTableName,
                    pcRecordKey)).
    end method.
    
    /** Delete a record locally from the DataContainer. 
        
        @param character The name of the table in the DataContainer being deleted.
        @param character The unique record key of the record.  */    
    method public void DeleteRecord(input pcTableName as character, input pcRecordKey as character):
        BeforeDeleteRecord(pcTableName, pcRecordKey).
        DoDeleteRecord(pcTableName, pcRecordKey).
        AfterDeleteRecord(pcTableName, pcRecordKey).
    end method.
    
    /** Actions performed before a record is deleted. 
        
        @param character The name of the table in the Model being deleted.
        @param character The unique record key of the record.  */
    @method(virtual="true").
    method protected void BeforeDeleteRecord(input pcTableName as character, input pcRecordKey as character):
    end method.
    
    /** Perform the actual delete of the record from the Model. This is an abstract method
        since the physical Model will know exactly how to delete a record (ie buffer in DatasetModel),
        whereas this class has no concept of the physical data store. 

        @param character The name of the table in the Model being deleted
        @param character The unique record key of the record.  */    
    method abstract protected void DoDeleteRecord(input pcTableName as character, input pcRecordKey as character).
    
    /** Actions performed after a record is deleted. 
        
        @param character The name of the table in the Model being deleted.
        @param character The unique record key of the record.  */    
    method protected void AfterDeleteRecord(input pcTableName as character, input pcRecordKey as character):
        OnDataDelete(new DataContainerActionEventArgs(
                    this-object,
                    DataContainerActionEnum:Delete,
                    pcTableName,
                    pcRecordKey)).
    end method.
    
@region(name="Validation").
    /** Local/client-side field-level validation for a field in the DataContainer. If the validation
        fails, an error will be thrown.
        
        @param DataContainerActionEnum The action being performed on the record.
        @param character The name of the table/buffer in the DataContainer
        @param character The Record key for the record.
        @param character The field name being validated.        */
    @method(virtual="true").        
    method public void ValidateField(input poAction as DataContainerActionEnum,
                                     input pcTableName as character,
                                     input pcRecordKey as character,
                                     input pcFieldName as character):
    end method.
    
    /** Local/client-side record- or row-level validation for a field in 
        the DataContainer. If the validation fails, an error will be thrown.
        
        @param DataContainerActionEnum The action being performed on the record.
        @param character The name of the table/buffer in the DataContainer
        @param character The Record key for the record.          */
    @method(virtual="true").    
    method public void ValidateRow (input poAction as DataContainerActionEnum,
                                    input pcTableName as character,
                                    input pcRecordKey as character):
    end method.    
    
    /** Retrieve field values from the Model.
        
        @param character The name of the table in the model
        @param character A unique key used to find the relevant record
        @param character The name of the field whose value to extract.
        @param output-character The field value.             */
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as character).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as character extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as longchar).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as longchar extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output phValue as handle).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output phValue as handle extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as integer).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as integer extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as int64).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as int64 extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pdValue as decimal).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pdValue as decimal extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as date).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as date extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime-tz).    
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime-tz extent).    
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output prValue as raw).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output prValue as raw extent).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output poValue as Object).
    method abstract public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output poValue as Object extent).

    /** Set a field's value from the Model.
        
        @param character The name of the table in the model
        @param character A unique key used to find the relevant record
        @param character The name of the field whose value to extract.
        @param character The field value.
        
        @return character The record key: this may have been changed by the value being set. */
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as character).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as character extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as longchar).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as longchar extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input phValue as handle).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input phValue as handle extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as integer).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as integer extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as int64).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as int64 extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pdValue as decimal).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pdValue as decimal extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as date).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as date extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime-tz).    
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime-tz extent).    
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input prValue as raw).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input prValue as raw extent).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input poValue as Object).
    method abstract public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input poValue as Object extent).
    
    /* ITableOwner implementation */
    /** @param character A table or buffer name. The implementer will
        know how to interpret the name. The name passed in is the name
        that the query will use together with its IQueryDefinition.
        
        @return A buffer handle corresponding to the requested name. */
    method abstract public handle GetTableHandle (input pcTableName as character).

end class.