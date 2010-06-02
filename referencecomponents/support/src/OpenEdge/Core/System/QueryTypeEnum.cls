/*------------------------------------------------------------------------
    File        : QueryTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 07 10:27:16 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

class OpenEdge.Core.System.QueryTypeEnum final:
    define public static property Default as EnumMember no-undo get. private set.
    define public static property Each    as EnumMember no-undo get. private set.
    define public static property First   as EnumMember no-undo get. private set.
    define public static property Last    as EnumMember no-undo get. private set.
    
    constructor static QueryTypeEnum():
        QueryTypeEnum:Each  = new EnumMember(1, 'each').
        QueryTypeEnum:First = new EnumMember(2, 'first').
        QueryTypeEnum:Last  = new EnumMember(3, 'last').
        
        QueryTypeEnum:Default = QueryTypeEnum:Each.
    end constructor.
    
    method public static EnumMember EnumFromString(pcQueryType as char):        
        define variable oMember as EnumMember no-undo.
        
        case pcQueryType:
            when QueryTypeEnum:Each:ToString() then oMember = QueryTypeEnum:Each. 
            when QueryTypeEnum:First:ToString() then oMember = QueryTypeEnum:First.
            when QueryTypeEnum:Last:ToString() then oMember = QueryTypeEnum:Last.
        end.
        
        return oMember.
    end method.
end class.