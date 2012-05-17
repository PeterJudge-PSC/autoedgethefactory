/** ------------------------------------------------------------------------
    File        : Parameter
    Purpose     : Constructor, method or property parameter/argument class for
                  dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:46 EST 2010
    Notes       : * Parameters can be passed as type Progress.Lang.Class; in this case, they could be 
                    a service to be invoked by InjectABL, or a simple reference which the application
                    uses for its own purposes. For simple references, we specify DataTypeEnum:ProgressLangObject 
                    in the methods that support it; for a service we specify DataTypeEnum:Class.
                * The default is a Service (ie DataTypeEnum:Class or DataTypeEnum:ClassArray).
                * If a Service is being used, we can specify an optional InstanceName
                * If an array of services is used (ie DataTypeEnum:ClassArray), the DeclaredType 
                  MUST be specified, since there's no way to derive the declaring type. We could
                  assume that the first extent is the declaring type, but that's error prone in
                  its own right. We do make an assumption if the parameter is scalar.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.ArgumentError.

using OpenEdge.Lang.RoutineTypeEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.String.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.Parameter implements IParameter:
    
    /** (optional) Gets the name of the parameter. Only informational.*/
    define public property Name as character no-undo get. set.
    
    /** (mandatory) The datatype of the parameter. */
    define public property DataType as DataTypeEnum no-undo get. private set.
    
    /** (mandatory) Specify a declared type for cases where the parameter an object or array
        thereof. ABL doesn't currently (10.2B) allow us to discover either the declared type
        of the array, or the signature of the callee (method, property, ctor), and so we need
        to specify the type for the InjectABL kernel. */
    define public property DeclaredType as class Class no-undo get. private set.
    
    define private variable moValue as Object extent no-undo.
    define private variable mcValue as character extent no-undo.
    define private variable mcInstanceName as character extent no-undo.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object):
        if DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type ').
        if DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not a scalar value').
        
        if DataType:Equals(DataTypeEnum:Class) then
            poValue = poContext:Kernel:Get(cast(moValue[1], Class), mcInstanceName[1]).
        else
            poValue = moValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type').
        
        if not DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        iMax = extent(moValue).
        extent(poValue) = iMax.
        
        do iLoop = 1 to iMax:
            if DataType:Equals(DataTypeEnum:ClassArray) then
                poValue[iLoop] = poContext:Kernel:Get(cast(moValue[iLoop], Class), mcInstanceName[iLoop]).
            else
                poValue = moValue.
        end.
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character):
        if not DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data type').
        
        if DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a scalar value').
        
        pcValue = mcValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent):
        if not DataTypeEnum:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data tye').
                           
        if not DataTypeEnum:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        pcValue = mcValue.
    end method.
    
