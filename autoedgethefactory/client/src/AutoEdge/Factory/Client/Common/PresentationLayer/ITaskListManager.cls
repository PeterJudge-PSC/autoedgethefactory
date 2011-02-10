/* ------------------------------------------------------------------------
    File        : ITaskListManager
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 24 11:57:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
  
using AutoEdge.Factory.Client.Common.EnterpriseServices.CurrentTask.
using OpenEdge.EnterpriseServices.BizLogic.IBizLogicServerParameters.

interface AutoEdge.Factory.Client.Common.PresentationLayer.ITaskListManager:
        
    define public property SessionId as longchar no-undo get.

    method public void ServerConnect(input poParameters as IBizLogicServerParameters).

    method public void ServerDisconnect().
    
    method public void TaskCompleted(input piTaskId as int64).  
  
    method public void CompleteTask(input poTask as CurrentTask).
    
    method public void ReassignTask(input poTask as CurrentTask, input pcPerformer as character).
    
    method public void SetTaskDataSlots(input poTask as CurrentTask).
    
end interface.