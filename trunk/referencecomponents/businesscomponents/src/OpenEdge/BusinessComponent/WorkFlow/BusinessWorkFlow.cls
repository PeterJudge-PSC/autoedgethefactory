/** ------------------------------------------------------------------------
    File        : WorkFlow
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 13:52:11 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.BusinessComponent.WorkFlow.IBusinessWorkFlow.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkflowResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.Service.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.String.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.WorkFlow.BusinessWorkFlow abstract inherits Service 
        implements IBusinessWorkFlow:
    
    /** (optional) The workflow name. */
    define public property Name as longchar no-undo
        get():
            /* default to the typename */
            if Name eq ? or Name eq '' then
                Name = this-object:GetClass():TypeName.
        end get.
        set.
    
    /** Typically we'd only have a single request-response at a time, but we have no
        guarantee of that, so we use a map to be safe. */
    define protected property ServiceResponses as IMap no-undo get. private set.

    constructor public BusinessWorkFlow(input poServiceManager as IServiceManager,
                                        input poComponentInfo as IComponentInfo,
                                        input pcFlowName as longchar):
        this-object(poServiceManager, poComponentInfo).
        
        Assert:ArgumentNotNullOrEmpty(pcFlowName, 'WorkFlow name').
        this-object:Name = pcFlowName.                                    
    end constructor.
        
    constructor public BusinessWorkFlow(input poServiceManager as IServiceManager,
                                        input poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
        
        assign ServiceResponses = new TypedMap(
                                      String:Type, 
                                      Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse')).
    end constructor.
    
    method abstract public void PerformFlow().

    method public void PerformFlow(input poRequest as IWorkflowRequest):
        ServiceResponses:Put(new String(cast(poRequest, IServiceMessage):MessageId),
                             new ServiceResponse(cast(poRequest, IServiceRequest))).
        
        /* Other Before and after steps can be performed by decorators */
        
        PerformFlow().
        
        catch oError as ApplicationError:
            define variable oCurrentResponse as IServiceResponse no-undo.
            
            oCurrentResponse = cast(ServiceResponses:Get(new String(cast(poRequest, IServiceMessage):MessageId))
                                , IServiceResponse).
            assign oCurrentResponse:HasError = true
                   oCurrentResponse:ErrorText = oError:ResolvedMessageText().
            undo, throw oError. 
        end catch.
    end method.
    
    method public IWorkflowResponse GetResponse(input pcMessageId as longchar):
        return cast(ServiceResponses:Remove(new String(pcMessageId)), IWorkflowResponse).        
    end method.

end class.