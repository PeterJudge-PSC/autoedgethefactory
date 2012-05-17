/** ------------------------------------------------------------------------
    File        : StandardDataContainer
    Purpose     : ProDataset-based DataContainer. We consider PDS' our standard
                  data transport and storage structure.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Jun 20 11:29:38 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.DataContainerActionEnum.
using OpenEdge.Core.DataContainer.DataContainer.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.DataContainer.StandardDataContainer use-widget-pool inherits DataContainer:
    define protected property DatasetHandle as handle no-undo
        get.
        set(input phArg as handle):            
            /* if the dataset handle is changing, then clear any queries */
            if not valid-handle(phArg) or 
               phArg ne DatasetHandle then
            do:
                DataContainerQueries:Clear().
                DisableDatasetForUpdate(phArg).
            end.
            
            DatasetHandle = phArg.
            EnableDatasetForUpdate(DatasetHandle).
        end set.

    constructor public StandardDataContainer():
        super().
    end constructor.

    constructor public StandardDataContainer(input phDataset as handle):
        super().
        
        Assert:ArgumentNotNull(phDataset, 'Dataset').
        DatasetHandle = phDataset.
    end constructor.
    
	constructor public StandardDataContainer(input dataset-handle phDataset):
		super().
		
		Assert:ArgumentNotNull(phDataset, 'Dataset').
		DatasetHandle = phDataset.
	end constructor.
	
	method public void SetDataSet(input phDataset as handle):
    end method.
	
    method override protected character DoAddRecord(input pcTableName as character):
        define variable hBuffer    as handle no-undo.
        define variable cNewRecordKey as character no-undo.
        
        hBuffer = GetBufferHandle(pcTableName).
        
        do transaction:
            hBuffer:buffer-create().
            
            AssignKeyValues(pcTableName, hBuffer).
            AssignDefaultValues(pcTableName, hBuffer).
            
            cNewRecordKey = GetRecordKey(hBuffer).
            hBuffer:buffer-release().
        end.
        
        return cNewRecordKey.
    end method.
    
    method protected character GetRecordKey(input pcTableName as character):
        return GetRecordKey(GetBufferHandle(pcTableName)).
    end method.

    /** Each DataModel type will have it's own way of determining a buffer handle
        based on it's internal data storage structures, eg prodataset, temp-table.  */
    method protected handle GetBufferField(input pcBufferName as character,
                                           input pcFieldName as character):
        define variable hField as handle no-undo.
        
        hField = GetBufferHandle(pcBufferName):buffer-field(pcFieldName) no-error.
        
        Assert:ArgumentNotNull(hField, substitute('Field &1 not in buffer &2', pcFieldName, pcBufferName)).
        
        return hField.                                               
    end method.
    
    method protected character GetRecordKey(phBuffer as handle):
        define variable cRecordKey as char no-undo.
        define variable cKeys as char no-undo.
        define variable iFields as int no-undo.
        
        if phBuffer:available then
        do:
            cKeys = phBuffer:keys.
            if cKeys eq 'Rowid' then
                cRecordKey = string(phBuffer:rowid). 
            else
            do iFields = 1 to num-entries(cKeys):
                cRecordKey = cRecordKey
                           + (if iFields eq 1 then 'where ' else ' and ')
                           + phBuffer:name + '.' + entry(iFields, cKeys)
                           + ' = ' + quoter(phBuffer:buffer-field(entry(iFields, cKeys)):buffer-value)
                           .
            end.    /* key fields */
        end.
        else
            cRecordKey = ?.
        
        return cRecordKey.        
    end method.
    
    /** Assign parent values based on the relation a (child) buffer is part of.
     **/
    method protected void AssignKeyValues (pcTable as char, phBuffer as handle):
        define variable hRelation as handle no-undo.
        define variable hParentBuffer as handle no-undo.
        define variable iNumFields as integer no-undo.
        
        hRelation = phBuffer:parent-relation.
        
        if valid-handle(hRelation) then
        /* relationfields = parent-field1, child-field1 [, parent-fieldn, child-fieldn ] ...) */
        do iNumFields = 1 to num-entries(hRelation:relation-fields) by 2:
            hParentBuffer = hRelation:parent-buffer.
            if valid-handle(hParentBuffer) then 
                phBuffer:buffer-field(entry(iNumFields + 1, hRelation:relation-fields)):buffer-value =
                    hParentBuffer:buffer-field(entry(iNumFields, hRelation:relation-fields)):buffer-value.
        end.
    end method.
    
    /** Set the default (initial) values on create of a record
        in the model. The table name is passed in in case the model is operating 
        on a non-default-ly named buffer. The buffer handle is positioned to the
        newly-created record.
        
        Note that key values are set in AssignKeyValues().
        
        @param character The name of the table being created
        @param handle The buffer handle for the table */
    @method(virtual="true").          
    method protected void AssignDefaultValues (input pcTableName as character, input phBuffer as handle):
    end method.
    
    method override protected void DoDeleteRecord(input pcTableName as character, input pcRecordKey as character):
        define variable hBuffer as handle  no-undo.
        
        hBuffer = GetBufferHandle(pcTableName).
        /* try to keep the record scope tight ... */
        if FindTableByKey(hBuffer, pcRecordKey) then
        do transaction:
            hBuffer:buffer-delete() no-error.
        end.
    end method.
    
    method override protected void DoSaveRecord(input pcTableName as character, input pcRecordKey as character ):
        define variable hBuffer as handle  no-undo.
        
        hBuffer = GetBufferHandle(pcTableName).
        /* try to keep the record scope tight ... */
        if FindTableByKey(hBuffer, pcRecordKey) then
            hBuffer:buffer-release() no-error.
    end method.    
    
    /** Find a record in the Dataset by (unique) key. 
        
        @param character The table name 
        @param character The record key for the record being found.
        @return logical Indicates whether the record specified was found. */    
    method override protected logical FindTableByKey(input pcBufferName as character, input pcRecordKey as character):
        define variable hBuffer as handle no-undo.
        
        hBuffer = GetBufferHandle(pcBufferName).
        ASsert:ArgumentNotNull(hBuffer, substitute('Buffer &1', pcBufferName)).
        
        return FindTableByKey(hBuffer, pcRecordKey).
    end method.
    
    /** Returns an ABL buffer handle for a table from the physical DataModel. 
        (See comments on GetTableHandle).
        
        @param character The table name 
        @return handle An ABL buffer handle for the specified table. */
    method protected handle GetBufferHandle (pcTable as char):
        return DatasetHandle:get-buffer-handle(pcTable).
    end method.
    
