/*------------------------------------------------------------------------
    File        : Enum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 21 10:22:32 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.Enum.
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Lang.Enum:
    define static private temp-table Members no-undo
        field Enum       as Object  /* Class */
        field EnumMember as Object  /* EnumMember */
        index idx1 as primary unique Enum EnumMember.
    
    method static protected EnumMember AddMember(poEnumType as class Class, piValue as int):
        return AddMember(poEnumType, piValue, ?).
    end method.
    
    method static protected EnumMember AddMember(poEnumType as class Class, pcString as char):
        return AddMember(poEnumType, ?, pcString).
    end method.
    
    method static protected EnumMember AddMember(poEnumType as class Class, piValue as int, pcString as char):
        define variable oMember as EnumMember no-undo.
        define buffer lbMembers for Members.
        
        oMember = new EnumMember(piValue, pcString).
        
        create lbMembers.
        assign lbMembers.Enum = poEnumType
               lbMembers.EnumMember = oMember.
        return oMember.
    end method.
    
    method static public logical IsMember(poEnumType as class Class, poEnumMember as EnumMember):
        define buffer lbMembers for Members.
                
        return can-find(lbMembers where 
                        lbMembers.Enum = poENumType and 
                        lbMembers.EnumMember = poEnumMember). 
    end method.
    
end class.