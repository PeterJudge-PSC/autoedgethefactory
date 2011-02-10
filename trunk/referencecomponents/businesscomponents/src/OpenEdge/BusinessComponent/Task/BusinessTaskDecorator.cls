/** ------------------------------------------------------------------------
    File        : BusinessTaskDecorator
    Purpose     : Decorator class for decoracting/customising Business Tasks
                  without requiring inheritance.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 11:06:01 EST 2011
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, there is a ServiceInterface class which extents this
                    decorator, and which is used to expose the Business Task as a service.
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.BusinessComponent.Task.IBusinessTask.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.
using OpenEdge.CommonInfrastructure.Common.IService.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.Task.BusinessTaskDecorator abstract implements IBusinessTask: 
    
    define protected property DecoratedBusinessTask as IBusinessTask no-undo get. private set.

	define public property Services as IMap no-undo
	   get():
	       return DecoratedBusinessTask:Services.
       end get.
       
    constructor public BusinessTaskDecorator (input poBusinessTask as IBusinessTask):
        Assert:ArgumentNotNull(poBusinessTask, 'Decorated Business Task').
        DecoratedBusinessTask = poBusinessTask.
    end constructor.
       
	method public void ExecuteTask(input poRequest as ITaskRequest):
	    DecoratedBusinessTask:ExecuteTask(poRequest).
	end method.

	method public ITaskResponse GetTaskResponse( input pcMessageId as longchar):
	    return DecoratedBusinessTask:GetTaskResponse(pcMessageId).
	end method.

	method public void SetService( input pcService as character, input poService as IService):
	    DecoratedBusinessTask:SetService(pcService, poService).
	end method.
	
end class.