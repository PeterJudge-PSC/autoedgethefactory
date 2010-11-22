/** ------------------------------------------------------------------------
    File        : IExternalizable
    Purpose     : Interface for Externalisable objects.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 25 12:42:41 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

interface OpenEdge.Core.Util.IExternalizable:   /* inherits ISerializable */

    /** Serialization method for an object.
    
        @param ObjectOutputStream The stream object that's performing the serialization */   
    method public void WriteObject(input poStream as ObjectOutputStream).
    
    /** Deserialization method for an object.
        
        @param ObjectInputStream The stream object that's performing the deserialization */
    method public void ReadObject(input poStream as ObjectInputStream).
    
end interface.