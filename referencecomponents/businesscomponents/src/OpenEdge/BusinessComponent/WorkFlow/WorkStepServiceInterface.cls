/** ------------------------------------------------------------------------
    File        : WorkStepServiceInterface
    Purpose     : Decorates a Workstep with a Service Provider interface -
                  ie. exposes it as an external service.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Dec 07 08:52:34 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.WorkFlow.WorkStepDecorator.
using OpenEdge.BusinessComponent.WorkFlow.IWorkStep.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.WorkFlow.WorkStepServiceInterface inherits WorkStepDecorator
        implements IServiceProvider: 

    /** [IServiceProvider] (mandatory) The service for which this service interface is servicing a request. */
    define public property Service as character no-undo get. private set.
    
    constructor public WorkStepServiceInterface(input poWorkStep as IWorkStep,
                                                input pcServiceName as character):
        super (poWorkStep).
        
        Assert:ArgumentNotNullOrEmpty(pcServiceName, 'Service name').
        assign this-object:Service = pcServiceName
               /* Name defaults to Service */
               DecoratedWorkStep:Name = pcServiceName.
    end constructor.
    
    method public void ExecuteRequest(input poRequest as IServiceRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poRequest).
        do iLoop = 1 to iMax:
            PerformStep(cast(poRequest[iLoop], IWorkstepRequest)).
        end.
    end method.
    
    method public IServiceResponse extent ExecuteSyncRequest(input poRequest as IServiceRequest extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oResponse as IServiceResponse extent no-undo.
        
        iMax = extent(poRequest).
        extent(oResponse) = iMax.
        
        do iLoop = 1 to iMax:
            PerformStep(cast(poRequest[iLoop], IWorkstepRequest)).
            oResponse[iLoop] = cast(GetResponse(cast(poRequest[iLoop], IServiceMessage):MessageId)
                                , IServiceResponse).
        end.
        
        return oResponse.
    end method.

end class.