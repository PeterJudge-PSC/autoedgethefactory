/*------------------------------------------------------------------------
    File        : Assert
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
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
    
    @todo(task="implement", action="implement").
    method public static void EnumHasMember():
        undo, throw new AppError('method not implemented').
    end method.
    
end class.