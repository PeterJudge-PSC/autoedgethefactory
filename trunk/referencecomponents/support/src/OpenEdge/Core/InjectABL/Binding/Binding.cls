/*------------------------------------------------------------------------
    File        : Binding
    Purpose     : 
    Syntax      : Contains information about a service registration.
    Description : 
    @author pjudge
    Created     : Wed Mar 03 14:28:18 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Binding.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameterCollection.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScope.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Core.InjectABL.Lifecycle.IProvider.
using OpenEdge.Core.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Lang.ObjectStack.
using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Binding implements IBinding: 
    /** Gets the service type that is controlled by the binding. */
    define public property Service as class Class no-undo get. private set.

    /** Gets or sets the condition defined for the binding. */
    define public property Condition as ObjectStack no-undo get. set. 
    
    /** Gets a value indicating whether the binding has a condition associated with it. */
    define public property IsConditional as logical no-undo
        get():            
            return (valid-object(Condition) and Condition:Size gt 0).
        end get.
    
    /** Gets or sets the type of target for the binding. */
    define public property Target as BindingTargetEnum no-undo get. set.
    
    /** Gets or sets the callback that returns the object that will act as the binding's scope. */
    define public property Scope as StandardScopeEnum no-undo get. set.
    define public property ScopeCallbackType as class Class no-undo
        get():
            if not valid-object(ScopeCallbackType) then
                ScopeCallbackType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardScope').
            
            return ScopeCallbackType.
        end get.
        set.
    
    /** Gets or sets the callback that returns the provider that should be used by the binding. */
    define public property ProviderType as class Class no-undo 
        get():
            /* Default to StandardProvider */
            if not valid-object(ProviderType) then
                ProviderType = Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardProvider').
            
            return ProviderType.
        end get.
        set.
    
    /** The target type of the binding. Must be a concrete class. */
    define public property TargetType as class Class no-undo get.
        set(poTargetType as class Class):
            Assert:ArgumentNotAbstract(poTargetType).
            
            TargetType = poTargetType.            
        end set.
    
    /** Gets the parameters defined for the binding. */
    define public property Parameters as IParameterCollection no-undo get. private set.
    
    define public property ConstructorArguments as IParameterCollection no-undo get. private set.
    define public property PropertyValues       as IParameterCollection no-undo get. private set.
    define public property MethodArguments      as IParameterCollection no-undo get. private set.
    
    /** Gets or sets the optional name defined for the binding.
        If not set, we use the Service name */
    define public property Name as character no-undo
        get():
            if this-object:Name eq ? or this-object:Name eq '' then
                this-object:Name = this-object:Service:TypeName.
            
            return this-object:Name.
        end get.
        set.
    
    constructor public Binding(poService as class Class):
        Assert:ArgumentNotNull(poService, "service").
        
        /* Binding defaults to self-binding */
        assign Service = poService
               Parameters = new IParameterCollection()
               Scope = StandardScopeEnum:Transient.
    end constructor.
    
    /** Gets the provider for the binding.
        @param context The context.
        @return The provider to use.
     */
    method public IProvider GetProvider():
        define variable oProvider as IProvider no-undo.
        
        oProvider = StandardProvider:GetProvider(this-object:ProviderType, this-object:Service).
        return oProvider.
    end method.
            
    /** Gets the scope for the binding, if any.
        @param context The context.
        @return The object that will act as the scope, or unknown if the service is transient.
     */
    method public Object GetScope(poContext as ILifecycleContext):
        Assert:ArgumentNotNull(poContext, "context").
        
        /** Unfortunately, we can't do any type-checking, since the GetScope() call is
            make statically. */
        return dynamic-invoke(ScopeCallbackType:TypeName, 'GetScope', poContext, Scope).
    end method.
    
    /** Determines whether the specified request satisfies the conditions defined on this binding.
        @param request The request.
        @return <c>True</c> if the request satisfies the conditions. otherwise <c>false</c>.
     */
    method public logical Matches(poBinding as IBinding):
        define variable lMatches as logical no-undo.
        
        Assert:ArgumentNotNull(poBinding, "binding").
        
        return lMatches.
    end method.
    
end class.
