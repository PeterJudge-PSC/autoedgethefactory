/* ------------------------------------------------------------------------
    File        : IWorkstepResponse
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 19:05:30 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.IWorkstepResponse inherits IServiceResponse:    
    /** (optional) The workstep name. */
    define public property Name as longchar no-undo get. set.
    
    /** (optional) A status text for the workstep */
    define public property Status as longchar no-undo get. set.  
    
end interface.