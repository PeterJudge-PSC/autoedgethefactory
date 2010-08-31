 /*------------------------------------------------------------------------
    File        : ServiceProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 07 14:41:39 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ComponentInfo.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ComponentTypeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Core.InjectABL.Binding.Parameters.MethodArgument.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider inherits StandardProvider:
    
    constructor public ServiceProvider(poClass as class Class):
        super(poClass).
    end constructor.
    
    method override public Object Create(poContext as ILifecycleContext):
        /* We always want the service manager injected into IService objects */
        poContext:Parameters:Add(
                new ConstructorArgument(
                        Class:GetClass('OpenEdge.CommonInfrastructure.Common.IServiceManager'))).
        
        poContext:Parameters:Add(
                new ConstructorArgument(
                    new ComponentInfo(
                        poContext:Binding:Service,
                        poContext:Binding:Name,
                        ComponentTypeEnum:Service,      /* we don't know what kind of service this is, just that it is a service */
                        true),      /* AutoStart */
                    Class:GetClass('OpenEdge.CommonInfrastructure.Common.IComponentInfo'))).
        
        return super:Create(poContext).
    end method.
    
end class.