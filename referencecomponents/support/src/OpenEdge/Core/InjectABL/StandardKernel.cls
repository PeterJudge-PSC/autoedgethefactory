/*------------------------------------------------------------------------
    File        : StandardKernel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Mar 03 11:23:20 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Core.InjectABL.KernelBase.
using OpenEdge.Core.InjectABL.ComponentContainer.
using OpenEdge.Core.InjectABL.KernelSettings.
using Progress.Lang.Class.

class OpenEdge.Core.InjectABL.StandardKernel inherits KernelBase: 
    
    method protected override void AddComponents():
        /* these are mappings */
        
        /* Cache */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ICache'), 
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.Cache')).

        /* Pipeline */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.IPipeline'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardPipeline')).

        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy')).
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.MethodInjectionLifecycleStrategy')).
        
        /* Binding */        
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Binding.IBindingResolver'), 
                       Class:GetClass('OpenEdge.Core.InjectABL.Binding.StandardBindingResolver')).
    end method.
    
    constructor public StandardKernel():
        super().
    end constructor.

    constructor public StandardKernel(poModules as IInjectionModuleCollection):
        super(poModules).
    end constructor.
        
    constructor protected StandardKernel (poComponents as ComponentContainer,
                                          poModules as IInjectionModuleCollection,
                                          poSettings as KernelSettings):
        super(poComponents, poModules, poSettings).
    end constructor.
    
end class.