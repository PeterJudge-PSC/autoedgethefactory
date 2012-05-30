/*------------------------------------------------------------------------
    File        : ComponentKernel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 18 10:35:43 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.Core.InjectABL.StandardKernel.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentKernel inherits StandardKernel: 

    constructor public ComponentKernel():
        super().
    end constructor. 
    
    constructor public ComponentKernel(poModules as IInjectionModuleCollection):
        super(poModules).
    end constructor.

    constructor protected ComponentKernel(poComponents as OpenEdge.Core.InjectABL.ComponentContainer, 
                                     poModules as IInjectionModuleCollection,
                                     poSettings as OpenEdge.Core.InjectABL.KernelSettings):
        super(poComponents, poModules, poSettings).

    end constructor.
        
    method protected override void AddComponents():
        super:AddComponents().
        
        /* Lifecycle */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.CommonInfrastructure.Common.InjectABL.ComponentLifecycleStrategy')).
    end method.
    
end class.