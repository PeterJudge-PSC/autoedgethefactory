/** ------------------------------------------------------------------------
    File        : IWorkStep
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Dec 02 10:33:58 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepResponse.

interface OpenEdge.BusinessComponent.WorkFlow.IWorkStep:
    
    /** (optional) The workstep name. */
    define public property Name as character no-undo get. set.
    
    method public void SetName (input pcName as character).
    
    /** Performs the WorkStep as the result of being called by a service provider.
        
        @param IWorkstepRequest The request parameters for this call. */
    method public void PerformStep(input poRequest as IWorkstepRequest).
    
    /* Retrieves the result of the WorkStep, after it's been performed as the 
       result of being called as a service provider.
       
       @param longchar The (unique) MessageId of the service request/response.
       @return IWorkstepResponse The response for the identifier.    */
    method public IWorkstepResponse GetResponse(input pcMessageId as longchar).
    
    /** Performs the Workstep */
    method public void PerformStep().
    
end interface.