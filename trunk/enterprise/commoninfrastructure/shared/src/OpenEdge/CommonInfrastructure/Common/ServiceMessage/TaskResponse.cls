/** ------------------------------------------------------------------------
    File        : TaskResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 12:05:46 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.

using OpenEdge.Lang.String.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.TaskResponse inherits ServiceResponse 
        implements ITaskResponse, IExternalizable: 

	define public property ServiceResponses as IMap no-undo
	   get():
            if not valid-object(ServiceResponses) then
                ServiceResponses = new TypedMap(
                    String:Type,
                    Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse')).
            return ServiceResponses.
        end get.
    private set.
		
	constructor public TaskResponse ( input pcMessageId as longchar, input pcService as character):
		super (input pcMessageId, input pcService, input ServiceMessageActionEnum:PerformTask).
	end constructor.

	constructor public TaskResponse ( input poServiceRequest as ITaskRequest ):
		super (cast(poServiceRequest, IServiceRequest)).
	end constructor.

	constructor public TaskResponse (  ):
		super ().
	end constructor.

	method override public void ReadObject( input poStream as IObjectInput ):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oKeys as Object extent no-undo.
        define variable oValues as Object extent no-undo.
        
        super:ReadObject(input poStream).

        assign oKeys = poStream:ReadObjectArray()
               oValues = poStream:ReadObjectArray()
               iMax = extent(oKeys).
        
        do iloop = 1 to iMax:
            ServiceResponses:Put(oKeys[iLoop], oValues[iLoop]).
        end.
	end method.

	method override public void WriteObject( input poStream as IObjectOutput ):
		super:WriteObject(input poStream).
		
        poStream:WriteObjectArray(ServiceResponses:KeySet:ToArray()).
        poStream:WriteObjectArray(ServiceResponses:Values:ToArray()).
	end method.

end class.