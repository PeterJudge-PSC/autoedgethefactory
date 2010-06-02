/*------------------------------------------------------------------------
    File        : ModelErrorEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 18 15:49:33 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.*.
using OpenEdge.Core.System.*.

class OpenEdge.PresentationLayer.Common.ModelErrorEventArgs inherits EventArgs :
    define public property HasError as logical no-undo get. set.
    define public property BufferName as character no-undo get. set.
    
    define private temp-table ttError no-undo
        field RecordKey as rowid
        field ErrorString as character
        index idx1 as primary unique RecordKey
        .
    define private temp-table ttErrorField no-undo
        field BufferName as char
        field RecordKey as rowid
        field FieldName as char
        index idx1 RecordKey.
    
    constructor public ModelErrorEventArgs ():
        super().
                
        HasError = false.
    end constructor.
            
    constructor public ModelErrorEventArgs (pcBuffer as char):
        this-object().
        
        this-object:BufferName = pcBuffer.
    end constructor.
        
    method public void AddErrorRecord (prKey as rowid, pcFieldList as char extent, pcErrorString as char):
        define variable iExtent as integer no-undo.
        
        define buffer lbError for ttError.
        define buffer lbErrorField for ttErrorField.
        
        HasError = true.
                
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