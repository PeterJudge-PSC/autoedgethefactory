/*------------------------------------------------------------------------
    File        : CompareStrengthEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 20 13:57:05 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.CompareStrengthEnum  final : 

    define public static property Raw               as EnumMember no-undo get. private set.
    define public static property CaseSensitive     as EnumMember no-undo get. private set.
    define public static property CaseInsensitive   as EnumMember no-undo get. private set.
    define public static property Caps              as EnumMember no-undo get. private set.
    define public static property Primary           as EnumMember no-undo get. private set.
    define public static property Secondary         as EnumMember no-undo get. private set.
    define public static property Tertiary          as EnumMember no-undo get. private set.
    define public static property Quaternary        as EnumMember no-undo get. private set.
    
    constructor static CompareStrengthEnum():
        CompareStrengthEnum:Raw = new EnumMember(1, 'RAW').
        CompareStrengthEnum:CaseSensitive = new EnumMember(2, 'CASE-SENSITIVE').
        CompareStrengthEnum:CaseInsensitive = new EnumMember(3, 'CASE-INSENSITIVE').
        CompareStrengthEnum:Caps = new EnumMember(4, 'CAPS').
        CompareStrengthEnum:Primary = new EnumMember(5, 'PRIMARY').
        CompareStrengthEnum:Secondary = new EnumMember(6, 'SECONDARY').
        CompareStrengthEnum:Tertiary = new EnumMember(7, 'TERTIARY').
        CompareStrengthEnum:Quaternary = new EnumMember(8, 'QUATERNARY').
    end constructor.
    
end class.