/* ITableOwner implementation */
    /** GetTableHandle called by IQuery when building 
        a query. We need to enforce that this method exists within
        each of the 'physical' Model classes, so it's just a wrapper
        for the internal abstract GetBufferHandle() call.
        
        @param character The table name 
        @return handle An ABL buffer handle for the specified table. */    
    method override final public handle GetTableHandle(input pcTableName as character):
        return GetBufferHandle(pcTableName).
    end method.
    
    method protected logical FindTableByKey(input phBuffer as handle, input pcRecordKey as character):
        Assert:ArgumentNotNull(phBuffer, 'Buffer').
        
        if pcRecordKey begins 'where' then
            phBuffer:find-unique(pcRecordKey) no-error.
        else
            phBuffer:find-by-rowid(to-rowid(pcRecordKey)) no-error.
        
        return phBuffer:available.
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pcValue as char ):
        FindTableByKey(pcBufferName, pcRecordKey).
        pcValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pcValue as char extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        pcValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as date ):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as date extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as datetime ):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as datetime extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as datetime-tz ):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output ptValue as datetime-tz extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        ptValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pdValue as decimal ):
        FindTableByKey(pcBufferName, pcRecordKey).
        pdValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pdValue as decimal extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        pdValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output phValue as handle ):
        FindTableByKey(pcBufferName, pcRecordKey).
        phValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output phValue as handle extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        phValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output piValue as int ):
        FindTableByKey(pcBufferName, pcRecordKey).
        piValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output piValue as int extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        piValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output piValue as int64 ):
        FindTableByKey(pcBufferName, pcRecordKey).
        piValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output piValue as int64 extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        piValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pcValue as longchar ):
        FindTableByKey(pcBufferName, pcRecordKey).
        pcValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output pcValue as longchar extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        pcValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.
    
    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output prValue as raw ):
        FindTableByKey(pcBufferName, pcRecordKey).
        prValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output prValue as raw extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        prValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output poValue as Object ):
        FindTableByKey(pcBufferName, pcRecordKey).
        poValue = GetBufferField(pcBufferName, pcField):buffer-value.               
    end method.

    method override public void GetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, output poValue as Object extent):
        FindTableByKey(pcBufferName, pcRecordKey).
        poValue = GetBufferField(pcBufferName, pcField):buffer-value.
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pcValue as character):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pcValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pcValue as char extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pcValue.
        
        return GetRecordKey(pcBufferName).
    end method.
            
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pcValue as longchar):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pcValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pcValue as longchar extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pcValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, phValue as handle):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = phValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, phValue as handle extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = phValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, piValue as int):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = piValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, piValue as int extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = piValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, piValue as int64):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = piValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, piValue as int64 extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = piValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pdValue as decimal):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pdValue.
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, pdValue as decimal extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = pdValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as date):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as date extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as datetime):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as datetime extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as datetime-tz):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, ptValue as datetime-tz extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = ptValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, prValue as raw):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = prValue.
        
        return GetRecordKey(pcBufferName).
    end method.

    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, prValue as raw extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = prValue.
        
        return GetRecordKey(pcBufferName).
    end method.

    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, poValue as Object):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
                
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = poValue.
        
        return GetRecordKey(pcBufferName).
    end method.

    method override public character SetValue(input pcBufferName as character, input pcRecordKey as character,  input pcField as character, poValue as Object extent):
        ValidateField(DataContainerActionEnum:Save,
                      pcBufferName,
                      pcRecordKey,
                      pcField).
               
        FindTableByKey(pcBufferName, pcRecordKey).
        GetBufferField(pcBufferName, pcField):buffer-value = poValue.
        
        return GetRecordKey(pcBufferName).
    end method.
    
    method override protected character extent GetTableNames():
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cTableNames as character extent no-undo.
        
        iMax = DatasetHandle:num-buffers.
        extent(cTableNames) = iMax.
        
        do iLoop = 1 to iMax:
            cTableNames[iLoop] = DatasetHandle:get-buffer-handle(iLoop):name.
        end.
        
        return cTableNames.
	end method.
	
	method protected void EnableDatasetForUpdate(input phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        if valid-handle(phDataset) then
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = true.
        end.
    end method.
        
    method protected void DisableDatasetForUpdate(input phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        if valid-handle(phDataset) then
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = no.
        end.
    end method.
    
end class.