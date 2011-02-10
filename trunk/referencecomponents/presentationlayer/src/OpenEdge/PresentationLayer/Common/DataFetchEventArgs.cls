@deprecated.
/*------------------------------------------------------------------------
    File        : DataFetchEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Sep 01 17:11:58 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.PresentationLayer.Common.ModelActionEventArgs.
using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.DataFetchEventArgs inherits ModelActionEventArgs:
    define public property NewData as logical no-undo get. set.
        
    constructor public DataFetchEventArgs (poModelService as IComponentInfo, plNewData as log):
        super(poModelService, ModelActionEnum:Fetch).
        
        this-object:NewData = plNewData.
    end constructor.

        
    constructor public DataFetchEventArgs ( input poModelService as IComponentInfo):
        super (input poModelService, ModelActionEnum:Fetch).
    end constructor.

        
    constructor public DataFetchEventArgs ( input poModelService as IComponentInfo, input pcTable as character extent, input pcKey as character extent ):
        super (input poModelService, ModelActionEnum:Fetch, input pcTable, input pcKey).
        
    end constructor.

        
    constructor public DataFetchEventArgs ( input poModelService as IComponentInfo, input pcTable as character, input pcKey as character ):
        super (input poModelService, ModelActionEnum:Fetch, input pcTable, input pcKey).
        
    end constructor.

        
    constructor public DataFetchEventArgs ( input poModelService as IComponentInfo, input pcTables as character extent, input pcMessageId as character ):
        super (input poModelService, ModelActionEnum:Fetch, input pcTables, input pcMessageId).
    end constructor.
    
end class.