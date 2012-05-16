 /*------------------------------------------------------------------------
    File        : BPMService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 07 15:39:09 EST 2011
    Notes       : 
         GetAssignedTasks (), 
         GetAvailableTasks (),

GetProcessTemplateNames (), 

GetDataSlotTemplates (character), 
GetTask (character), 
StartProcess (character), 
StartProcess (character, Progress.BPM.DataSlotTemplate[ ]), 
                                        
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.UnsupportedOperationError.

using OpenEdge.Lang.BPM.DataSlotTemplate.
using OpenEdge.Lang.BPM.DataSlotInstance.
using OpenEdge.Lang.BPM.ProcessTemplate.
using OpenEdge.Lang.BPM.ProcessInstance.
using OpenEdge.Lang.BPM.WorkItem.
using OpenEdge.Lang.BPM.WorkStepTemplate.
using OpenEdge.Lang.BPM.WorkStepInstance.
using OpenEdge.Lang.BPM.Task.
using OpenEdge.Lang.BPM.IBizLogicAPI.
using OpenEdge.Lang.BPM.BPMService.

using Progress.BPM.UserSession.
using Progress.Lang.Object.

class OpenEdge.Lang.BPM.BPMService 
        implements IBizLogicAPI:
    
    define protected property UserSession as UserSession no-undo get. private set.
    define private variable mcConnectionURL as character no-undo.
    
    define public property IsConnected as logical no-undo
        get():
            return valid-object(this-object:UserSession) and this-object:UserSession:Connected. 
        end get.
    
	define public property SessionId as longchar no-undo
	   get():
	       if valid-object(this-object:UserSession) then
	           return this-object:UserSession:SessionId.
           else
            return ?.
       end get.
    
	constructor public BPMService(input pcProtocol as character,
	                              input pcHost as character,
	                              input piPort as integer):
        mcConnectionURL = substitute('-URL &1://&2:&3', 
                                pcProtocol,
                                pcHost,
                                piPort).
	end constructor.

    method public void Connect():
		this-object:UserSession = new UserSession(mcConnectionURL).
    end method.
    
    method public void Disconnect():
        EndSession().
        this-object:UserSession = ?.
    end method.

	method public void EstablishSession(input pcSessionId as longchar):
		this-object:UserSession:Connect(string(pcSessionId)).
	end method.

	method public void Login( input pcUser as character, input pcPassword as character):
	    this-object:UserSession:Connect(pcUser, pcPassword).
	end method.
	
	method public void EndSession():
	    this-object:UserSession:Disconnect(false).
	end method.
	
	method public void Logout():
	    this-object:UserSession:Disconnect(true).
	end method.

    method public character extent GetUserAuthorizedProcessTemplateNames(  ):
        return this-object:UserSession:GetProcessTemplateNames().
    end method.
    
    destructor public BPMService():
        this-object:Disconnect().         
    end destructor.

    method override public logical Equals(input p0 as Object ):
       define variable lEquals as logical no-undo.
       
       lEquals = super:Equals(input p0).
       if not lEquals and valid-object(p0) and type-of(p0, BPMService) then
           lEquals = this-object:SessionId eq cast(p0, BPMService):SessionId.
       
       return lEquals.                 
    end method. 

    method public DataSlotTemplate extent GetProcessTemplateDataSlots( input pcProcessTemplateName as character ):
        return OpenEdge.Lang.BPM.DataSlotTemplate:CreateFromBuiltIn(
            this-object:UserSession:GetDataSlotTemplates(pcProcessTemplateName)).
    end method.

    /** -- **/
	method public character GetStatus():
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessTemplate GetProcessTemplate( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public logical IsSessionValid():
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessTemplate extent GetUserAuthorizedProcessTemplateList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void CompleteWorkItem( input pcWorkItemName as character, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void CompleteWorkItemFromWiid( input piWorkItemInstanceId as int64, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessInstance extent GetProcessInstanceList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void AssignWorkItem( input pcWorkItemName as character, input pcPerformer as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public int64 GetProcessTemplateID( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessInstance CreateProcessInstance( input pcProcessTemplateName as character, input pcProcessInstanceNamePrefix as character, input pcPriority as character, input poDataSlotTemplate as OpenEdge.Lang.BPM.DataSlotTemplate extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkStepInstance GetWorkStepInstance( input pcProcessInstanceName as character, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.
	
	method public OpenEdge.Lang.BPM.WorkStepTemplate GetWorkStepTemplate( input pcProcessTemplateName as character, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).	
	end method.

	method public OpenEdge.Lang.BPM.WorkItem extent GetAvailableWorkItemList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem extent GetAssignedWorkItemList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).	    
	end method.
	
	method public OpenEdge.Lang.BPM.Task extent GetAvailableTasks(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.Task extent GetAssignedTasks(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.Task extent CreateTasks( input poWorkItem as OpenEdge.Lang.BPM.WorkItem extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void CompleteTask( input poTask as OpenEdge.Lang.BPM.Task ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessInstance GetProcessInstance( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem GetWorkItem( input pcWorkItemName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public character extent GetProcessTemplateVersions( input pcApplicationName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessInstancePriority( input pcProcessInstanceName as character, input pcPriority as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public longchar GetProcessTemplateXML( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void RemoveProcessTemplate( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void ResumeProcessInstance( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SuspendProcessInstance( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public logical IsProcessTemplateExist( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem extent GetProxyAssignedWorkItemList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem extent GetProxyAvailableWorkItemList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem extent GetSuspendedWorkItemList(  ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.



	method public character GetProcessTemplateAppName( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public character GetProcessTemplateNameFromProcessInstance( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
    end method.
    
	method public character GetProcessTemplateNameFromProcessID( input piProcessTemplateId as int64 ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).	
	end method.

	method public OpenEdge.Lang.BPM.WorkStepTemplate extent GetProcessTemplateWorkSteps( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessTemplate GetProcessTemplateFromID( input piProcessTemplateId as int64 ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.


	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetProcessInstanceDataSlots( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetProcessInstanceDataSlot( input pcProcessInstanceName as character, input pcDataslotName as character extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetProcessInstanceDataSlotFromPiid( input piProcessInstanceId as int64, input pcDataslotName as character extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetWorkStepInstanceDataSlots( input pcProcessInstanceName as character, input pcWorkstepInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetWorkStepInstanceDataSlotsFromPiid( input piProcessInstanceId as int64, input pcWorkstepInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetWorkItemDataSlots( input pcWorkItemName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotInstance extent GetWorkItemDataSlotsFromWiid( input piWorkstepInstanceId as int64 ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotTemplate extent GetWorkStepTemplateDataSlots( input pcProcessTemplateName as character, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.DataSlotTemplate extent GetWorkStepTemplateDataSlotsFromPtid( input piProcessTemplateId as int64, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessTemplateDataSlotValue( input pcProcessTemplateName as character, input poDataSlotTemplate as OpenEdge.Lang.BPM.DataSlotTemplate ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessTemplateDataSlotsValue( input pcProcessTemplateName as character, input poDataSlotTemplate as OpenEdge.Lang.BPM.DataSlotTemplate extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessInstanceDataSlotValue( input pcProcessInstanceName as character, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessInstanceDataSlotsValue( input pcProcessInstanceName as character, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetWorkItemDataSlotsValue( input pcWorkItemName as character, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetWorkItemDataSlotValue( input pcWorkItemName as character, input poDataSlotInstance as OpenEdge.Lang.BPM.DataSlotInstance ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.ProcessInstance GetProcessInstanceFromID( input piProcessInstanceId as int64 ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SetProcessInstanceDueDate( input pcProcessInstanceName as character, input ptDueDate as datetime-tz ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkItem GetWorkItemFromID( input piWorkItemInstanceId as int64 ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SuspendWorkItem( input pcWorkItemName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void ResumeWorkItem( input pcWorkItemName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void AssignWorkItemFromWiid( input piWorkItemInstanceId as int64, input pcPerformer as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void ReassignWorkItem( input pcWorkItemName as character, input pcPerformer as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.
	
	method public void ReassignWorkItemFromWiid( input piWorkItemInstanceId as int64, input pcPerformer as character ):
	        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.

	method public void MakeAvailableWorkItem( input pcWorkItemName as character, input pcPerformers as character extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void MakeAvailableWorkItemFromWiid( input piWorkItemInstanceId as int64, input pcPerformers as character extent ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkStepInstance GetWorkStepInstanceFromPiid( input piProcessInstanceId as int64, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public OpenEdge.Lang.BPM.WorkStepInstance extent GetProcessInstanceWorkSteps( input pcProcessInstanceName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void SuspendWorkStepInstance( input pcProcessInstanceName as character, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).		
	end method.

	method public void ResumeWorkStepInstance( input pcProcessInstanceName as character, input pcWorkStepName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.

	method public OpenEdge.Lang.BPM.WorkStepTemplate extent GetStartWorkStepTemplate( input pcProcessTemplateName as character ):
        undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.

	method public OpenEdge.Lang.BPM.DataSlotTemplate extent GetProcessTemplateDataSlot( input pcProcessTemplateName as character, input pcDataslotName as character extent ):
		undo, throw new UnsupportedOperationError(entry(1, program-name(1), ' '), entry(2, program-name(1), ' ')).
	end method.

end class.