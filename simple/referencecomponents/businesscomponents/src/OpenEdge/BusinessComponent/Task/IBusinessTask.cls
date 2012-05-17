/** ------------------------------------------------------------------------
    File        : IBusinessTask
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 10:15:53 EST 2011
    Notes       : * This task represents a collection of entities.
  ---------------------------------------------------------------------- */
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.

using OpenEdge.Lang.Collections.IList.

interface OpenEdge.BusinessComponent.Task.IBusinessTask:
    
    /** Contains a collection of the entities that this Task knows about and operates on with.
        This collection is List since the order of the entities is typically important */
    define public property BusinessEntities as IList no-undo get.
    
    /** External method to dynamically set the BusinessEntities property via InjectABL */
    method public void SetBusinessEntities(input poEntities as IList).

    /** Executes a requested task 
        
        @param ITaskRequest The request for this task */
    method public ITaskResponse PerformTask(input poRequest as ITaskRequest).
    
end interface.