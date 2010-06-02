/*------------------------------------------------------------------------
    File        : QueryBlockTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 07 12:21:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.QueryBlockTypeEnum final : 

    define public static property Default   as EnumMember no-undo get. private set.
    define public static property For       as EnumMember no-undo get. private set.
    define public static property Preselect as EnumMember no-undo get. private set.
        
    constructor static QueryBlockTypeEnum():
        QueryBlockTypeEnum:For = new EnumMember(1, 'for').
        QueryBlockTypeEnum:Preselect = new EnumMember(2, 'preselect').
        
        /* Using Preselect instead of For since I'm assuming that these
           queries are going to be used for binding to a ProBindingSource,
           which prefers a preselect. */
        QueryBlockTypeEnum:Default = QueryBlockTypeEnum:Preselect.        
    end constructor.
                
end class.