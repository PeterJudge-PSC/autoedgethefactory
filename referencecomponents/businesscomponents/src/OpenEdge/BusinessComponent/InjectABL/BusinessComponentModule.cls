/** ------------------------------------------------------------------------
    File        : BusinessComponentModule
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 11:05:25 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

class OpenEdge.BusinessComponent.InjectABL.BusinessComponentModule inherits InjectionModule:
	constructor protected BusinessComponentModule (  ):
		super ().
	end constructor.

	method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /** Standard service provider binding on the server. Note that this is not a realistic
            binding, just an example, since there are likely to be a number of bindings to 
            IBusinessEntity, and also that a generic Business Entity is unlikely. */
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax:To('OpenEdge.BusinessComponent.Entity.IBusinessEntity')
            :OnServerSession().
        
        oBindingSyntax = Bind('OpenEdge.BusinessComponent.Entity.IBusinessEntity').
        oBindingSyntax:To('OpenEdge.BusinessComponent.Entity.BusinessEntity')
            .
        
	end method.

end class.