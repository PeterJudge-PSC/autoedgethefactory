/** ------------------------------------------------------------------------
    File        : DataContainerErrorEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 18 15:49:33 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.
using OpenEdge.Core.DataContainer.DataContainerActionEnum.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Lang.Assert.

class OpenEdge.Core.DataContainer.DataContainerErrorEventArgs inherits EventArgs /* DataContainerErrorEventArgs? */ :
    
    define public property DataContainerAction as DataContainerActionEnum no-undo get. set. 
    define public property TableName as character no-undo get. private set.
    
    define private temp-table ttError no-undo
        field RecordKey as rowid
        field ErrorString as character
        index idx1 as primary unique RecordKey
        .
    define private temp-table ttErrorField no-undo
        field TableName as char
        field RecordKey as rowid
        field FieldName as char
        index idx1 RecordKey.

    constructor public DataContainerErrorEventArgs (input pcTable as character):
        super().
        
        Assert:ArgumentNotNullOrEmpty(pcTable, 'Table').
        
        TableName = pcTable.
    end constructor.
    
    constructor public DataContainerErrorEventArgs (input pcTable as character,
                                                    input poAction as DataContainerActionEnum):
        this-object(pcTable).
        
        Assert:ArgumentNotNull(poAction, 'Model Action').
        
        DataContainerAction = poAction.
    end constructor.
    
    method public void AddErrorRecord (prKey as rowid, pcFieldList as char extent, pcErrorString as char):
        define variable iExtent as integer no-undo.
        
        define buffer lbError for ttError.
        define buffer lbErrorField for ttErrorField.
                
        create lbError.
        assign lbError.RecordKey   = prKey
               lbError.ErrorString = pcErrorString.
        do iExtent = 1 to extent(pcFieldList):
            create lbErrorField.
            assign lbErrorField.RecordKey = lbError.RecordKey
                   FieldName = pcFieldList[iExtent]. 
        end.
    end method.
    
end class.