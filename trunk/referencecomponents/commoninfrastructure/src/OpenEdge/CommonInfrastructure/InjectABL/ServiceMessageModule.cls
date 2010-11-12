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
	constructor protected ServiceMessageModule (  ):
		super ().
	end constructor.
	
	method override public void Load():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /** Standard service adapter binding on the client. This can be customised for specific services
            if needed. */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :Named('CustomerService')
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter')
            :OnClientSession().

        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax
            :Named('CustomerService')
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter')
            :OnServerSession().
	end method.
	
end class.