/** ------------------------------------------------------------------------
    File        : MessageDataFormatEnum
    Purpose     : Describes how the service message stores the data it's moving
                  back and forth.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 20:17:13 EDT 2010
    Notes       : * The reference component default is to use a ProDataSet
                  * Note that this is independent of how the data is stored
                  in the message (handle or memptr or longchar). 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.MessageDataFormatEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ServiceMessage.MessageDataFormatEnum inherits EnumMember:
    
    /** Indicates that the data is transported in an ABL ProDataSet. */
    define static public property ProDataSet as MessageDataFormatEnum no-undo get. private set.

    /** Indicates that the data is transported in an ABL temp-table/buffer. */
    define static public property TempTable as MessageDataFormatEnum no-undo get. private set.
    
    /** Indicates that the data is transported in an XML document.  */
    define static public property XmlDocument as MessageDataFormatEnum  no-undo get. private set.
    
    /** Indicates that the data is transported as JSON. */
    define static public property JSON as MessageDataFormatEnum  no-undo get. private set.
    
    /** Indicates that the data is transported in some other format (not defined here). */
    define static public property Other as MessageDataFormatEnum  no-undo get. private set.

    /** Indicates that no data is transported for this message. */
    define static public property None as MessageDataFormatEnum  no-undo get. private set.
    
    constructor static MessageDataFormatEnum():
        MessageDataFormatEnum:ProDataSet = new MessageDataFormatEnum('ProDataSet').
        MessageDataFormatEnum:TempTable = new MessageDataFormatEnum('TempTable').
        MessageDataFormatEnum:XmlDocument = new MessageDataFormatEnum('XmlDocument').
        MessageDataFormatEnum:JSON = new MessageDataFormatEnum('JSON').
        MessageDataFormatEnum:Other = new MessageDataFormatEnum('Other').
        MessageDataFormatEnum:None = new MessageDataFormatEnum('None').
    end constructor.
    
	constructor public MessageDataFormatEnum(input pcName as character):
		super (input pcName).
	end constructor.
	    
end class.