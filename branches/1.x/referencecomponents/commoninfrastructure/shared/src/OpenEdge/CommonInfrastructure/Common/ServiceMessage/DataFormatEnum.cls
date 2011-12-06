@todo(task="refactor", action="move to OE.Core.System?").
/** ------------------------------------------------------------------------
    File        : DataFormatEnum
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

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.DataFormatEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.Common.ServiceMessage.DataFormatEnum inherits EnumMember:
    
    /** Indicates that the data is transported in an ABL ProDataSet. */
    define static public property ProDataSet as DataFormatEnum no-undo get. private set.
    
    /** Indicates that the data is transported in an ABL temp-table/buffer. */
    define static public property TempTable as DataFormatEnum no-undo get. private set.
    
    /** Indicates that the data is transported in an XML document.  */
    define static public property XmlDocument as DataFormatEnum  no-undo get. private set.
    
    /** Indicates that the data is transported as JSON. */
    define static public property JSON as DataFormatEnum  no-undo get. private set.

    /** Indicates that the data is transported in some other format (not defined here). */
    define static public property Other as DataFormatEnum  no-undo get. private set.
    
    /** Indicates that no data is transported for this message. */
    define static public property None as DataFormatEnum  no-undo get. private set.
    
    constructor static DataFormatEnum():
        DataFormatEnum:ProDataSet = new DataFormatEnum('ProDataSet').
        DataFormatEnum:TempTable = new DataFormatEnum('TempTable').
        DataFormatEnum:XmlDocument = new DataFormatEnum('XmlDocument').
        DataFormatEnum:JSON = new DataFormatEnum('JSON').
        DataFormatEnum:Other = new DataFormatEnum('Other').
        DataFormatEnum:None = new DataFormatEnum('None').
    end constructor.
    
    constructor public DataFormatEnum(input pcName as character):
        super (input pcName).
    end constructor.
        
end class.