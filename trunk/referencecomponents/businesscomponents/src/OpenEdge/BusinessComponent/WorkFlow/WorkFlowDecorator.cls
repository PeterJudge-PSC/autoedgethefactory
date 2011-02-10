/** ------------------------------------------------------------------------
    File        : WorkFlowDecorator
    Purpose     : Decorator class for decoracting/customising WorkFlows
                  without requiring inheritances.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 14:24:26 EST 2010
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.BusinessComponent.WorkFlow.IBusinessWorkFlow.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkflowResponse.

using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.WorkFlow.WorkFlowDecorator abstract
        implements IBusinessWorkFlow:
    
    /** The workflow being decorated. Could be a 'real' workflow, or another decorator. */
    define protected property DecoratedWorkFlow as IBusinessWorkFlow no-undo get. private set.

    define public property Name as longchar no-undo
       get():
           return DecoratedWorkFlow:Name.
       end get.
       set(input pcName as longchar):
           DecoratedWorkFlow:Name.
       end set. 
    
    constructor public WorkFlowDecorator(input poWorkFlow as IBusinessWorkFlow):
        Assert:ArgumentNotNull(poWorkFlow, 'WorkFlow').
        DecoratedWorkFlow = poWorkFlow.
    end constructor.
    
    method public IWorkFlowResponse GetResponse(input pcMessageId as longchar):
        return DecoratedWorkFlow:GetResponse(pcMessageId).
    end method.
    
    method public void PerformFlow():
        DecoratedWorkFlow:PerformFlow().
    end method.
           
    method public void PerformFlow(input poRequest as IWorkFlowRequest):
        DecoratedWorkFlow:PerformFlow(poRequest).
    end method.
    
end class.