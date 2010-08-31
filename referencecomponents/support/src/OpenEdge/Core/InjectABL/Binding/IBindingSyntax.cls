/*------------------------------------------------------------------------
    File        : IBindingSyntax
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:45:09 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.Core.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.Core.InjectABL.Binding.IBindingSyntax:
    
    @IBindingToSyntax.
    /** Indicates that the service should be self-bound.  */
    method public IBindingSyntax ToSelf().
    /** Indicates that the service should be bound to the specified implementation type.  */
    method public IBindingSyntax To(poImplementation as class Class).
    method public IBindingSyntax To(pcImplementation as character).
    
    @IBindingUsingSyntax.
    /** Indicates that the service will be constructed with an instance of the specified provider type.  */
    method public IBindingSyntax Using(poProvider as class Class).
    method public IBindingSyntax Using(pcProvider as character).
        
    @IBindingInSyntax.
    /** Indicates that only a single instance of the binding 
        should be created, and then should be re-used for all 
        subsequent requests.  */
    method public IBindingSyntax InSingletonScope().

    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  */
    method public IBindingSyntax InTransientScope().
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. */
    method public IBindingSyntax InAgentConnectionScope().
    /** Indicates that an instance will be reused across an AppServer request. */
    method public IBindingSyntax InAgentRequestScope().
    
    /* Custom scope */    
    method public IBindingSyntax InScope(poScopeCallback as class Class, poScope as StandardScopeEnum).
    
    @IBindingOnSyntax.
    method public IBindingSyntax OnClientSession().
    method public IBindingSyntax OnWebSession().
    method public IBindingSyntax OnServerSession().
    
    /** Certain UI platforms support multiple UI technologies (eg ABL and .NET on GUI Windows).
    @IBindingAsSyntax.
    method public IBindingSyntax AsChui().
    method public IBindingSyntax AsAblGui().
    method public IBindingSyntax AsDotNetGui().
    method public IBindingSyntax AsRiaGui().   
    */
    
    @IBindingWhenSyntax.
    method public IConditionSyntax When().
    
    @IBindingWithSyntax.
    /** Parameters can be passed as type Progress.Lang.Class; in this case, they could be a service to be 
        invoked by InjectABL, or a simple reference which the application uses for its own purposes. For
        simple references, we specify DataTypeEnum:ProgressLangObject in the methods that support it; 
        for a service we specify DataTypeEnum:Class.
        
        If the overload with PLO is called and a PLC passed in, we assume it's a service.
        
        The default is a Service (ie DataTypeEnum:Class or DataTypeEnum:ClassArray). */
    
    /** Indicates that the specified constructor argument should be overridden with the specified value. */    
    method public IBindingSyntax WithConstructorArgument(poService as class Class).
    method public IBindingSyntax WithConstructorArgument(poService as class Class, poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(poService as class Class extent).
    method public IBindingSyntax WithConstructorArgument(poService as class Class extent, poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object).
    method public IBindingSyntax WithConstructorArgument(poValue as Object, poDeclaringType as class Class).
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent).
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent, poDeclaringType as class Class).
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character).
    method public IBindingSyntax WithConstructorArgument(pcValue as character, poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent).
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent, poDataType as DataTypeEnum).
    
    /** Indicates that the specified property should be injected with the specified value.  */
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poService as class Class).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poService as class Class, poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poService as class Class extent).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poService as class Class extent, poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poValue as Object).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poValue as Object, poDeclaringType as class Class).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poValue as Object extent).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, poValue as Object extent, poDeclaringType as class Class).
    
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, pcValue as character).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, pcValue as character, poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, pcValue as character extent).
    method public IBindingSyntax WithPropertyValue(pcPropertyName as char, pcValue as character extent, poDataType as DataTypeEnum).
    
    /** Indicates that the specified method should be injected with the specified value.  */
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poService as class Class).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poService as class Class, poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poService as class Class extent).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poService as class Class extent, poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poValue as Object).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poValue as Object, poDeclaringType as class Class).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poValue as Object extent).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, poValue as Object extent, poDeclaringType as class Class).
    
    method public IBindingSyntax WithMethodValue(pcMethodName as char, pcValue as character).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, pcValue as character, poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, pcValue as character extent).
    method public IBindingSyntax WithMethodValue(pcMethodName as char, pcValue as character extent, poDataType as DataTypeEnum).
    
    @IBindingNamedSyntax.
    /** Gives the service an instance name. By default this is the service name  */
    method public IBindingSyntax Named(pcName as character).
    
end interface.