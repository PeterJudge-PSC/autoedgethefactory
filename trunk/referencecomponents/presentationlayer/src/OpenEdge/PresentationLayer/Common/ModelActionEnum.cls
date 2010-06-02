/*------------------------------------------------------------------------
    File        : ModelActionEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Oct 28 12:27:03 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.*.
using OpenEdge.Lang.*.

class OpenEdge.PresentationLayer.Common.ModelActionEnum final:
 
    define static public property None    as EnumMember no-undo get. private set.
    define static public property Fetch   as EnumMember no-undo get. private set.
    define static public property Add     as EnumMember no-undo get. private set.
    define static public property Delete  as EnumMember no-undo get. private set.
    define static public property Save    as EnumMember no-undo get. private set.
    define static public property Commit  as EnumMember no-undo get. private set.
    
    constructor static ModelActionEnum():
        ModelActionEnum:None = new EnumMember(1, 'none').
        ModelActionEnum:Fetch = new EnumMember(2, 'fetch').
        ModelActionEnum:Add = new EnumMember(3, 'add').
        ModelActionEnum:Delete = new EnumMember(4, 'delete').
        ModelActionEnum:Save = new EnumMember(5, 'save').
        ModelActionEnum:Commit = new EnumMember(6, 'commit').
    end constructor.

end class.