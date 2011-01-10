/* ------------------------------------------------------------------------
    File        : ITaskListManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 24 11:57:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
  
using AutoEdge.Factory.Order.PresentationLayer.CurrentTask.
using OpenEdge.BusinessComponent.WorkFlow.BizLogic.DataSlotInstance.

interface AutoEdge.Factory.Order.PresentationLayer.ITaskListManager:
        
    define public property SessionId as character no-undo get.
    
    method public void ServerConnect(input pcUserName as character,
                                     input pcPassword as character,
                                     input pcServerURL as character).
    
    method public void ServerDisconnect().
    
    method public void TaskCompleted(piTaskId as int64).  
  
    method public void CompleteTask(poTask as CurrentTask).
    
    method public void ReassignTask(poTask as CurrentTask, pcPerformer as character).
    
    method public void SetTaskDataSlots (poTask as CurrentTask).
    
end interface.