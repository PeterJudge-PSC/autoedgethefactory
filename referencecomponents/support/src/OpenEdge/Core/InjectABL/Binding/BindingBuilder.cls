/*------------------------------------------------------------------------
    File        : BindingBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:51:10 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.IBinding.
using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.InjectABL.Binding.Conditions.ConditionBuilder.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.Core.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.Core.InjectABL.IKernel.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
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

    /** Indicates that the service should be bound to the specified implementation type.
        
        @param poImplementation The implementation type. This has to be a concrete type
        (ie not abstract or an interface). */    
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
        Binding:Scope = StandardScopeEnum:Singleton.        
        return this-object.
    end method.
    
    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  */
    method public IBindingSyntax InTransientScope():
        Binding:Scope = StandardScopeEnum:Transient.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. */
    method public IBindingSyntax InAgentConnectionScope():
        Binding:Scope = StandardScopeEnum:AgentConnection.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer request. */
    method public IBindingSyntax InAgentRequestScope():
        Binding:Scope = StandardScopeEnum:AgentRequest.
        return this-object.
    end method.
    
    method public IBindingSyntax InScope(poScopeCallback as class Class, poScope as StandardScopeEnum):
        Assert:ArgumentNotNull(poScopeCallback, 'Custom scope callback type').
        Assert:ArgumentNotNull(poScope, 'Custom scope').
        
        /* Even though this is statically-called, we can still type-check */
        Assert:ArgumentIsType(poScopeCallback, Class:GetClass('OpenEdge.Core.InjectABL.Lifecycle.StandardScope')).
        
        Binding:Scope = poScope.
        Binding:ScopeCallbackType = poScopeCallback.
        
        return this-object.
    end method.
    
/* WithConstructorArgument */
    /* generalised case; all other WithConstructorArgument() methods pass through this one. */
    method public IBindingSyntax WithConstructorArgument(input poParameter as IParameter extent).    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, '', RoutineTypeEnum:Constructor).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
/* WithPropertyValue */
    /** Generalised case for more complex scenarios; all other WithPropertyValue() methods pass through this one. This method will probably never be called directly, but
        it doesn't hurt to have here. */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character,
                                                   input poParameter as IParameter extent).    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcPropertyName, RoutineTypeEnum:PropertySetter).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class  Class extent ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).

        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
        
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
/* WithMethodValue */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as class Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter( poValue).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
        
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent, poDeclaringType as class Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as class Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character,
                                                 input poParameter as IParameter extent):
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcMethodName, RoutineTypeEnum:Method).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
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