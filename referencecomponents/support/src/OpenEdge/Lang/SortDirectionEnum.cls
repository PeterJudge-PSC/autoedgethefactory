/*------------------------------------------------------------------------
    File        : SortDirectionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 12 17:14:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.SortDirectionEnum final: 
    
    define public static property Default    as EnumMember no-undo get. private set.
    define public static property Ascending  as EnumMember no-undo get. private set.
    define public static property Descending as EnumMember no-undo get. private set.
    
    constructor static SortDirectionEnum():
        /* Values taken from INDEX-INFORMATION() method doc, for easy ABL conversion.
           Note that they start at ZERO not 1. */
        SortDirectionEnum:Ascending = new EnumMember(0, 'Ascending').
        SortDirectionEnum:Descending = new EnumMember(1, 'Descending').
        
        SortDirectionEnum:Default = SortDirectionEnum:Ascending.        
    end constructor.
    
    method static public EnumMember EnumFromString(pcSortDirection as character):
        define variable oMember as EnumMember no-undo.
        
        case pcSortDirection:
            when SortDirectionEnum:Ascending:ToString() then oMember = SortDirectionEnum:Ascending.
            when SortDirectionEnum:Descending:ToString() then oMember = SortDirectionEnum:Descending.
        end case.
        
        return oMember.
    end method.

    method static public EnumMember EnumFromValue(piSortDirection as integer):
        define variable oMember as EnumMember no-undo.
        
        case piSortDirection:
            when SortDirectionEnum:Ascending:Value then oMember = SortDirectionEnum:Ascending.
            when SortDirectionEnum:Descending:Value then oMember = SortDirectionEnum:Descending.
        end case.
                
        return oMember.
    end method.
                
end class.