/*------------------------------------------------------------------------
    File        : CurrentTask
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 14 10:34:40 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.EnterpriseServices.BizLogic.WorkItem.
using OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance. 

class AutoEdge.Factory.Order.PresentationLayer.CurrentTask:
    define public property WorkItem as WorkItem no-undo get. private set.
    define public property DataSlots as DataSlotInstance extent no-undo get. set.
     
    constructor public CurrentTask(poWorkItem as WorkItem,
                                   poDataSlots as DataSlotInstance extent):
        super().
        assign this-object:WorkItem = poWorkItem
               this-object:DataSlots = poDataSlots.
    end constructor.

    constructor public CurrentTask(poWorkItem as WorkItem):
        define variable oDummy as DataSlotInstance extent no-undo.
        
        this-object(poWorkItem, oDummy).
    end constructor.
    
end class.