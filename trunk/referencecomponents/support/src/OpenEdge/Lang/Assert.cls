/*------------------------------------------------------------------------
    File        : Assert
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:08:57 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.
using Progress.Lang.AppError.

class OpenEdge.Lang.Assert:

    method public static void ArgumentNotNull(poArgument as Object , pcName as char):
        if not valid-object(poArgument) then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.
    
    method public static void ArgumentNotNull(poArgument as Object extent, pcName as char):
        if extent(poArgument) eq ? then
            undo, throw new AppError(substitute('&1 cannot be null', pcName)).
    end method.
    
    method public static void ArgumentNotNullOrEmpty(pcArgument as character, pcName as character):
        if pcArgument eq ? or pcArgument eq '' then 
            undo, throw new AppError(substitute('&1 cannot be unknown or empty', pcName)).
    end method.
    
    method public static void ArgumentIsInterface(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if not poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentNotInterface(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if poArgument:IsInterface() then
            undo, throw new AppError(substitute('&1 is not an interface', poArgument:TypeName)).
    end method.

    method public static void ArgumentIsAbstract(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if not poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is an abstract type', poArgument:TypeName)).        
    end method.

    method public static void ArgumentNotAbstract(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if poArgument:IsAbstract() then
            undo, throw new AppError(substitute('&1 is not an abstract type', poArgument:TypeName)).        
    end method.
        
    method public static void ArgumentIsFinal(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if not poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is a final type', poArgument:TypeName)).                        
    end method.
    
    method public void ArgumentIsType(pcTypeName as character):
        define variable oType as class Class no-undo.
        
        Assert:ArgumentNotNullOrEmpty(pcTypeName, 'TypeName').
        oType = Class:GetClass(pcTypeName) no-error.
        if not valid-object(oType) then
            undo, throw new AppError(substitute('&1 is not a valid type', pcTypeName)).
    end method.
    
    method public static void ArgumentNotFinal(poArgument as class Class):
        Assert:ArgumentNotNull(poArgument, 'Type').
        if poArgument:IsFinal() then
            undo, throw new AppError(substitute('&1 is not a final type', poArgument:TypeName)).                        
    end method.
    
    @test.
    method public static void ArgumentIsType(poArgument as Object, poType as class Class):
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
    
end class.