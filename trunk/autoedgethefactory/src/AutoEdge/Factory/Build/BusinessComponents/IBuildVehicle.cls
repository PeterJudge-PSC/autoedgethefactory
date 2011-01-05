/** ------------------------------------------------------------------------
    File        : IBuildVehicle
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Jul 19 11:35:31 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
interface AutoEdge.Factory.Build.BusinessComponents.IBuildVehicle:
    
    /** (derived, readonly) The current status */
    define public property BuildStatus as character no-undo get.
    
    /** (mandatory) OrderId passed for this vehicle. */
    define public property OrderId as character no-undo get.
    
end interface.