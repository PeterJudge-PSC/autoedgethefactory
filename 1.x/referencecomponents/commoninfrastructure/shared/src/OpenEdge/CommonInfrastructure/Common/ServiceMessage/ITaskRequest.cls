/** ------------------------------------------------------------------------
    File        : ITaskRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 10:42:37 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.Collections.ICollection.
  
interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest:
    
    /** A collection of IServiceRequest objects for the task */
    define public property ServiceRequests as ICollection no-undo get.
    
end interface.