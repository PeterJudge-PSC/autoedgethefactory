/*------------------------------------------------------------------------
    File        : BindingBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 02 14:51:10 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.ConstructorArgument.
using OpenEdge.Core.InjectABL.Binding.Parameters.MethodArgument.
using OpenEdge.Core.InjectABL.Binding.Parameters.PropertyValue.
using OpenEdge.Core.InjectABL.Binding.Conditions.ConditionBuilder.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Lang.EnumMember.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.BindingBuilder implements IBindingSyntax:
    
    /** Gets the binding being built.  */
    define public property Binding as IBinding no-undo get. private set.
    
    /** Gets the kernel.  */
    define public property Kernel as IKernel no-undo get. private set.
    
    /** Initializes a new instance of the BindingBuilder&lt.T&gt. class.
        @param binding The binding to build.
        @param kernel The kernel. */
    constructor public BindingBuilder(poBinding as IBinding, poKernel as IKernel):
        Assert:ArgumentNotNull(poBinding, "binding").
        Assert:ArgumentNotNull(poKernel, "kernel").
        
        Binding = poBinding.
        Kernel = poKernel.
    end constructor.
    
    /** Indicates that the service should be self-bound.  */
    method public IBindingSyntax ToSelf():   
        Binding:TargetType = Binding:Service.
        Binding:Target = BindingTargetEnum:Self.
        
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to the specified implementation type.
        @param implementation The implementation type.
      */
    method public IBindingSyntax To(pcImplementation as character):
        return this-object:To(Class:GetClass(pcImplementation)).
    end method.
    
    method public IBindingSyntax To(poImplementation as class Class):
        Binding:TargetType = poImplementation.
        Binding:Target = BindingTargetEnum:Type.
        
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to an instance of the specified provider type.
        The instance will be activated via the kernel when an instance of the service is activated.
        @param poProviderType The type of provider to activate.
     */
    method public IBindingSyntax Using(pcProviderType as character):
        return this-object:Using(Class:GetClass(pcProviderType)).
    end method.
    
    method public IBindingSyntax Using(poProviderType as class Class):
        Binding:ProviderType = poProviderType.
        return this-object.
    end method.
        
    /** Indicates that only a single instance of the binding should be created, and then
        should be re-used for all subsequent requests.  */
    method public IBindingSyntax InSingletonScope():
        Binding:Scope = StandardScope:Singleton.        
        return this-object.
    end method.
    
    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  */
    method public IBindingSyntax InTransientScope():
        Binding:Scope = StandardScope:Transient.
        return this-object.
    end method.
    
    /** Indicates that instances activated via the binding should be re-used within the same AppServer/WebSpeed request. */
    method public IBindingSyntax InAgentScope():
        Binding:Scope = StandardScope:Agent.
        return this-object.
    end method.
    
    method public IBindingSyntax InScope(poScopeCallback as class Class, poScope as EnumMember):
        Assert:ArgumentNotNull(poScopeCallback, 'Custom scope callback type').
        Assert:ArgumentNotNull(poScope, 'Custom scope').
        
        /* Even though this is statically-called, we can still type-check */
        Assert:ArgumentIsType(poScopeCallback, Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardScope')).
        
        Binding:Scope = poScope.
        Binding:ScopeCallbackType = poScopeCallback.
        
        return this-object.
    end method.
    
    /* WithConstructorArgument */
    method public IBindingSyntax WithConstructorArgument(poValue as class Class):
        Binding:Parameters:Add(new ConstructorArgument(poValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class, poDataType as EnumMember):
        Binding:Parameters:Add(new ConstructorArgument(poValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent):
        Binding:Parameters:Add(new ConstructorArgument(poService)).
        return this-object.
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent, poDataType as EnumMember):
        Binding:Parameters:Add(new ConstructorArgument(poService, poDataType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object):
        Binding:Parameters:Add(new ConstructorArgument(poValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as Object, poDeclaringType as class Class):
        Binding:Parameters:Add(new ConstructorArgument(poValue, poDeclaringType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent):
        Binding:Parameters:Add(new ConstructorArgument(poValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent, poDeclaringType as class Class):
        Binding:Parameters:Add(new ConstructorArgument(poValue, poDeclaringType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character):
        Binding:Parameters:Add(new ConstructorArgument(pcValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character, poDataType as EnumMember):
        Binding:Parameters:Add(new ConstructorArgument(pcValue, poDataType)).
        return this-object.
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character extent):
        Binding:Parameters:Add(new ConstructorArgument(pcValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent, poDataType as EnumMember):
        Binding:Parameters:Add(new ConstructorArgument(pcValue, poDataType)).
        return this-object.
    end method.
    
    /* WithPropertyValue */
    method public IBindingSyntax WithPropertyValue(pcPropertyName as character, poService as class Class):
        Binding:Parameters:Add(new PropertyValue(pcPropertyName, poService)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcPropertyName as character, poService as class Class, poDataType as EnumMember):
        Binding:Parameters:Add(new PropertyValue(pcPropertyName, poService, poDataType)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcPropertyName as character, poService as class  Class extent ):
        Binding:Parameters:Add(new PropertyValue(pcPropertyName, poService)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcPropertyName as character, poService as class Class extent, poDataType as EnumMember):
        Binding:Parameters:Add(new PropertyValue(pcPropertyName, poService, poDataType)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcName as character, poValue as Object ):
        Binding:Parameters:Add(new PropertyValue(pcName, poValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(pcName as character, poValue as Object, poDeclaringType as class Class):
        Binding:Parameters:Add(new PropertyValue(pcName, poValue, poDeclaringType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(pcName as character, poValue as Object extent):
        Binding:Parameters:Add(new PropertyValue(pcName, poValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(pcName as character, poValue as Object extent, poDeclaringType as class Class):
        Binding:Parameters:Add(new PropertyValue(pcName, poValue, poDeclaringType)).
        return this-object.
    end method.
        
    method public IBindingSyntax WithPropertyValue(pcName as character, pcValue as character ):
        Binding:Parameters:Add(new PropertyValue(pcName, pcValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcName as character, pcValue as character, poDataType as EnumMember):
        Binding:Parameters:Add(new PropertyValue(pcName, pcValue, poDataType)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcName as character, pcValue as character extent):
        Binding:Parameters:Add(new PropertyValue(pcName, pcValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithPropertyValue(pcName as character, pcValue as character extent, poDataType as EnumMember):
        Binding:Parameters:Add(new PropertyValue(pcName, pcValue, poDataType)).
        return this-object.
    end method.

    /* WithMethodValue */
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poService as class Class):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poService)).
        return this-object.
    end method.

    method public IBindingSyntax WithMethodValue(pcMethodName as character, poService as class Class extent):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poService)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as Object, poDeclaringType as class Class):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue, poDeclaringType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as Object):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue)).
        return this-object.
    end method.
        
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as class Class, poDataType as EnumMember):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue, poDataType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as Object extent):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as Object extent, poDeclaringType as class Class):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue, poDeclaringType)).
        return this-object.
    end method.

    method public IBindingSyntax WithMethodValue(pcMethodName as character, poValue as class Class extent, poDataType as EnumMember):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, poValue, poDataType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, pcValue as character):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, pcValue)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, pcValue as character, poDataType as EnumMember):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, pcValue, poDataType)).
        return this-object.
    end method.
    
    method public IBindingSyntax WithMethodValue(pcMethodName as character, pcValue as character extent):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, pcValue)).
        return this-object.
    end method.

    method public IBindingSyntax WithMethodValue(pcMethodName as character, pcValue as character extent, poDataType as EnumMember):
        Binding:Parameters:Add(new MethodArgument(pcMethodName, pcValue, poDataType)).
        return this-object.
    end method.

    /* When */    
    method public IConditionSyntax When():
        define variable oConditionBuilder as IConditionSyntax no-undo.
        
        If valid-object(Binding:Condition) then
            oConditionBuilder = new ConditionBuilder(Binding:Condition).
        else
            oConditionBuilder = new ConditionBuilder(Binding).
        
        return oConditionBuilder.
    end method.
    
    method public IBindingSyntax OnClientSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:Session:Is(SessionTypeCondition:Client).

        return this-object.
    end method.
    
    method public IBindingSyntax OnWebSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:Session:Is(SessionTypeCondition:Web).

        return this-object.
    end method.
    
    method public IBindingSyntax OnServerSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:Session:Is(SessionTypeCondition:Server).
        
        return this-object.
    end method.

    /*
    @IBindingAsSyntax.
    method public IBindingSyntax AsChui():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:UIType:Is(UITypeCondition:Chui).
        
        return this-object.
    end method.
    
    method public IBindingSyntax AsAblGui():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:UIType:Is(UITypeCondition:ABLGui).
        
        return this-object.
    end method.
    
    method public IBindingSyntax AsDotNetGui():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:UIType:Is(UITypeCondition:DotNetGui).
        
        return this-object.
    end method.
    
    method public IBindingSyntax AsRiaGui():
        define variable oConditionSyntax as IConditionSyntax no-undo.
         
        oConditionSyntax = this-object:When().
        oConditionSyntax:UIType:Is(UITypeCondition:RiaGui).
        
        return this-object.
    end method.
    */
    
    method public IBindingSyntax Named(pcName as character):
        Binding:Name = pcName.
        return this-object.
    end method.
    
end class.