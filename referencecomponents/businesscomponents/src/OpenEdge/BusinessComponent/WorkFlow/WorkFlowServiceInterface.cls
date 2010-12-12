/** ------------------------------------------------------------------------
    File        : WorkFlowServiceInterface
    Purpose     : Decorates a Business WorkFlow with a Service Provider interface -
                  ie. exposes it as an external service.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Dec 07 11:10:29 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.WorkFlow.IWorkFlow.
using OpenEdge.BusinessComponent.WorkFlow.WorkFlowDecorator.

using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.WorkFlow.WorkFlowServiceInterface inherits WorkFlowDecorator 
        implements IServiceProvider: 

    /** (mandatory) The service for which this service interface is servicing a request. */
    define public property Service as character no-undo get. private set.
		
	constructor public WorkFlowServiceInterface(input poWorkFlow as IWorkFlow,
                                                input pcServiceName as character):
		super (input poWorkFlow).
        
        Assert:ArgumentNotNullOrEmpty(pcServiceName, 'Service name').
        this-object:Service = pcServiceName.
	end constructor.

    method public void ExecuteRequest(input poRequest as IServiceRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poRequest).
        do iLoop = 1 to iMax:
            PerformFlow(cast(poRequest[iLoop], IWorkflowRequest)).
        end.
    end method.
    
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oResponse as IServiceResponse extent no-undo.
        
        iMax = extent(poRequest).
        extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax:
            PerformFlow(cast(poRequest[iLoop], IWorkflowRequest)).
            oResponse[iLoop] = cast(GetResponse(cast(poRequest[iLoop], IServiceMessage):MessageId)
                                , IServiceResponse).
        end.
        
        return oResponse.
    end method.
    
end class.