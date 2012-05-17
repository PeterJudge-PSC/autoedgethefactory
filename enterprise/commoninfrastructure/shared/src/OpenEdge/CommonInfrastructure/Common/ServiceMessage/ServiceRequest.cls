/** ------------------------------------------------------------------------
    File        : ServiceRequest
    Purpose     : A request to a service for data or action
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 16:19:53 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IExternalizable.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceRequest inherits ServiceMessage
        implements IServiceRequest, IExternalizable:
    
    constructor public ServiceRequest():
        /* default ctor required for serialization */    
    end constructor.
    
    constructor public ServiceRequest (input pcService as character,
                                       input poMessageType as ServiceMessageActionEnum):
        super(input pcService, input poMessageType).
    end constructor.
    
    constructor public ServiceRequest (input pcMessageId as longchar,
                                       input pcService as character,
                                       input poActionType as ServiceMessageActionEnum ):
        super (input pcMessageId, input pcService, input poActionType).
    end constructor.

    method override public void WriteObject(input poStream as IObjectOutput):
        super:WriteObject(poStream).
    end method.

    method override public void ReadObject(input poStream as IObjectInput):
        super:ReadObject(poStream).
    end method.    
    
end class.