/** ------------------------------------------------------------------------
    File        : DataContainerErrorEventArgs
    Purpose     : Event arguments for actions on a model
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 14 10:53:05 EDT 2009
    Notes       : * The action performed is defined by DataContainerActionEnum  
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.DataContainerActionEnum.
using OpenEdge.Core.DataContainer.IDataContainer.

using OpenEdge.Core.System.EventArgs. 
using Progress.Lang.Class.

class OpenEdge.Core.DataContainer.DataContainerActionEventArgs inherits EventArgs:
    
    /** (mandatory) Indeifiying information of the model on which the action was performed */
    define public property DataContainer as IDataContainer no-undo get. private set.
        
    /** (mandatory) The action performed on the model */
    define public property DataContainerAction as DataContainerActionEnum no-undo get. private set.
    
    /** (optional) An array of tables being operated on */
    define public property TableName as character extent no-undo get. set.
    
    /** (optional) Row keys sufficient to identify a single row in the tables. */
    define public property RowKey as character extent no-undo get. set.
    
    /** (optional) The unique identifier for the service request that results in this message */
    define public property ServiceMessageId as longchar no-undo get. set.
    
    /* default ctor */
    constructor public DataContainerActionEventArgs (input poDataContainer as IDataContainer,
                                                     input poDataContainerAction as DataContainerActionEnum):
        super().
        
        assign DataContainer = poDataContainer
               DataContainerAction = poDataContainerAction.
    end constructor.
    
    /* some operation on one or more tables with the specified keys (local) */
    constructor public DataContainerActionEventArgs (input poDataContainer as IDataContainer,
                                                     input poDataContainerAction as DataContainerActionEnum,
                                                     input pcTable as character extent,
                                                     input pcKey as character extent  ):
        this-object(poDataContainer, poDataContainerAction).
        assign TableName = pcTable
               RowKey = pcKey.
    end constructor.

    /* some operation on one table with the specified key (local). */
    constructor public DataContainerActionEventArgs (input poDataContainer as IDataContainer,
                                                     input poDataContainerAction as DataContainerActionEnum,
                                                     input pcTable as character,
                                                     input pcKey as character):
        define variable cArray as character extent 1 no-undo.
                                                         
        this-object(poDataContainer, poDataContainerAction).
        
        assign cArray[1] = pcTable
               TableName = cArray
               cArray[1] = pcKey
               RowKey    = cArray.
    end constructor.
        
    /* A remote/service operation on one or more tables done via a particular message. */
    constructor public DataContainerActionEventArgs (input poDataContainer as IDataContainer,            
                                                     input poDataContainerAction as DataContainerActionEnum,
                                                     input pcTables as character extent,
                                                     input pcMessageId as longchar):
        this-object(poDataContainer, poDataContainerAction).
        
        assign ServiceMessageId = pcMessageId
               TableName = pcTables.
    end constructor.
    
end class.