/* Primitive value constructors */
    constructor public Parameter(input pcValue as character):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character extent):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               extent(mcValue) = 1
               mcValue[1] = pcValue
               /* we could potentially turn these primitive values into Strings */
               DeclaredType = String:Type.
    end constructor.
    
    constructor public Parameter(input pcValue as character extent, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               mcValue = pcValue
               DeclaredType = String:Type.
    end constructor.
    
/* Object value constructors */
    constructor public Parameter(input poValue as Object):
        this-object(poValue,
                    if valid-object(poValue) then poValue:GetClass() else Class:GetClass('Progress.Lang.Object') ).
    end constructor.
    
    constructor public Parameter(input poValue as Object, input poDeclaredType as class Class):
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        /* Use another ctor for this */
        if valid-object(poValue) and type-of(poValue, Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign extent(moValue) = 1
               moValue[1] = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.
    end constructor.
            
    constructor public Parameter(input poValue as Object extent):
        this-object(poValue,
                    if valid-object(poValue[1]) then poValue[1]:GetClass() else Class:GetClass('Progress.Lang.Object')).
    end constructor.
    
    constructor public Parameter(input poValue as Object extent, input poDeclaredType as class Class):
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        if valid-object(poValue[1]) and type-of(poValue[1], Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign moValue = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.        
    end constructor.        

/* Class (service or value) constructors */
    constructor public Parameter(input poType as class Class):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class).
    end constructor.
    
    constructor public Parameter(input poType as class Class,
                                 input pcInstanceName as character):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, pcInstanceName, poType).
    end constructor.
    
    constructor public Parameter(input poType as class Class,
                                 input pcInstanceName as character,
                                 input poDeclaredType as class Class):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, pcInstanceName, poDeclaredType).
    end constructor.

    constructor public Parameter(input poType as class Class,
                                 input poDataType as DataTypeEnum,
                                 input poDeclaredType as class Class):
        this-object(poType, DataTypeEnum:Class, '', poDeclaredType).
    end constructor.
    
    constructor public Parameter(input poType as class Class,
                                 input poDataType as DataTypeEnum):
        define variable oDeclaredType as class Class no-undo.

        /* If this is a reference, the declared type is a Progress.Lang.Class object (ie not InjectABL);
           if not, then we take the given type as the declared type. */  
        if poDataType:Equals(DataTypeEnum:ProgressLangObject) then
            oDeclaredType = Class:GetClass('Progress.Lang.Class').
        else
            oDeclaredType = poType.
        
        ShadowConstructor(poType, poDataType, '', oDeclaredType).
    end constructor.

    constructor public Parameter(input poType as class Class,
                                 input poDataType as DataTypeEnum,
                                 input pcInstanceName as character):
        define variable oDeclaredType as class Class no-undo.

        /* If this is a reference, the declared type is a Progress.Lang.Class object (ie not InjectABL);
           if not, then we take the given type as the declared type. */  
        if poDataType:Equals(DataTypeEnum:ProgressLangObject) then
            oDeclaredType = Class:GetClass('Progress.Lang.Class').
        else
            oDeclaredType = poType.
                                     
        ShadowConstructor(poType, poDataType, pcInstanceName, oDeclaredType).                                     
    end constructor.
            
    constructor public Parameter(input poType as class Class,
                                 input poDataType as DataTypeEnum,
                                 input pcInstanceName as character,
                                 input poDeclaredType as class Class):
        ShadowConstructor(poType, poDataType, pcInstanceName, poDeclaredType).
    end constructor.

    constructor public Parameter(input poType as class Class extent,
                                 input poDeclaredType as class Class):
        this-object(poType, DataTypeEnum:ClassArray, poDeclaredType).
    end constructor.
    
    /* See note in constructor below. */
    constructor public Parameter(input poType as class Class extent,
                                 input poDataType as DataTypeEnum,
                                 input poDeclaredType as class Class):
        define variable cInstanceName as character extent no-undo.

        assign extent(cInstanceName) = extent(poType)
               cInstanceName = ''.

        ShadowConstructor(poType, poDataType, cInstanceName, poDeclaredType).
    end constructor.

    constructor public Parameter(input poType as class Class extent,
                                 input poDataType as DataTypeEnum,
                                 input pcInstanceName as character extent,
                                 input poDeclaredType as class Class):
        ShadowConstructor(poType, poDataType, pcInstanceName, poDeclaredType).
    end constructor.
    
    constructor public Parameter(input poType as class Class extent, 
                                 input pcInstanceName as character extent,
                                 input poDeclaredType as class Class):
        ShadowConstructor(poType, DataTypeEnum:ClassArray, pcInstanceName, poDeclaredType).                                     
    end constructor.
    
    /* Since some of these parameters are arrays, and may not always be passed, we have
       created a shadow constructor which doesn't need to be run as the first line in
       a constructor. This lets us change the parameters as needed before setting them
       in the object. */
    method private void ShadowConstructor(input poType as class Class extent,
                                          input poDataType as DataTypeEnum,
                                          input pcInstanceName as character extent,
                                          input poDeclaredType as class Class):
        Assert:ArgumentNotNullOrEmpty(poType, 'Object value').
        Assert:ArgumentNotNull(poDataType, 'Data type').
        Assert:ArgumentNotNull(poDeclaredType, 'Declared Type').
        
        assign moValue = poType
               DataType = poDataType
               DeclaredType = poDeclaredType
               extent(mcInstanceName) = extent(moValue)
               mcInstanceName = pcInstanceName.
    end method.

    /* Since are calculated from others, which may not always be passed, we have
       created a shadow constructor which doesn't need to be run as the first line in
       a constructor. This lets us change the parameters as needed before setting them
       in the object. */
    method private void ShadowConstructor(input poType as class Class,
                                          input poDataType as DataTypeEnum,
                                          input pcInstanceName as character,
                                          input poDeclaredType as class Class):
        Assert:ArgumentNotNull(poType, 'Object value').
        Assert:ArgumentNotNull(poDataType, 'Data type').
        Assert:ArgumentNotNull(poDeclaredType, 'Declared type').
        
        assign extent(moValue) = 1
               extent(mcInstanceName) = 1
               moValue[1] = poType               
               DataType = poDataType
               mcInstanceName[1] = pcInstanceName
               DeclaredType = poDeclaredType.
    end method.
        

end class.