@todo(task="question", action="interface? or just use concreate ServiceResponse?").
/** ------------------------------------------------------------------------
    File        : IServiceResponse
    Purpose     : General interface for a service message response to a request
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jun 08 10:00:22 EDT 2010
    Notes       : * This interface exists to provide signatures and to clarify
                    the type of ServiceMessage being used. It is specialised by
                    operation (fetch, save).
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

interface OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse /* inherits IServiceMessage */:
    
end interface.