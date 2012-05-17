/** ------------------------------------------------------------------------
    File        : TaskRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 10:32:36 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.TaskRequest inherits ServiceRequest
        implements ITaskRequest, IExternalizable: 

    define public property ServiceRequests as IMap no-undo
        get():
            if not valid-object(ServiceRequests) then
                ServiceRequests = new TypedMap(
                    String:Type,
                    Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest')).
            
            return ServiceRequests.
        end get.
    private set.

	constructor public TaskRequest(input pcMessageId as longchar,
	                               input pcService as character,
	                               input poActionType as ServiceMessageActionEnum ):
		super (input pcMessageId, input pcService, input poActionType).
	end constructor.

	constructor public TaskRequest(input pcService as character,
	                               input poMessageType as ServiceMessageActionEnum ):
		super (input pcService, input poMessageType).
	end constructor.
	
    method override public void ReadObject(input poStream as IObjectInput ):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oKeys as Object extent no-undo.
        define variable oValues as Object extent no-undo.
        
        super:ReadObject(input poStream).

        assign oKeys = poStream:ReadObjectArray()
               oValues = poStream:ReadObjectArray()
               iMax = extent(oKeys).
        
        do iloop = 1 to iMax:
            ServiceRequests:Put(oKeys[iLoop], oValues[iLoop]).
        end.
    end method.

    method override public void WriteObject(input poStream as IObjectOutput ):
        super:WriteObject(input poStream).
        
        poStream:WriteObjectArray(ServiceRequests:KeySet:ToArray()).
        poStream:WriteObjectArray(ServiceRequests:Values:ToArray()).
    end method.

end class.