/** ------------------------------------------------------------------------
    File        : IServiceMessage
    Purpose     : Service message (request-response) passed through OERA layers 
    Syntax      : 
    Description : Base interface for service message (parameter) classes. 
                  Defines properties needed to identify the message in all 
                  OERA layers
    @author hdaniels
    Created     : Tue Feb 09 03:12:07 EST 2010
    Notes       : * Specialised in name by IServiceRequest and -Response, although
                    those interfaces are empty (they exist only as a means to identify
                    the type of message to the compiler and programmer). 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage:
    
    /** Unique message identifier. Allows for completely decoupled request and response
        messages to be tied back together.  */
    define public property MessageId as character no-undo get.
    
    /** Type of request (MessageTypeEnum). 
        All IServiceMessage instances that are issued together must be of the same type,
        and the same type as their bundle. */ 
    define property ActionType as ServiceMessageActionEnum no-undo get.
    
    /** Identifies the service message target.
        Used to find the ServiceAdapter and BE */
    define property Service as character no-undo get.
    
end interface.