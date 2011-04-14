/*------------------------------------------------------------------------
    File        : ObjectOutputStream
    Purpose     : Serializes an object as a byte stream
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Nov 13 14:22:25 EST 2009
    Notes       : * IExternalizable types don't write out metadata
                 * For the protocol definition, see http://communities.progress.com/pcom/docs/DOC-105142
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.Util.ObjectOutput.

using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.System.ObjectStreamConstants.
using OpenEdge.Core.System.ObjectOutputError.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.Collections.ObjectStack.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.IOModeEnum.
using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.EnumMember.

using Progress.Lang.ParameterList.
using Progress.Lang.Error.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.Util.ObjectOutputStream inherits ObjectOutput:
    
    define private variable miCursor              as integer           no-undo.
    define private variable mrStreamBuffer        as raw               no-undo.
    
    constructor public ObjectOutputStream():
        super().
    end constructor.
    
    method override protected void Clear():
        super:Clear().
        
        assign length(mrStreamBuffer) = 0
               mrStreamBuffer = ?
               miCursor = 0.
    end method.
    
    method override protected void Initialize():
        super:Initialize().
        
        miCursor = 1.
    end method.
    
    /**  Writes the serialized output to the specified file 
         
         @param character The name of a file to write the output into. */    
    method override public void Write(pcFileName as char):
        define variable mStream as memptr no-undo.

        this-object:Write(output mStream).
        copy-lob mStream to file pcFileName.
        
        finally:
            set-size(mStream) = 0.
        /* this-object:Clear called from Write(memptr) */
        end finally.
    end method.
    
    /**  Writes the serialized output to a memptr
         
         @param memptr The memprt into which to write the output. */    
    method override public void Write(output pmStream as memptr):
        set-byte-order(pmStream) = ByteOrderEnum:BigEndian:Value.
        set-size(pmStream) = miCursor.
        put-bytes(pmStream, 1) = mrStreamBuffer.
        
        /* make sure we clear the memptr*/
        finally:
            this-object:Clear().
        end finally.
    end method.
    
    /** write the ABL data types **/
    method override protected logical WriteDetailTypeDetails(input poIn as Object):
        define variable lWriteTypeDetails as logical no-undo.
        define variable iRefPosition     as integer no-undo.
        define variable iMetadataBytePos as integer no-undo.
        
        lWriteTypeDetails = super:WriteDetailTypeDetails(poIn).
        
        if not lWriteTypeDetails then
            assign /* iMetadataBytePos is where the TC_OBJECT byte for the 
                      class will be (ie the previous position at the TC_OBJECT byte) */
                iMetadataBytePos = miCursor - ObjectStreamConstants:SIZE_BYTE
                iRefPosition     = AddReference(ObjectStreamConstants:REFTYPE_OBJECT,
                                        int(poIn),  /* object reference ('handle'), as key value */
                                        iMetadataBytePos)
                lWriteTypeDetails    = iRefPosition eq iMetadataBytePos.
        
        return lWriteTypeDetails.                    
    end method.
    
    /* Protected Write*() methods below do the actual writes to the stream. */
    method override protected void WriteStreamMarker(piIn as int):
        put-byte(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_BYTE.
    end method.
    
    method override protected void WriteShort(piIn as int):
        put-short(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_SHORT.
    end method.
    
    method override protected void WriteLong(piIn as int):
        put-long(mrStreamBuffer, miCursor) = piIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_LONG.
    end method.
    
    method override protected void WriteDouble(pdIn as dec):
        put-double(mrStreamBuffer, miCursor) = pdIn.
        miCursor = miCursor + ObjectStreamConstants:SIZE_DOUBLE.
    end method.
    
    method override protected void WriteString(pcVal as longchar):
        define variable iLength as integer no-undo.
        define variable iMarker as integer no-undo.
        
        if pcVal eq ? then
            WriteStreamMarker(ObjectStreamConstants:TC_NULL).
        else
        do:
            iLength = length(pcVal, CompareStrengthEnum:Raw:ToString()).
            
            WriteStreamMarker(ObjectStreamConstants:TC_VALUE).
            WriteLong(iLength).
            put-string(mrStreamBuffer, miCursor) = pcVal.
            miCursor = miCursor + iLength.
        end.
    end method.

    method override protected void WriteRaw(prVal as raw):
        define variable iLength as integer no-undo.
        define variable iMarker as integer no-undo.
        
        if prVal eq ? then
            WriteStreamMarker(ObjectStreamConstants:TC_NULL).
        else
        do:
            iLength = length(prVal, CompareStrengthEnum:Raw:ToString()).
            
            WriteStreamMarker(ObjectStreamConstants:TC_VALUE).
            WriteLong(iLength).
            put-bytes(mrStreamBuffer, miCursor) = prVal.
            miCursor = miCursor + iLength.
        end.
    end method.    
    
end class.