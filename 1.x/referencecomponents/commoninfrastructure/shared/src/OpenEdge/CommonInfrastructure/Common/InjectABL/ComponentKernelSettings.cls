/** ------------------------------------------------------------------------
    File        : ComponentKernelSettings
    Purpose     : Flags/settings for the InjectABL ComponentKernel 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jun 01 16:20:42 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.KernelSettings.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentKernelSettings inherits KernelSettings:
    
    define public property AutoStartComponents as logical no-undo get. set.
    define public property AutoStartServices   as logical no-undo get. set.
    define public property AutoStartManagers   as logical no-undo get. set.
    
    constructor public ComponentKernelSettings():
		super ().
		
		AutoStartComponents = true.
		AutoStartServices = true.
		AutoStartManagers = true.
	end constructor.

end class.