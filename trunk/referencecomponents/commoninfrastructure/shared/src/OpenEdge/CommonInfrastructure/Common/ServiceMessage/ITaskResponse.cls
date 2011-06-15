/** ------------------------------------------------------------------------
    File        : ITaskResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 10:54:39 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.Collections.ICollection.  

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse:
    
    /** A collection of IServiceResponse objects for the task */ 
    define public property ServiceResponses as ICollection no-undo get.
    
end interface.