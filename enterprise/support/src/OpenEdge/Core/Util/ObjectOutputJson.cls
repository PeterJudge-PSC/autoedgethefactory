/** ------------------------------------------------------------------------
    File        : ObjectOutputJson
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 16 09:41:29 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.ObjectOutputError.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.

using Progress.Lang.ParameterList.
using Progress.Lang.Object.

class OpenEdge.Core.Util.ObjectOutputJson implements IObjectOutput: 
    
    define private variable moTopLevel            as Object            no-undo.
    define private variable moTypeStack           as ObjectStack       no-undo.
    
    define private variable moWriteObjParam       as ParameterList     no-undo.
    define private variable moObjectOutputError   as ObjectOutputError no-undo.
    define private variable mlStreamHeaderWritten as logical           no-undo.
		
    define private temp-table StreamReference no-undo
        field ReferenceType as integer  /* ObjectStreamConstants:REFTYPE_ */
        field Reference     as integer      /* object id for PLO or PLC */
        field Position      as integer       /* */
        index idx1 as primary unique ReferenceType Reference
        .

    constructor public ObjectOutputJson():
        Initialize().
    end constructor.
    
    destructor public ObjectOutputJson():
        this-object:Clear().
    end destructor.
    
    method protected void Clear():
        define buffer lbRef for StreamReference.
            
        empty temp-table lbRef.
        moTopLevel = ?.
        moWriteObjParam = ?.
        moObjectOutputError = ?.
        mlStreamHeaderWritten = false.
    end method.
    
    /** Resets/reinitialises the output */
    method public void Reset():
        this-object:Clear().
        Initialize().
    end method.
    
    method protected void Initialize():
        /* Create on parameter list object that
           we'll reuse. */
        moWriteObjParam = new ParameterList(1).
        moWriteObjParam:SetParameter(1,
            substitute(DataTypeEnum:Class:ToString(), this-object:GetClass():TypeName),
            IOModeEnum:Input:ToString(),
            this-object).
    end method.
    
    method protected void WriteStreamHeader():
        /*
        WriteString(ObjectStreamConstants:STREAM_MAGIC).
        WriteByte(ObjectStreamConstants:STREAM_VERSION).
        
        /* This is invariant for this object, so write it in the
           header instead of for each decimal. Note that we write 
           dates in broken-down pieces, so don't need to keep formats
           for them. */
        WriteByte(asc(session:numeric-decimal-point)).
        WriteByte(asc(session:numeric-separator)).
        
        /* What version are we running? */
        WriteString(proversion).
           */
        
        mlStreamHeaderWritten = true.
    end method.	

	method public void Write( input pcFileName as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void Write( output pmStream as memptr ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void Write( output pcStream as longchar ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteChar( input pcValue as character ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteCharArray( input pcValue as character extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDataset( input phValue as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDate( input ptValue as date ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDateArray( input ptValue as date extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDateTime( input ptValue as datetime ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDateTimeArray( input ptValue as datetime extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDateTimeTz( input ptValue as datetime-tz ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDateTimeTzArray( input ptValue as datetime-tz extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDecimal( input pdValue as decimal ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteDecimalArray( input pdValue as decimal extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteEnum( input poMember as EnumMember ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteHandle( input phValue as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteHandleArray( input phValue as handle extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteInt( input piValue as integer ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteInt64( input piValue as int64 ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteInt64Array( input piValue as int64 extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteIntArray( input piValue as integer extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteLogical( input plValue as logical ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteLogicalArray( input plValue as logical extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteLongchar( input pcValue as longchar ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteLongcharArray( input pcValue as longchar extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteObject( input poValue as Progress.Lang.Object ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteObjectArray( input poValue as Progress.Lang.Object extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteRecid( input prValue as recid ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteRecidArray( input prValue as recid extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteRowid( input prValue as rowid ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteRowidArray( input prValue as rowid extent ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

	method public void WriteTable( input phValue as handle ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

end class.