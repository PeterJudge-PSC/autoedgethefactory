/** ------------------------------------------------------------------------
    File        : ServiceMessageModule
    Purpose     : Default  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jan 10 14:48:53 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.

routine-level on error undo, throw.

class OpenEdge.CommonInfrastructure.InjectABL.ServiceMessageModule inherits InjectionModule: 
		
	constructor public ServiceMessageModule (  ):
		super ().
	end constructor.

	method override public void Load(  ):
		
		undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

	end method.

end class.