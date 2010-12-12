/** ------------------------------------------------------------------------
    File        : IBizLogicAPI
    Purpose     : ABL interface into the Savvion BizLogic API
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 22 12:18:05 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicAPI.

using OpenEdge.BusinessComponent.WorkFlow.BizLogic.ProcessTemplate.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.ProcessInstance.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkItem.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkStepTemplate.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.WorkStepInstance.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotTemplate.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.

interface OpenEdge.BusinessComponent.WorkFlow.BizLogic.IBizLogicAPI:  

    /** Connects to a Savvion server, and establishes a session.
    
        @param character Username
        @param character Password
        @return character A unique session id for the session. */  
    method public character Connect(input pcUser as character,
                                    input pcPassword as character).
    
    /** Disconnects the specified session
        
        @param character A unique session id for the session. */
    method public void Disconnect(input pcSessionId as longchar).
    
    method public character GetStatus().
    
    /* @param character A unique session id for the session. */
    method public ProcessTemplate GetProcessTemplate(input pcSessionId as longchar,
                                                     input pcProcessTemplateName as character).
    /* @param character A unique session id for the session. */
    method public logical IsSessionValid(input pcSessionId as longchar).
    
    /* @param character A unique session id for the session. */
    method public ProcessTemplate extent GetUserAuthorizedProcessTemplateList(input pcSessionId as longchar).
    
    /* @param character A unique session id for the session. */
    method public void CompleteWorkItem(input pcSessionId as longchar,
                                        input pcWorkItemName as character,
                                        input poDataSlotInstance as DataSlotInstance extent).
    
    /* @param character A unique session id for the session. */
    method public ProcessInstance extent GetProcessInstanceList(input pcSessionId as longchar).
    
    /* @param character A unique session id for the session. */            
    method public void AssignWorkItem(input pcSessionId as longchar,
                                      input pcWorkItemName as character,
                                      input pcPerformer as character).
    
    /* @param character A unique session id for the session. */        
    method public int64 GetProcessTemplateID(input pcSessionId as longchar,
                                             input pcProcessTemplateName as character).
    /* @param character A unique session id for the session. */
    method public ProcessInstance CreateProcessInstance(input pcSessionId as longchar,
                                                        input pcProcessTemplateName as character,
                                                        input pcProcessInstanceNamePrefix as character,
                                                        input pcPriority as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).
                                                        
    method public WorkStepInstance GetWorkStepInstance(input pcSessionId as longchar,
                                                       input pcProcessInstanceName as character,
                                                       input pcWorkStepName as character).
            
    method public WorkStepTemplate GetWorkStepTemplate(input pcSessionId as longchar,
                                                       input pcProcessTemplateName as character,
                                                       input pcWorkStepName as character).
            
    method public WorkItem extent GetAvailableWorkItemList(input pcSessionId as longchar).
            
    method public WorkItem extent GetAssignedWorkItemList(input pcSessionId as longchar).

    method public ProcessInstance GetProcessInstance(input pcSessionId as longchar,
                                                     input pcProcessInstanceName as character).

    method public WorkItem GetWorkItem(input pcSessionId as longchar,
                                       input pcWorkItemName as character).
            
    method public character extent GetProcessTemplateVersions(input pcSessionId as longchar,
                                                              input pcApplicationName as character).
    
    method public void SetProcessInstancePriority(input pcSessionId as longchar,
                                                  input pcProcessInstanceName as character,
                                                  input pcPriority as character).
            
    method public longchar GetProcessTemplateXML(input pcSessionId as longchar,
                                                 input pcProcessTemplateName as character).
            
    method public void RemoveProcessTemplate(input pcSessionId as longchar,
                                             input pcProcessTemplateName as character).

    method public void ResumeProcessInstance(input pcSessionId as longchar,
                                             input pcProcessInstanceName as character).
            
    method public void SuspendProcessInstance(input pcSessionId as longchar,
                                              input pcProcessInstanceName as character).
            
    method public logical IsProcessTemplateExist(input pcSessionId as longchar,
                                                 input pcProcessTemplateName as character).
            
    method public WorkItem extent GetProxyAssignedWorkItemList(input pcSessionId as longchar).
            
    method public WorkItem extent GetProxyAvailableWorkItemList(input pcSessionId as longchar).
    
    method public WorkItem extent GetSuspendedWorkItemList(input pcSessionId as longchar).
            
    method public character extent GetUserAuthorizedProcessTemplateNames(input pcSessionId as longchar).
    
    method public character GetProcessTemplateAppName(input pcSessionId as longchar,
                                                      input pcProcessTemplateName as character).
            
    method public character GetProcessTemplateNameFromProcessInstance(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
    
    method public character GetProcessTemplateNameFromProcessID(input pcSessionId as longchar,
                                                                input piProcessTemplateId as int64).
                                                                
    method public WorkSteptemplate extent GetProcessTemplateWorkSteps(input pcSessionId as longchar,
                                                                      input pcProcessTemplateName as character).
            
    method public ProcessTemplate GetProcessTemplateFromID(input pcSessionId as longchar,
                                                           input piProcessTemplateId as int64).
                                                           
    method public DataSlotTemplate extent GetProcessTemplateDataSlots(input pcSessionId as longchar,
                                                                      input pcProcessTemplateName as character).
            
    method public DataSlotTemplate extent GetProcessTemplateDataSlot(input pcSessionId as longchar,            
                                                                     input pcProcessTemplateName as character,
                                                                     input pcDataslotName as character extent).
            
    method public DataSlotInstance extent GetProcessInstanceDataSlots(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
            
    method public DataSlotInstance extent GetProcessInstanceDataSlot(input pcSessionId as longchar,
                                                                     input pcProcessInstanceName as character,
                                                                     input pcDataslotName as character extent).
            
    method public DataSlotInstance extent GetProcessInstanceDataSlotFromPiid(input pcSessionId as longchar,
                                                                             input piProcessInstanceId as int64,
                                                                             input pcDataslotName as character extent).
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input pcSessionId as longchar,
                                                                       input pcProcessInstanceName as character,
                                                                       input pcWorkstepInstanceName as character).
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlotsFromPiid(input pcSessionId as longchar,
                                                                               input piProcessInstanceId as int64,
                                                                               input pcWorkstepInstanceName as character).
                                                                               
    method public DataSlotInstance extent GetWorkItemDataSlots(input pcSessionId as longchar,
                                                               input pcWorkItemName as character).
            
    method public DataSlotInstance extent GetWorkItemDataSlotsFromWiid(input pcSessionId as longchar,
                                                                       input piWorkstepInstanceId as int64).
                                                                       
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input pcSessionId as longchar,
                                                                       input pcProcessTemplateName as character,
                                                                       input pcWorkStepName as character).
    
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlotsFromPtid(input pcSessionId as longchar,
                                                                               input piProcessTemplateId as int64,
                                                                               input pcWorkStepName as character).
                                                                               
    method public void SetProcessTemplateDataSlotValue(input pcSessionId as longchar,
                                                       input pcProcessTemplateName as character,
                                                       input poDataSlotTemplate as DataSlotTemplate).
                                                       
    method public void SetProcessTemplateDataSlotsValue(input pcSessionId as longchar,
                                                        input pcProcessTemplateName as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).
                                                        
    method public void SetProcessInstanceDataSlotValue(input pcSessionId as longchar,
                                                       input pcProcessInstanceName as character,
                                                       input poDataSlotInstance as DataSlotInstance).
                                                       
    method public void SetProcessInstanceDataSlotsValue(input pcSessionId as longchar,
                                                        input pcProcessInstanceName as character,
                                                        input poDataSlotInstance as DataSlotInstance extent).
            
    method public void SetWorkItemDataSlotsValue(input pcSessionId as longchar,
                                                 input pcWorkItemName as character,
                                                 input poDataSlotInstance as DataSlotInstance extent).
                                                 
    method public void SetWorkItemDataSlotValue(input pcSessionId as longchar,
                                                input pcWorkItemName as character,
                                                input poDataSlotInstance as DataSlotInstance).
            
    method public ProcessInstance GetProcessInstanceFromID(input pcSessionId as longchar,
                                                           input piProcessInstanceId as int64). 
            
    method public void SetProcessInstanceDueDate(input pcSessionId as longchar,
                                                 input pcProcessInstanceName as character,
                                                 input ptDueDate as datetime-tz).
                                                 
    method public WorkItem GetWorkItemFromID(input pcSessionId as longchar,
                                             input piWorkItemInstanceId as int64).
            
    method public void SuspendWorkItem(input pcSessionId as longchar,
                                       input pcWorkItemName as character).
                
    method public void ResumeWorkItem(input pcSessionId as longchar,
                                      input pcWorkItemName as character).
    
    method public void AssignWorkItemFromWiid(input pcSessionId as longchar,
                                              input piWorkItemInstanceId as int64,
                                              input pcPerformer as character).
    
    method public void ReassignWorkItem(input pcSessionId as longchar,
                                        input pcWorkItemName as character,
                                        input pcPerformer as character).
                                        
    method public void ReassignWorkItemFromWiid(input pcSessionId as longchar,
                                                input piWorkItemInstanceId as int64,
                                                input pcPerformer as character).
                                                
    method public void MakeAvailableWorkItem(input pcSessionId as longchar,
                                             input pcWorkItemName as character,
                                             input pcPerformers as character extent).
                                             
    method public void MakeAvailableWorkItemFromWiid(input pcSessionId as longchar,        
                                                     input piWorkItemInstanceId as int64,
                                                     input pcPerformers as character extent).
                                                     
    method public void CompleteWorkItemFromWiid(input pcSessionId as longchar,
                                                input piWorkItemInstanceId as int64,
                                                input poDataSlotInstance as DataSlotInstance extent).
    
    method public WorkStepInstance GetWorkStepInstanceFromPiid(input pcSessionId as longchar,
                                                               input piProcessInstanceId as int64,
                                                               input pcWorkStepName as character).
                                                               
    method public WorkStepInstance extent GetProcessInstanceWorkSteps(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
    
    method public void SuspendWorkStepInstance(input pcSessionId as longchar,
                                               input pcProcessInstanceName as character,
                                               input pcWorkStepName as character).
    
    method public void ResumeWorkStepInstance(input pcSessionId as longchar,
                                              input pcProcessInstanceName as character,
                                              input pcWorkStepName as character).
    
    method public WorkSteptemplate extent GetStartWorkStepTemplate(input pcSessionId as longchar,
                                                                   input pcProcessTemplateName as character).
    
end interface.