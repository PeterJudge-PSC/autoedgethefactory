/** ------------------------------------------------------------------------
    File        : TaskParameter
    Purpose     : Parameter object used to pass parameters into Business Tasks 
                  from a service message and/or service interface
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jun 22 09:21:56 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.String.
using Progress.Lang.Object.

class OpenEdge.BusinessComponent.Task.TaskParameter
        implements IExternalizable:
    /** (mandatory) Parameter name */
    define public property Name as character no-undo get. private set.

    /** (mandatory) Parameter Value.
        Value can be refactored into individual abl primitives, and so remove the
        need for DataType */
    define public property Value as String no-undo get. set.
    
    define public property DataType as DataTypeEnum no-undo get. set.
    define public property IOMode as IOModeEnum no-undo get. set.

	constructor public TaskParameter():
	    /* Default constructor for serialization only */
		super ().
	end constructor.
	
	constructor public TaskParameter(input pcName as character):
        this-object(pcName, String:Empty(), DataTypeEnum:Character, IOModeEnum:Default).
    end constructor.

    constructor public TaskParameter(input pcName as character,
                                     input poValue as String,
                                     input poDataType as DataTypeEnum,
                                     input poIOMode as IOModeEnum):
        super().
        
        assign this-object:Name = pcName
               this-object:Value = poValue
               this-object:DataType = poDataType
               this-object:IOMode = poIOMode.
    end constructor.
	
	method public void WriteObject( input poStream as IObjectOutput):
	    poStream:WriteChar(this-object:Name).
	    poStream:WriteObject(this-object:Value).
	    poStream:WriteEnum(DataType).
	    poStream:WriteEnum(IOMode).
	end method.
	
	method public void ReadObject( input poStream as IObjectInput):
        this-object:Name = poStream:ReadChar().
        this-object:Value = cast(poStream:ReadObject(), String).
        DataType = cast(poStream:ReadEnum(), DataTypeEnum).
        IOMode = cast(poStream:ReadEnum(), IOModeEnum).
	end method.	

end class.