/*------------------------------------------------------------------------
    File        : IExternalizable
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Nov 25 12:42:41 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.Util.*.

interface OpenEdge.Core.Util.IExternalizable:   /* inherits ISerializable */
    
    method public void WriteObject(po as ObjectOutputStream).
    method public void ReadObject(po as ObjectInputStream).
    
end interface.