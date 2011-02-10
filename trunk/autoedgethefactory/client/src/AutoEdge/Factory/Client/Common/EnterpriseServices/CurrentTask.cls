/*------------------------------------------------------------------------
    File        : CurrentTask
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jul 14 10:34:40 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.EnterpriseServices.BizLogic.WorkItem.
using OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap. 
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class AutoEdge.Factory.Client.Common.EnterpriseServices.CurrentTask:
    define public property WorkItem as WorkItem no-undo get. private set.
    
    define public property DataSlots as IMap no-undo
        get():
            if not valid-object(DataSlots) then
                DataSlots = new TypedMap(
                                    String:Type,
                                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
            return DataSlots.
        end get.
        private set.
     
    constructor public CurrentTask(input poWorkItem as WorkItem,
                                   input poDataSlots as DataSlotInstance extent):
        super().
        
        this-object:WorkItem = poWorkItem.
        AddDataSlots(poDataSlots).
    end constructor.

    constructor public CurrentTask(poWorkItem as WorkItem):
        define variable oDummy as DataSlotInstance extent no-undo.
        
        this-object(poWorkItem, oDummy).
    end constructor.
    
    method public void AddDataSlots(input poDataSlots as DataSlotInstance extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        iMax = extent(poDataSlots).
        do iLoop = 1 to iMax:
            DataSlots:Put(new String(poDataSlots[iLoop]:Name), poDataSlots[iLoop]). 
        end.
    end method.
    
end class.