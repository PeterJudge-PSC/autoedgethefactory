 /*------------------------------------------------------------------------
    File        : ComponentProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 14:41:39 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo. 
using OpenEdge.CommonInfrastructure.Client.ComponentTypeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ComponentProvider inherits StandardProvider:
    
    constructor public ComponentProvider(poClass as class Class):
        super(poClass).
    end constructor.
    
    method override public Object Create(poContext as ILifecycleContext):
        poContext:Parameters:Add(
                new ConstructorArgument(
                    new ComponentInfo(
                            poContext:Binding:Service,
                            poContext:Binding:Name, 
                            ComponentTypeEnum:ApplicationComponent,
                            true),
                    Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponentInfo'))).
        
        return super:Create(poContext).
    end method.
    
end class.