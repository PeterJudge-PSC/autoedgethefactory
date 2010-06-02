/*------------------------------------------------------------------------
    File        : QueryElementEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Sep 02 15:01:39 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

class OpenEdge.Core.System.QueryElementEnum final inherits FlagsEnum:
    
    define public static property Buffer    as EnumMember no-undo get. private set.
    define public static property Join      as EnumMember no-undo get. private set.
    define public static property Filter    as EnumMember no-undo get. private set.
    define public static property Sort      as EnumMember no-undo get. private set.
    
    constructor static QueryElementEnum():
        QueryElementEnum:Buffer = new EnumMember(1).
        QueryElementEnum:Join = new EnumMember(2).
        QueryElementEnum:Filter = new EnumMember(4).
        QueryElementEnum:Sort = new EnumMember(8).
    end constructor.
    
end class.