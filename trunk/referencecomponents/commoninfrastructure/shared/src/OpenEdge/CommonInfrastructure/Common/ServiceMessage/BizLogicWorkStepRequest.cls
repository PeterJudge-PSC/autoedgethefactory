/*------------------------------------------------------------------------
    File        : BizLogicWorkStepRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Dec 07 13:13:41 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.WorkstepRequest.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Lang.Collections.ICollection.


class OpenEdge.CommonInfrastructure.Common.ServiceMessage.BizLogicWorkStepRequest inherits WorkstepRequest
        implements IExternalizable:
    
    define public property WorkItemName as character no-undo get. set.
    define public property ProcessInstanceName as character no-undo get. set.
    define public property ProcessInstanceId as int64 no-undo get. set.
    define public property WorkItemId as int64 no-undo get. set.
    
    constructor public BizLogicWorkStepRequest():
        /* default ctor required for serialization */
    end constructor.
    
    constructor public BizLogicWorkStepRequest(input pcService as character ):
        super (input pcService).
    end constructor.

    constructor public BizLogicWorkStepRequest ( input pcMessageId as longchar, input pcService as character ):
        super (input pcMessageId, input pcService).
    end constructor.

    method override public void WriteObject(input poStream as IObjectOutput):
        super:WriteObject(poStream).
        
        poStream:WriteChar(WorkItemName).
        poStream:WriteChar(ProcessInstanceName).
        poStream:WriteInt64(ProcessInstanceId).
        poStream:WriteInt64(WorkItemId).
    end method.

    method override public void ReadObject(input poStream as IObjectInput):
        super:ReadObject(poStream).
        
        assign WorkItemName = poStream:ReadChar()
               ProcessInstanceName = poStream:ReadChar()
               ProcessInstanceId = poStream:ReadInt64()
               WorkItemId = poStream:ReadInt64().
    end method.    
    
end class.