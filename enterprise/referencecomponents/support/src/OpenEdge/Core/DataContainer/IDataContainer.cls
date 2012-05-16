/** ------------------------------------------------------------------------
    File        : IDataContainer
    Purpose     : General interface defining DataContainers, which will be implemented
                  by a Presentation Layer Model or a Business Component BusinessEntity. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 17 18 15:51:15 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.DataContainer.IDataContainer.
using OpenEdge.Core.DataContainer.IDataContainerQuery.
using OpenEdge.Core.DataContainer.IDataContainerEventHandler.
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.
using OpenEdge.Core.DataContainer.DataContainerActionEnum.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.IQueryDefinition.
using Progress.Lang.Object.

interface OpenEdge.Core.DataContainer.IDataContainer:
    
    /** (mandatory) A collection for DataContainerQueries associated with this Model. 
        Creation is done via the CreateQuery() API. */
    define public property DataContainerQueries as IMap no-undo get.
    
@region(name="Query manipulation").
    /** Create a default query for table
        
        @param character A name to use for the query  (optional)
        @param character The table on which to create the query. More complex queries should use
                         IQueryDefinition.
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input pcQueryName as character,
                                                  input pcTableName as character).

    /** Create a query with the specified definition.
        
        @param IQueryDefinition The definition (buffers, joins etc) for the query.
        @param handle An existing ABL query (from a ProDataset/ProBindingSource for example)
        @param character A name to use for the query (optional).
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input poQueryDefinition as IQueryDefinition,
                                                  input phQuery as handle,
                                                  input pcQueryName as character).
    
    /** Create a query with the specified definition.
        
        @param character A name to use for the query (optional).
        @param IQueryDefinition The definition (buffers, joins etc) for the query.
        @return IDataContainerQuery The created query. The name of this query the input name, 
                             since that is optional.  */    
    method public IDataContainerQuery CreateQuery(input pcQueryName as character,
                                                  input poQueryDefinition as IQueryDefinition).
    
@region(name="Local record operations").
    /** Add a record locally to the DataContainer
        
        @param character The name of the table in the DataContainer to which to add a record.
        @return character The unique record key of the newly-added record.  */
    method public character AddRecord(input pcTableName as character).

    /** Add a record locally to the DataContainer
        
        @param character The name of the child table in the DataContainer to which to add a record.
        @param character The name of the parent table in the DataContainer to which to add a record.
        @param character The unique record key of the parent record
        @return character The unique record key of the newly-added record.  */
    method public character AddChildRecord(input pcTableName as character,
                                           input pcParentTableName as character,
                                           input pcParentRecordKey as character).
    
    /** Save a record locally to the DataContainer. 
        
        @param character The name of the table in the DataContainer being saved.
        @param character The unique record key of the record.  */
    method public void SaveRecord(input pcTableName as character, input pcRecordKey as character).

    /** Delete a record locally from the DataContainer. 
        
        @param character The name of the table in the DataContainer being deleted.
        @param character The unique record key of the record.  */    
    method public void DeleteRecord(input pcTableName as character, input pcRecordKey as character).

@region(name="Validation").
    /** Local/client-side field-level validation for a field in the DataContainer. If the validation
        fails, an error will be thrown.
        
        @param DataContainerActionEnum The action being performed on the record.
        @param character The name of the table/buffer in the DataContainer
        @param character The Record key for the record.
        @param character The field name being validated.        */
    method public void ValidateField(input poAction as DataContainerActionEnum,
                                     input pcTableName as character,
                                     input pcRecordKey as character,
                                     input pcFieldName as character).

    /** Local/client-side record- or row-level validation for a field in 
        the DataContainer. If the validation fails, an error will be thrown.
        
        @param DataContainerActionEnum The action being performed on the record.
        @param character The name of the table/buffer in the DataContainer
        @param character The Record key for the record.          */
    method public void ValidateRow (input poAction as DataContainerActionEnum,
                                    input pcTableName as character,
                                    input pcRecordKey as character).

@region(name="Field get/set operations").
    /** Retrieve field values from the DataContainer.
        
        @param character The name of the table in the DataContainer
        @param character A unique key used to find the relevant record
        @param character The name of the field whose value to extract.
        @param output-character The field value.             */
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as character).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as character extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as longchar).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pcValue as longchar extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output phValue as handle).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output phValue as handle extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as integer).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as integer extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as int64).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output piValue as int64 extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pdValue as decimal).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output pdValue as decimal extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as date).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as date extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime-tz).    
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output ptValue as datetime-tz extent).    
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output prValue as raw).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output prValue as raw extent).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output poValue as Object).
    method public void GetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, output poValue as Object extent).

    /** Set a field's value from the DataContainer.
        
        @param character The name of the table in the DataContainer
        @param character A unique key used to find the relevant record
        @param character The name of the field whose value to extract.
        @param character The field value.
        
        @return character The record key: this may have been changed by the value being set. */
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as character).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as character extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as longchar).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pcValue as longchar extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input phValue as handle).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input phValue as handle extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as integer).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as integer extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as int64).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input piValue as int64 extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pdValue as decimal).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input pdValue as decimal extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as date).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as date extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime-tz).    
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input ptValue as datetime-tz extent).    
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input prValue as raw).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input prValue as raw extent).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input poValue as Object).
    method public character SetValue(input pcTableName as character, input pcRecordKey as character,  input pcFieldName as character, input poValue as Object extent).
    
end interface.