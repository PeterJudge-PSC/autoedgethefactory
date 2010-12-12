/** ------------------------------------------------------------------------
    File        : IWorkFlow
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Dec 02 10:33:58 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowResponse.

interface OpenEdge.BusinessComponent.WorkFlow.IWorkFlow:
    /** (optional) The workflow name. */
    define public property Name as longchar no-undo get. set.
    
    /** Performs the WorkFlow */
    method public void PerformFlow().

    method public void PerformFlow(input poRequest as IWorkflowRequest).
    
    method public IWorkflowResponse GetResponse(input pcMessageId as longchar).

end interface.