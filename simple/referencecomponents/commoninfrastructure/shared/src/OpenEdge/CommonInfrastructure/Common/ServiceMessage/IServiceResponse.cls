/** ------------------------------------------------------------------------
    File        : IServiceResponse
    Purpose     : General interface for a service message response to a request
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jun 08 10:00:22 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse inherits IServiceMessage:
    
    /** Was there an error on the request? */
    define public property HasError as logical no-undo get. set.
    
    /** If an error occurred, some text related to the error. Could
       be some meaningful or structured text. Could be a serialized
       Progress.Lang.Error object. */
    define public property ErrorText as longchar no-undo get. set.
    
end interface.