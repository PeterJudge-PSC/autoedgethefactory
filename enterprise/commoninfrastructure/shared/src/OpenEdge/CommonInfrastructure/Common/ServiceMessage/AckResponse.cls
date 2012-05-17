/** ------------------------------------------------------------------------
    File        : AckResponse
    Purpose     : Simple response acknoledging receipt of a request.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 09:49:17 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IExternalizable.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.AckResponse inherits ServiceResponse
        implements IExternalizable: 

    constructor public AckResponse():
        /* default ctor required for serialization */
    end constructor.
    
    constructor public AckResponse(input poServiceRequest as IServiceRequest):
        super (poServiceRequest).
    end constructor.
        
    constructor public AckResponse ( input pcMessageId as longchar, input pcService as character, input poActionType as ServiceMessageActionEnum ):
        super (input pcMessageId, input pcService, input poActionType).
    end constructor.
    
    method override public void WriteObject(input poStream as IObjectOutput):
        super:WriteObject(poStream).
    end method.

    method override public void ReadObject(input poStream as IObjectInput):
        super:ReadObject(poStream).
    end method.

end class.