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
                  * All properties are mandatory. 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.MessageDataFormatEnum.
using Progress.Lang.Object.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage:
    
    /** Unique message identifier. Allows for completely decoupled request and response
        messages to be tied back together. This will probably be a GUID. */
    define public property MessageId as character no-undo get.
    
    /** Type of request (ServiceMessageActionEnum). The defaults are Fetch,Save,Define but
        may be overridden (by FetchByRegion or something similar). 
        
        All IServiceMessage instances that are issued together must be of the same type,
        and the same type as their bundle. */ 
    define public property ActionType as ServiceMessageActionEnum no-undo get.
    
    /** Identifies the service message target. 
        Used to find the ServiceAdapter and Business component */
    define public property Service as character no-undo get.
    
    /** (mandatory) The data transport type for this message. These may differ for request and response. */
    define public property MessageDataFormat as MessageDataFormatEnum no-undo get.
    
    /** The GetData() and SetData() methods allow access to the data being sent/
        received by this message. This data is formatted per the MessageDataFormat above;
        and is stored in the message as either LONGCHAR, MEMPTR, HANDLE or P.L.O. */
    method public void SetData(input pmData as longchar,
                               input poMessageDataFormat as MessageDataFormatEnum).
    method public void GetData(output pcData as longchar).
    
    method public void SetData(input pmData as memptr,
                               input poMessageDataFormat as MessageDataFormatEnum).
    method public void GetData(output pmData as memptr).
    
    method public void SetData(input phData as handle,
                               input poMessageDataFormat as MessageDataFormatEnum).
    method public void GetData(output phData as handle).

    method public void SetData(input poData as Object,
                               input poMessageDataFormat as MessageDataFormatEnum).
    method public void GetData(output poData as Object).
    
end interface.