@todo(task="This is identical to ModelEventArgs").
/*------------------------------------------------------------------------
    File        : UpdatePanelEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 09 10:05:46 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.PresentationLayer.Common.ModelActionEnum .
using OpenEdge.PresentationLayer.Common.ModelActionEventArgs.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using Progress.Lang.Class.


class OpenEdge.PresentationLayer.Common.UpdatePanelEventArgs inherits ModelActionEventArgs: 

    constructor public UpdatePanelEventArgs ( input poModelService as IComponentInfo, input poModelAction as ModelActionEnum ):
        super (input poModelService, input poModelAction).
        
    end constructor.

        
    constructor public UpdatePanelEventArgs ( input poModelService as IComponentInfo, input poModelAction as ModelActionEnum, input pcTable as character extent, input pcKey as character extent ):
        super (input poModelService, input poModelAction, input pcTable, input pcKey).
        
    end constructor.

        
    constructor public UpdatePanelEventArgs ( input poModelService as IComponentInfo, input poModelAction as ModelActionEnum, input pcTable as character, input pcKey as character ):
        super (input poModelService, input poModelAction, input pcTable, input pcKey).
        
    end constructor.

        
    constructor public UpdatePanelEventArgs ( input poModelService as IComponentInfo, input poModelAction as ModelActionEnum, input pcTables as character extent, input pcMessageId as character ):
        super (input poModelService, input poModelAction, input pcTables, input pcMessageId).
        
    end constructor.


end class.