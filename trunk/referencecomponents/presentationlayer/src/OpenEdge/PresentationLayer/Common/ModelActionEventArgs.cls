/** ------------------------------------------------------------------------
    File        : ModelActionEventArgs
    Purpose     : Event arguments for actions on a model
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 14 10:53:05 EDT 2009
    Notes       : * The action performed is defined by ModelActionEnum  
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.Core.System.EventArgs. 
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.ModelActionEventArgs inherits EventArgs:
    /** (mandatory) Indeifiying information of the model on which the action was performed */
    define public property ModelService as IComponentInfo no-undo get. private set.
        
    /** (mandatory) The action performed on the model */
    define public property ModelAction as ModelActionEnum no-undo get. private set.
    
    /** (optional) An array of tables being operated on */
    define public property TableName as character extent no-undo get. set.
    
    /** (optional) Row keys sufficient to identify a single row in the tables. */
    define public property RowKey as character extent no-undo get. set.
    
    /** (optional) An array of query names affected by or  
    define public property QueryName as character extent no-undo get. set.
    */
    
    /** (optional) The unique identifier for the service request that results in this message */
    define public property ServiceMessageId as longchar no-undo get. set.
    
    /* default ctor */
    constructor public ModelActionEventArgs (input poModelService as IComponentInfo,
                                             input poModelAction as ModelActionEnum):
        super().
        
        assign ModelService = poModelService
               ModelAction = poModelAction.
    end constructor.
    
    /* some operation on one or more tables with the specified keys (local) */
    constructor public ModelActionEventArgs (input poModelService as IComponentInfo,
                                             input poModelAction as ModelActionEnum,
                                             input pcTable as character extent,
                                             input pcKey as character extent  ):
        this-object(poModelService, poModelAction).
        assign TableName = pcTable
               RowKey = pcKey.
    end constructor.

    /* some operation on one table with the specified key (local). */
    constructor public ModelActionEventArgs (input poModelService as IComponentInfo,
                                             input poModelAction as ModelActionEnum,
                                             input pcTable as character,
                                             input pcKey as character):
        define variable cArray as character extent 1 no-undo.
                                                         
        this-object(poModelService, poModelAction).
        
        assign cArray[1] = pcTable
               TableName = cArray
               cArray[1] = pcKey
               RowKey    = cArray.
    end constructor.
        
    /* A remote/service operation on one or more tables done via a particular message. */
    constructor public ModelActionEventArgs (input poModelService as IComponentInfo,
                                             input poModelAction as ModelActionEnum,
                                             input pcTables as character extent,
                                             input pcMessageId as longchar):
        this-object(poModelService, poModelAction).
        
        assign ServiceMessageId = pcMessageId
               TableName = pcTables.
    end constructor.
    
end class.
