/** ------------------------------------------------------------------------
    File        : Parameter
    Purpose     : Constructor, method or property parameter/argument class for
                  dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.Parameter implements IParameter:
    define public property Name as character no-undo get. private set. 
    define public property Type as DataTypeEnum no-undo get. private set.

    /** Specify a declared type for cases where the parameter an object or array thereof. ABL doesn't currently (10.2B)
        allow us to discover either the declared type of the array, or the signature of the callee (method, property, ctor),
        and so we need to specify the type for the InjectABL kernel. */
    define public property DeclaredType as class Class no-undo get. private set.
    
    define private variable moValue as Object extent no-undo.
    define private variable mcValue as character extent no-undo.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object):
        if DataTypeEnum:IsPrimitive(Type) then
            undo, throw new InvalidCallError('method', 'parameter type is not an object').
        if DataTypeEnum:IsArray(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is an not a scalar value').
        
        if Type eq DataTypeEnum:Class then
            poValue = poContext:Kernel:Get(cast(moValue[1], Class)).
        else
            poValue = moValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if DataTypeEnum:IsPrimitive(Type) then
            undo, throw new InvalidCallError('method', 'parameter type is not an object').
        
        if not DataTypeEnum:IsArray(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is an not array').
        
        iMax = extent(moValue).
        extent(poValue) = iMax.
        
        do iLoop = 1 to iMax:
            if Type eq DataTypeEnum:ClassArray then
                poValue[iLoop] = poContext:Kernel:Get(cast(moValue[iLoop], Class)).
            else
                poValue = moValue.
        end.
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character):
        if not DataTypeEnum:IsPrimitive(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is not a primitive value').
        
        if DataTypeEnum:IsArray(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is not a scalar value').
        
        pcValue = mcValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent):
        if not DataTypeEnum:IsPrimitive(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is not a primitive value').

        if not DataTypeEnum:IsArray(Type) then
            undo, throw new InvalidCallError('method', 'parameter value is an not array').
        
        pcValue = mcValue.
    end method.
    
    /* Primitive value constructors */
    constructor public Parameter(pcName as character, pcValue as char, poType as DataTypeEnum):
        assign Name = pcName
               Type = poType
               extent(mcValue) = 1
               mcValue[1] = pcValue.
    end constructor.
    
    constructor public Parameter(pcName as character, pcValue as char extent, poType as DataTypeEnum):
        assign Name = pcName
               Type = poType
               mcValue = pcValue.
    end constructor.
    
    constructor public Parameter(pcName as character, pcValue as char):
        this-object(pcName, pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(pcName as character, pcValue as char extent):
        this-object(pcName, pcValue, DataTypeEnum:CharacterArray).
    end constructor.
    
    /* Object value constructors */
    constructor public Parameter(pcName as character, poValue as Object):
        this-object(pcName, poValue, poValue:GetClass()).
    end constructor.
    
    constructor public Parameter(pcName as character, poValue as Object, poDeclaredType as class Class):
        Assert:ArgumentNotNull(poValue, 'Object value').
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        if type-of(poValue, Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign Name = pcName
               extent(moValue) = 1
               moValue[1] = poValue
               DeclaredType = poDeclaredType
               Type = DataTypeEnum:ProgressLangObject.
    end constructor.
    
    constructor public Parameter(pcName as character, poValue as Object extent, poDeclaredType as class Class):
        Assert:ArgumentNotNull(poValue[1], 'Object value').
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        if type-of(poValue[1], Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign Name = pcName
               moValue = poValue
               DeclaredType = poDeclaredType
               Type = DataTypeEnum:ProgressLangObject.
    end constructor.
    
    constructor public Parameter(pcName as character, poValue as Object extent):
        this-object(pcName, poValue, poValue[1]:GetClass()).
    end constructor.
    
    /* Class (service or value) constructors */
    constructor public Parameter(pcName as character, poType as class Class):
        /* Defaults to a service */ 
        this-object(pcName, poType, DataTypeEnum:Class).
    end constructor.
    
    constructor public Parameter(pcName as character, poType as class Class, poDataType as DataTypeEnum):
        Assert:ArgumentNotNull(poType, 'Object value').
        Assert:ArgumentNotNull(poDataType, 'Data type').
        
        assign Name = pcName
               extent(moValue) = 1
               moValue[1] = poType               
               Type = poDataType.
        
        /* If this is a reference, the declared type is a Progress.Lang.Class object;
           if not, then we take the given type as the declared type.  */
        if poDataType eq DataTypeEnum:ProgressLangObject then
            DeclaredType = Class:GetClass('Progress.Lang.Class').
        else
            DeclaredType = poType.
    end constructor.
    
    constructor public Parameter(pcName as character, poType as class Class extent):
        this-object(pcName,
                    poType,
                    Class:GetClass('Progress.Lang.Class')).
        /* Assume this is a service */
        Type = DataTypeEnum:Class.                    
    end constructor.
    
    constructor public Parameter(pcName as character, poType as class Class extent, poDataType as DataTypeEnum):
        /* These are always PLC */
        this-object(pcName,
                    poType,
                    Class:GetClass('Progress.Lang.Class')).
        Type = poDataType.
    end constructor.
    
end class.