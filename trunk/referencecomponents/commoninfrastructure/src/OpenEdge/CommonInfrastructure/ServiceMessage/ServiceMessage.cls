/** ------------------------------------------------------------------------
    File        : ServiceMessage
    Purpose     : A message which may be the request or response portion of a data
                  fetch, save, define or other message. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 16:46:22 EDT 2010
    Notes       : * This message class is abstract because we want to highlight
                    the separation of request and response.
  --------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.MessageDataFormatEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage abstract
        implements IServiceMessage:
    
    define private variable mhDatastore as handle   no-undo.
    define private variable mmDatastore as memptr   no-undo.
    define private variable mcDatastore as longchar no-undo.
    define private variable moDatastore as Object   no-undo.
    
    /** Unique message identifier. Allows for completely decoupled request and response
        messages to be tied back together. This will probably be a GUID. */
    define public property MessageId as character no-undo get. private set.
    
    /** Type of request (ServiceMessageActionEnum). The defaults are Fetch,Save,Define but
        may be overridden (by FetchByRegion or something similar). 
        
        All IServiceMessage instances that are issued together must be of the same type,
        and the same type as their bundle. */ 
    define public property ActionType as ServiceMessageActionEnum no-undo get. private set.
    
    /** Identifies the service message target.
        Used to find the ServiceAdapter and Business component */
    define public property Service as character no-undo get. private set.
    
    /** The data transport type for this message. These may differ for request and response. */
    define public property MessageDataFormat as MessageDataFormatEnum no-undo get. private set.
    
    define private variable moMessageDataType as DataTypeEnum no-undo.
    
    /** This constructor will typically only be used for Requests, not responses,
        since the response needs a MessageId for ithe request that triggered it.
        
        @param pcService The service name for which this message is being incokved.
        @param poMessageType Uses the ServiceMessageActionEnum to define the action of the message. */
    constructor public ServiceMessage(input pcService as character,
                                      input poMessageType as ServiceMessageActionEnum):
        this-object(guid(generate-uuid), pcService, poMessageType). 
    end constructor.
    
    /*  General constructor for requests and responses. 
        
        @param pcMessageId 
        @param pcService The service name for which this message is being invoked.
        @param poMessageType Uses the ServiceMessageActionEnum to define the action of the message.  */    
    constructor public ServiceMessage(input pcMessageId as character,
                                      input pcService as character,
                                      input poActionType as ServiceMessageActionEnum):
        Assert:ArgumentNotNullOrEmpty(pcMessageId, 'Message Id').
        Assert:ArgumentNotNullOrEmpty(pcService, 'Service').
        Assert:ArgumentNotNull(poActionType, 'Action type').
        
        assign MessageId = pcMessageId
               ActionType = poActionType
               Service = pcService.
    end constructor.
    
    destructor ServiceMessage():
        /* clean out the memptr in case there's anything in it, 
           to prevent memory leaks. */
        set-size(mmDatastore) = 0.
    end destructor.
    
    method override public logical Equals(p0 as Object):
        define variable lEqual as logical no-undo.
        
        lEqual = super:Equals(p0).
        
        if not lEqual then
          lEqual = type-of(p0, IServiceMessage) and
                   this-object:MessageId eq cast(p0, IServiceMessage):MessageId. 
        
        return lEqual.
    end method.

    /** The GetData() and SetData() methods allow access to the data being sent/
        received by this message. This data is formatted per the MessageDataFormat above;
        and is stored in the message as either LONGCHAR, MEMPTR, HANDLE or P.L.O.       */
    method public void GetData(output pcData as longchar):
        if not MessageDataFormat eq MessageDataFormatEnum:None then
            pcData = mcDatastore.
    end method.
    
    method public void SetData (input pcData as longchar,
                                input poMessageDataFormat as MessageDataFormatEnum):
        assign MessageDataFormat = poMessageDataFormat
               moMessageDataType = DataTypeEnum:LongChar
               mcDatastore = pcData.
    end method.

    method public void GetData(output pmData as memptr):
        if not MessageDataFormat eq MessageDataFormatEnum:None then
            pmData = mmDatastore.
    end method.
    
    method public void SetData(input pmData as memptr,
                               input poMessageDataFormat as MessageDataFormatEnum):
        assign MessageDataFormat = poMessageDataFormat
               moMessageDataType = DataTypeEnum:Memptr
               mmDatastore = pmData.
    end method.
    
    method public void GetData(output phData as handle):
        if not MessageDataFormat eq MessageDataFormatEnum:None then
            phData = mhDatastore.
    end method.
    
    method public void SetData(input phData as handle,
                               input poMessageDataFormat as MessageDataFormatEnum):
        assign MessageDataFormat = poMessageDataFormat
               moMessageDataType = DataTypeEnum:Handle
               mhDatastore = phData.
    end method.

    method public void GetData(output poData as Object):
        if not MessageDataFormat eq MessageDataFormatEnum:None then
            poData = moDatastore.
    end method.
    
    method public void SetData(input poData as Object,
                               input poMessageDataFormat as MessageDataFormatEnum):
        assign MessageDataFormat = poMessageDataFormat
               moMessageDataType = DataTypeEnum:ProgressLangObject
               moDatastore = poData.
    end method.
    
end class.