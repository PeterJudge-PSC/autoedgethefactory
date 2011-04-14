/** ------------------------------------------------------------------------
    File        : WorkStepDecorator
    Purpose     : Decorator class for decoracting/customising WorkFlow WorkSteps
                  without requiring inheritances.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Dec 06 13:07:50 EST 2010
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern  
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.WorkFlow.IWorkStep.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepResponse.

using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.WorkFlow.WorkStepDecorator abstract
        implements IWorkStep:
    
    /** The workstep being decorated. Could be a 'real' workstep, or another decorator. */
    define protected property DecoratedWorkStep as IWorkStep no-undo get. private set.

    /** (optional) The workstep name. */
    define public property Name as longchar no-undo
        get():
            return DecoratedWorkStep:Name.
        end get.
        set (input pcName as longchar):
            DecoratedWorkStep:Name = pcName.
        end set.
    
    constructor public WorkStepDecorator(input poWorkStep as IWorkStep):
        Assert:ArgumentNotNull(poWorkStep, 'WorkStep').
        DecoratedWorkStep = poWorkStep.
    end constructor.
    
    method public void PerformStep():
        DecoratedWorkStep:PerformStep().
    end method.
    
    method public void PerformStep(input poRequest as IWorkstepRequest).
       DecoratedWorkStep:PerformStep(poRequest).
   end method.
           
    method public IWorkstepResponse GetResponse(input pcMessageId as longchar):
        return DecoratedWorkStep:GetResponse(pcMessageId).
    end method.
    
end class.