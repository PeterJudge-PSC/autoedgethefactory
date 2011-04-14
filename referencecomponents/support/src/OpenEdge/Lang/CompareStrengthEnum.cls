/** ------------------------------------------------------------------------
    File        : CompareStrengthEnum
    Purpose     : Enumeration of strengths for the COMPARE statement 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 13:57:05 EDT 2009
    Notes       : * Taken from ABL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.CompareStrengthEnum final inherits EnumMember: 

    define public static property Raw               as CompareStrengthEnum no-undo get. private set.
    define public static property CaseSensitive     as CompareStrengthEnum no-undo get. private set.
    define public static property CaseInsensitive   as CompareStrengthEnum no-undo get. private set.
    define public static property Caps              as CompareStrengthEnum no-undo get. private set.
    define public static property Primary           as CompareStrengthEnum no-undo get. private set.
    define public static property Secondary         as CompareStrengthEnum no-undo get. private set.
    define public static property Tertiary          as CompareStrengthEnum no-undo get. private set.
    define public static property Quaternary        as CompareStrengthEnum no-undo get. private set.
    
    constructor static CompareStrengthEnum():
        CompareStrengthEnum:Raw = new CompareStrengthEnum(1, 'RAW').
        CompareStrengthEnum:CaseSensitive = new CompareStrengthEnum(2, 'CASE-SENSITIVE').
        CompareStrengthEnum:CaseInsensitive = new CompareStrengthEnum(3, 'CASE-INSENSITIVE').
        CompareStrengthEnum:Caps = new CompareStrengthEnum(4, 'CAPS').
        CompareStrengthEnum:Primary = new CompareStrengthEnum(5, 'PRIMARY').
        CompareStrengthEnum:Secondary = new CompareStrengthEnum(6, 'SECONDARY').
        CompareStrengthEnum:Tertiary = new CompareStrengthEnum(7, 'TERTIARY').
        CompareStrengthEnum:Quaternary = new CompareStrengthEnum(8, 'QUATERNARY').
    end constructor.

    constructor public CompareStrengthEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.
    
end class.
