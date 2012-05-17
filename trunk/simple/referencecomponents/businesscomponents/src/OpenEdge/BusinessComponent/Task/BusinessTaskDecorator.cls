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
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Task.IBusinessTask.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.
using OpenEdge.CommonInfrastructure.Common.IService.

using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.Task.BusinessTaskDecorator abstract implements IBusinessTask: 
    
    define protected property DecoratedBusinessTask as IBusinessTask no-undo get. private set.

    /** Contains a collection of the entities that this Task knows about and operates on with. */
    define public property BusinessEntities as IList no-undo
        get():
	       return DecoratedBusinessTask:BusinessEntities.
       end get.
    
    constructor public BusinessTaskDecorator(input poBusinessTask as IBusinessTask):
        Assert:ArgumentNotNull(poBusinessTask, 'Decorated Business Task').
        DecoratedBusinessTask = poBusinessTask.
    end constructor.
    
    /** External method to dynamically set the BusinessEntities property via InjectABL */ 
    method public void SetBusinessEntities(input poEntities as IList):
        DecoratedBusinessTask:SetBusinessEntities(poEntities).
    end method.

    /** Executes a requested task 
        
        @param ITaskRequest The request for this task
        @return ITaskResponse The response */
    method public ITaskResponse PerformTask(input poRequest as ITaskRequest):
        return DecoratedBusinessTask:PerformTask(poRequest).
	end method.
	
end class.