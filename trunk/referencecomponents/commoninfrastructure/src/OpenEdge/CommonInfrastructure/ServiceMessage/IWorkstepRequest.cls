/** ------------------------------------------------------------------------
    File        : IWorkstepRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 01 19:04:58 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
interface OpenEdge.CommonInfrastructure.ServiceMessage.IWorkstepRequest:
    
    /** (optional) The workstep name. */
    define public property Name as longchar no-undo get. set.
    
end interface.