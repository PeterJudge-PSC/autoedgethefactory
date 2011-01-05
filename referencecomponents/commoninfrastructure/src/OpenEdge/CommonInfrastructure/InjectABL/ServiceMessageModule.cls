/** ------------------------------------------------------------------------
    File        : ServiceMessageModule
    Purpose     : InjectABL module for service messaging infrastructure.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 23 13:58:36 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

class OpenEdge.CommonInfrastructure.InjectABL.ServiceMessageModule inherits InjectionModule:
     
	constructor public ServiceMessageModule():
		super ().
	end constructor.
	
	method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
            
	end method.
	
end class.