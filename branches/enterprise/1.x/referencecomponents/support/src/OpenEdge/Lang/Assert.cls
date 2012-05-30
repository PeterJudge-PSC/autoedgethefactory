/** ------------------------------------------------------------------------
    File        : Assert
    Purpose     : General assertions of truth. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:08:57 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.Assert.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.
using Progress.Lang.AppError.

class OpenEdge.Lang.Assert:

    method public static void ArgumentNotNull(input poArgument as Object , pcName as char):
        if not valid-object(poArgument) then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.
    
    method public static void ArgumentNotNull(input poArgument as Object extent, pcName as char):
        if extent(poArgument) eq ? then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.

    method public static void ArgumentNotNull(pcArgument as character, pcName as character):
        if pcArgument eq ? then 
            undo, throw new AppError(substitute('&1 cannot be unknown', pcName)).
    end method.
    
    method public static void ArgumentNotNullOrEmpty(pcArgument as character, pcName as character):
        define variable cLongCharArg as longchar no-undo.
        cLongCharArg = pcArgument.
        Assert:ArgumentNotNullOrEmpty(cLongCharArg, pcName).
    end method.
    
    method public static void ArgumentNotNullOrEmpty(pcArgument as longchar, pcName as character):
        if pcArgument eq ? or pcArgument eq '' then 
            undo, throw new AppError(substitute('&1 cannot be unknown or empty', pcName)).
    end method.

    method public static void ArgumentNonZero(piArgument as integer, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.

    method public static void ArgumentNonZero(piArgument as int64, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.
    
    method public static void ArgumentNonZero(piArgument as integer extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:ArgumentHasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentNonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void ArgumentNonZero(piArgument as int64 extent, pcName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:ArgumentHasDeterminateExtent(piArgument, pcName).
        iMax = extent(piArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentNonZero(piArgument[iLoop], substitute('Extent &2 of &1', pcName, iLoop)).
        end.
    end method.

    method public static void ArgumentNonZero(piArgument as decimal, pcName as character):
        if piArgument eq 0 then
            undo, throw new AppError(substitute('&1 cannot be zero', pcName)).
    end method.
        
    method public static void ArgumentIsInterface(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentNotInterface(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is not an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentIsAbstract(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is not an abstract type', poArgument:TypeName)).        
    end method.

    method public static void ArgumentNotAbstract(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is an abstract type', poArgument:TypeName)).        
    end method.
        
    method public static void ArgumentIsFinal(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if not poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is not a final type', poArgument:TypeName)).
    end method.
    
    method public static void ArgumentNotFinal(input poArgument as class Class):
        Assert:ArgumentNotNull(input poArgument, 'Type').
        if poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is a final type', poArgument:TypeName)).                        
    end method.
    
    method static public void ArgumentIsValidType(input pcTypeName as character):
        define variable oType as class Class no-undo.
        
        Assert:ArgumentNotNullOrEmpty(pcTypeName, 'TypeName').
        oType = Class:GetClass(pcTypeName) no-error.
        if not valid-object(oType) then
            undo, throw new AppError(substitute('&1 is not a valid type', pcTypeName)).
    end method.

    method public static void ArgumentIsType(input poArgument as Object extent, poType as class Class):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if extent(poArgument) eq ? then
            undo, throw new AppError('argument cannot be an indeterminiate array').
        
        iMax = extent(poArgument).
        do iLoop = 1 to iMax:
            Assert:ArgumentIsType(poArgument[iLoop], poType).
        end.
    end method.
    
    method public static void ArgumentIsType(input poArgument as Object, poType as class Class):
        define variable oDerivedClass as class Class no-undo.
        
        Assert:ArgumentNotNull(poArgument, 'argument').
        Assert:ArgumentNotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if not oDerivedClass:IsA(poType) then
            undo, throw new AppError(
                    substitute('Object &1 (of type &2) is not of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName)).
    end method.
    
    method public static void ArgumentNotType(input poArgument as Object, poType as class Class):
        define variable oDerivedClass as class Class no-undo.
        
        Assert:ArgumentNotNull(poArgument, 'argument').
        Assert:ArgumentNotNull(poType, 'type').
        
        if type-of(poArgument, Progress.Lang.Class) then 
            oDerivedClass = cast(poArgument, Progress.Lang.Class).
        else
            oDerivedClass = poArgument:GetClass().
        
        if oDerivedClass:IsA(poType) then
            undo, throw new AppError(
                    substitute('Object &1 (of type &2) is of type &3',
                        poArgument:ToString(),
                        oDerivedClass:TypeName,
                        poType:TypeName)).
    end method.
    
    /** Asserts that a handle is valid.
        
        @param handle The handle being checked.
        @param character The name of the handle/variable being checked. */
    method public static void ArgumentNotNull(input phArgument as handle, input pcName as character):
        if not valid-handle(phArgument) then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.

    /** Asserts that a handle is valid and of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void ArgumentIsType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum,
                                             input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:ArgumentNotNull(phArgument, pcName).
        Assert:ArgumentNotNull(poCheckType, 'Check DataType').
        
        cCheckType = poCheckType:ToString().
        if phArgument:type ne cCheckType then
            undo, throw new AppError(substitute('&1 is not of type &2', pcName, cCheckType)).        
    end method.

    /** Asserts that a handle is valid and not of a particular datatype
        
        @param handle The handle being checked.
        @param DataTypeEnum The type the handle/variable being checked should be.
        @param character The name of the variable/handle.   */
    method public static void ArgumentNotType(input phArgument as handle,
                                             input poCheckType as DataTypeEnum,
                                             input pcName as character):
        define variable cCheckType as character no-undo.
        
        Assert:ArgumentNotNull(phArgument, pcName).
        Assert:ArgumentNotNull(poCheckType, 'Check DataType').
        
        cCheckType = poCheckType:ToString().
        if phArgument:type eq cCheckType then
            undo, throw new AppError(substitute('&1 cannot be of type &2', pcName, cCheckType)).        
    end method.
        
    method public static void ArgumentHasDeterminateExtent(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).                                                               
    end method.
    
    method public static void ArgumentIsIndeterminateArray(input pcArgument as character extent,
                                                           input pcName as character):
        if extent(pcArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).                                                               
    end method.
    
    method public static void ArgumentHasDeterminateExtent(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsIndeterminateArray(input piArgument as integer extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).
    end method.

    method public static void ArgumentHasDeterminateExtent(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) eq ? then
            undo, throw new AppError(substitute('&1 array cannot be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsIndeterminateArray(input piArgument as int64 extent,
                                                           input pcName as character):
        if extent(piArgument) ne ? then
            undo, throw new AppError(substitute('&1 array must be indeterminate', pcName)).
    end method.

    method public static void ArgumentIsAvailable(input phArgument as handle,
                                                  input pcName as character):
        Assert:ArgumentNotNull(phArgument, pcName).
        
        if not phArgument:available then
            undo, throw new AppError(substitute('record in buffer &1 is not available', pcName)).                                                               
    end method.

    method public static void ArgumentIsInt(input pcArgument as character,
                                            input pcName as character):
        define variable iCheckVal as integer no-undo.
        
        iCheckVal = int(pcArgument) no-error.
        if error-status:error then
            undo, throw new AppError(substitute('&1 is an integer value', pcName)).                                                               
    end method.
    
    
end class.