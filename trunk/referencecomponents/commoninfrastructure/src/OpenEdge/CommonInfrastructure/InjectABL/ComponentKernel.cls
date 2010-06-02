/*------------------------------------------------------------------------
    File        : ComponentKernel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 18 10:35:43 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.Core.InjectABL.StandardKernel.
using OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.InjectABL.ComponentKernel inherits StandardKernel: 

    constructor public ComponentKernel():
        super().
    end constructor.

    constructor public ComponentKernel(poModules as IInjectionModuleCollection):
        super(poModules).
    end constructor.
    
    method protected override void AddComponents():
        super:AddComponents().
        
        /* Lifecycle */
        Components:Add(Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.ILifecycleStrategy'),
                       Class:GetClass('OpenEdge.CommonInfrastructure.InjectABL.ComponentLifecycleStrategy')).
    end method.
    
end class.