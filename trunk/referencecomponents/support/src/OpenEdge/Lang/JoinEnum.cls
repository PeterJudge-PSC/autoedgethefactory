/*------------------------------------------------------------------------
    File        : JoinEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Mar 12 15:03:46 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.JoinEnum final:
     
    define public static property None as EnumMember no-undo get. private set.
    define public static property And  as EnumMember no-undo get. private set.
    define public static property Or   as EnumMember no-undo get. private set.
    define public static property Not  as EnumMember no-undo get. private set.
    
    constructor static JoinEnum():
        JoinEnum:None = new EnumMember('none').
        JoinEnum:And  = new EnumMember('and').
        JoinEnum:Or   = new EnumMember('or').
        JoinEnum:Not  = new EnumMember('not').
    end constructor.
    
end class.