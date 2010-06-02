/*------------------------------------------------------------------------
    File        : ServiceMessage
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 16:46:22 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.Core.System.ServiceMessageActionEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage
        implements IServiceMessage:
    
    /** Unique message identifier. Allows for completely decoupled request and response
        messages to be tied back together.  */
    define public property MessageId as character no-undo get. private set.
    define public property ActionType as ServiceMessageActionEnum no-undo get. private set.
    define public property Service as character no-undo get. private set.
        
    constructor public ServiceMessage(pcService as character,
                                      poMessageType as ServiceMessageActionEnum): 
        this-object(guid(generate-uuid), pcService, poMessageType). 
    end constructor.
    
    constructor public ServiceMessage(pcMessageId as character,
                                      pcService as character,
                                      poActionType as ServiceMessageActionEnum):
        
        Assert:ArgumentNotNullOrEmpty(pcMessageId, 'Message Id').
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        Assert:ArgumentNotNull(poActionType, 'Action type').
        
        assign MessageId = pcMessageId 
               ActionType = poActionType
               Service = pcService.
    end constructor.
    
    method override public logical Equals(p0 as Object):
        define variable lEqual as logical no-undo.
        
        lEqual = super:Equals(p0).
        
        if not lEqual then
          lEqual = type-of(p0, IServiceMessage) and
                   this-object:MessageId eq cast(p0, IServiceMessage):MessageId. 
        
        return lEqual.
    end method.
    
end class.