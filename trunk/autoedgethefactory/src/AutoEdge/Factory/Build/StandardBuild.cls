/*------------------------------------------------------------------------
    File        : StandardBuild
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 19 12:00:23 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Build.IBuildVehicle.
using AutoEdge.Factory.Build.StandardBuild.

using OpenEdge.BusinessComponent.WorkFlow.WorkFlow.
using OpenEdge.BusinessComponent.WorkFlow.IWorkStep.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IWorkflowResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.Service.

using OpenEdge.Core.System.ApplicationError.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.

class AutoEdge.Factory.Build.StandardBuild inherits WorkFlow
        implements IBuildVehicle:
    
    /** (mandatory) OrderId passed in to constructor. [IBuildVehicle] */  
    define public property OrderId as character no-undo get. private set.
    
    /** (derived, readonly) The current status [IBuildVehicle] */
	define public property BuildStatus as character no-undo get. private set.
	
/*DECORATE
	/* savvion-only, defined as different interface somewhere  */
	define public property ProcessInstanceId as int64 no-undo get. set. 

    define private variable mcPortalHost as character no-undo.
    define private variable mcPortalUser as character no-undo.
    define private variable mcPortalPassword as character no-undo.
    define private variable mcWorkItemName as character no-undo.
		
	constructor public StandardBuild(input pcOrderId as character):
	    assign OrderId = pcOrderId
	    
               /* savvion data */
               mcPortalHost = '184.72.251.33:18793'
               mcWorkItemName = 'wsAETF'          /* this workstep, 'Build Vehicle' */
               mcWorkItemName = 'Build Vehicle'
               mcPortalUser = 'factory'
               mcPortalPassword = 'factory'.
    end method.
*/	
    
    constructor public StandardBuild(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo, 'BuildVehicle').
    end constructor.
    
	method override public IWorkflowResponse GetResponse(input pcMessageId as longchar):
	    define variable oResponse as IWorkflowResponse no-undo.
	    
        oResponse  = super:GetResponse(pcMessageId).
        if BuildStatus matches '*[ ERROR ]' then
            assign cast(oResponse, IServiceResponse):ErrorText = BuildStatus
                   cast(oResponse, IServiceResponse):HasError = true.
        
        return oResponse. 
	end method.	
	
	method override public void PerformFlow(input poRequest as IWorkflowRequest):
        define variable cMsgData as longchar no-undo.
        
        cast(poRequest, IServiceMessage):GetMessageData(output cMsgData).
        OrderId = string(cMsgData).
        
        BuildStatus = substitute('WorkFlow &1 [ STARTING ]', Name).        
        
	    PerformFlow().
        
        BuildStatus = substitute('WorkFlow &1 [ OK ]', Name).
        catch oError as ApplicationError:
            BuildStatus = substitute('WorkFlow &1 [ ERROR ]', Name).
            undo, throw oError.
        end catch.
        finally:
            OrderId = ''.
        end finally.        
    end method.
    
    method override public void PerformFlow():
	    /* this-object:Service is "BuildVehicle" " 
	       our naming convention is Workflow::WorkStep */
	    
	    /* Note that the order of the steps is defined here by the
	       order of the calls. */
        PerformStep(this-object:Name + '::ProcessComponents').
        PerformStep(this-object:Name + '::AssembleChassis').
        PerformStep(this-object:Name + '::AssembleBody').
        PerformStep(this-object:Name + '::PaintVehicle').
        PerformStep(this-object:Name + '::AssembleInterior').
        PerformStep(this-object:Name + '::MateAssembledComponents').
        PerformStep(this-object:Name + '::CompleteVehicleBuild').
        
        PauseAndCatchOurBreath(3).
	end method.
	
	method private void PauseAndCatchOurBreath(piWait as int):
	    message 'PauseAndCatchOurBreath=' + string(piWait).
	    pause piWait.
    end method.
    
    method protected void PerformStep(input pcStep as longchar):
        define variable oStep as IWorkStep no-undo.
        define variable oWSResponse as IServiceResponse no-undo. 
        
        BuildStatus = substitute('WorkStep &1 [ STARTING ]', pcStep).
        
        oStep = cast(ServiceManager:StartService(Class:GetClass('OpenEdge.BusinessComponent.WorkFlow.IWorkStep'), string(pcStep)),
                    IWorkStep).
        oStep:PerformStep().
        
        BuildStatus = substitute('WorkStep &1 [ OK ]', pcStep).
        catch oError as ApplicationError:
            BuildStatus = substitute('WorkStep &1 [ ERROR ]', pcStep).
            undo, throw oError. 
        end catch.
    end method.

end class.