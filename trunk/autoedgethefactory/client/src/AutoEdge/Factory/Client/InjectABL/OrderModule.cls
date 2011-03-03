/** ------------------------------------------------------------------------
    File        : OrderModule
    Purpose     : Client-side Order bindings
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.

using Progress.Lang.Class.

class AutoEdge.Factory.Client.InjectABL.OrderModule inherits InjectionModule: 
    define protected property IServiceProviderType as class Class no-undo get. set.
    
    constructor public OrderModule (  ):
        super ().
        
        assign IServiceProviderType = Class:GetClass('OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceProvider').
    end constructor.
    
    method protected void LoadServices():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* Bind as a service adapter. the server-side bindings will translate this into a IServiceProvider
           object capable of doing something useful. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named('Order')
            :To('OpenEdge.CommonInfrastructure.Client.AppServerServiceAdapter')
            :OnThinClientSession().

        /* Bind as a service adapter. the server-side bindings will translate this into a IServiceProvider
           object capable of doing something useful. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named('OrderCapture')
            :To('OpenEdge.CommonInfrastructure.Client.AppServerServiceAdapter')
            :OnThinClientSession().

        /* Bind as a service adapter. the server-side bindings will translate this into a IServiceProvider
           object capable of doing something useful. */
        oBindingSyntax = Bind(IServiceProviderType).
        oBindingSyntax
            :Named('VehicleOptions')
            :To('OpenEdge.CommonInfrastructure.Client.AppServerServiceAdapter')
            :OnThinClientSession().

    end method.
    
    method protected void LoadUI():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        oBindingSyntax = Bind(Class:GetClass('AutoEdge.Factory.Client.Common.PresentationLayer.ITaskListManager')).
        oBindingSyntax
            :To('AutoEdge.Factory.Client.Order.PresentationLayer.DealerReview')
            :OnThinClientSession().
    end method.
    
    method override public void Load(  ):
        LoadServices().
        LoadUI().
    end method.
    
end class.