/** ------------------------------------------------------------------------
    File        : FactoryOrderModule
    Purpose     : Client-side Order bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.

using Progress.Lang.Class.

class AutoEdge.Factory.InjectABL.FactoryOrderModule inherits InjectionModule: 
    define protected property IServiceProviderType as class Class no-undo get. set.
    
    constructor public FactoryOrderModule (  ):
        super ().
        
        assign IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
    end constructor.
    
    method protected void LoadServices():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* Bind as a service adapter. the server-side bindings will translate this into a IServiceProvider
           object capable of doing something useful. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named('Order')
            :To('OpenEdge.CommonInfrastructure.ServiceMessage.StandardServiceAdapter')
            :OnClientSession().
    end method.
    
    method protected void LoadUI():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        oBindingSyntax = Bind(Class:GetClass('AutoEdge.Factory.Order.PresentationLayer.ITaskListManager')).
        oBindingSyntax
            :To('AutoEdge.Factory.Order.PresentationLayer.DealerReview')
            :OnClientSession().
    end method.
    
    method override public void Load(  ):
        LoadServices().
        LoadUI().
    end method.
    
end class.