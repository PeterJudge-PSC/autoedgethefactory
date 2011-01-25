/** ------------------------------------------------------------------------
    File        : IExternalizable
    Purpose     : Interface for Externalisable objects.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 25 12:42:41 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Core.Util.IExternalizable.

interface OpenEdge.Core.Util.IExternalizable:   /* inherits ISerializable */

    /** Serialization method for an object.
        
        @param IObjectOutput The object that's performing the serialization */   
    method public void WriteObject(input poStream as IObjectOutput).
    
    /** Deserialization method for an object.
        
        @param IObjectInput The object that's performing the deserialization */
    method public void ReadObject(input poStream as IObjectInput).
    
end interface.