/*------------------------------------------------------------------------
    File        : FlagsEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri May 15 15:41:08 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.FlagsEnum : 
    
    method static public logical IsA (piValueSum as int, poCheckEnum as EnumMember):
        define variable iPos as integer no-undo.
        define variable iVal as integer no-undo.
        define variable iCheckVal as integer no-undo.
        
        iCheckVal = poCheckEnum:Value.
                        
        do iPos = 1 to 32 while iVal eq 0:
            iVal = get-bits(iCheckVal, iPos, 1).
        end.
        
        return (get-bits(piValueSum, iPos - 1, 1) eq iVal).
    end method.

end class.