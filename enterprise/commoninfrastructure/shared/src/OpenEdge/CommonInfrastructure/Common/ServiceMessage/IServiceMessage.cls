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
                  * The GetMessagaData() and SetMessageData() methods allow access to the data 
                    being sent/received by this message. This data is formatted per the 
                    MessageDataFormat and is stored in the message as either LONGCHAR, HANDLE or 
                    ISerializable object.
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.DataFormatEnum.
using OpenEdge.Core.Util.ISerializable.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Object.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage:
    
    /** Unique message identifier. Allows for completely decoupled 
        request and response messages to be tied back together. This will probably 
        be a GUID. */
    define public property MessageId as longchar no-undo get.
    
    /** Type of request (ServiceMessageActionEnum). The defaults are Fetch,Save,Define but
        may be overridden (by FetchByRegion or something similar). 
        
        All IServiceMessage instances that are issued together must be of the same type,
        and the same type as their bundle. */ 
    define public property ActionType as ServiceMessageActionEnum no-undo get.
    
    /** Identifies the service message target. 
        Used to find the ServiceAdapter and Business component */
    define public property Service as character no-undo get.
    
    /** Set the data associated with the message.         
        @param lonchar Stores a values 
        @param DataFormatEnum The format of the data target value */
    method public void SetMessageData(input pcData as longchar,
                                      input poMessageDataFormat as DataFormatEnum).
    
    /** Set the data associated with the message.         
        @param lonchar Stores a value */
    method public void SetMessageData (input pcData as longchar).
    
    /** Retrieve the message data.       
        @param output-longchar Message data, returned as a longchar. */
    method public void GetMessageData(output pcData as longchar).
    
    /** The message's data is transported as temp-table/prodataset and is referenced by handle.
        The type is inferred from the handle.
        
        @param handle The payload as a PDS or TT. */
    method public void SetMessageData(input phData as handle).
    
    /** The message's data is transported as temp-table/prodataset and is referenced by handle
        @param handle The payload as a PDS or TT.
        @param DataFormatEnum An explicit determination of the handle type. */    
    method public void SetMessageData(input phData as handle,
                                      input poMessageDataFormat as DataFormatEnum).
    
    /** Retrieve the message data.      
        @param output-longchar Message data, returned as a handle (prodataset/buffer) */    
    method public void GetMessageData(output phData as handle).
        
    /** The message's data is transported in object form and is referenced as such */
    method public void SetMessageData(input poData as ISerializable).
                               
    /** Retrieve the message data.       
        @param output-longchar Message data, returned as an Object. */
    method public void GetMessageData(output poData as ISerializable).
    
    /** Clear up the message data (SET-SIZE() on MEMPTR, DELETE DATASET, etc  */
    method public void Dispose().
    
end interface.
