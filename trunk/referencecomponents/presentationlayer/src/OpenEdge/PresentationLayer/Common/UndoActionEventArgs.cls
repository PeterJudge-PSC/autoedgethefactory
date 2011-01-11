/** ------------------------------------------------------------------------
    File        : UndoActionEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 31 11:44:27 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.UpdateActionEnum.
using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.Core.System.EventArgs.
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.UndoActionEventArgs inherits EventArgs   : 
    
    define public property RecordKey as character extent no-undo get. set. /* where strings */
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as character no-undo get. set.
    define public property BufferName as character no-undo get. set.
    define public property UndoActionType as UpdateActionEnum no-undo get. set. 
    define public property Order as integer no-undo get. set.

    constructor UndoActionEventArgs():
        super().
    end constructor.
                
    constructor UndoActionEventArgs(poModelService as IComponentInfo,
                                    pcQueryName as char,
                                    pcBufferName as char,
                                    pcRecordKey as char extent,
                                    poUndoActionType as UpdateActionEnum):
        this-object().
        
        assign BufferName = pcBufferName
               RecordKey = pcRecordKey
               QueryName = pcQueryName
               ModelService = poModelService
               UndoActionType = poUndoActionType.                        
    end constructor.

end class.