/*------------------------------------------------------------------------
    File        : ErrorSeverityEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jun 26 14:23:12 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.


class OpenEdge.Core.System.ErrorSeverityEnum  inherits FlagsEnum :
    
    define static public property Default  as EnumMember no-undo get. private set.
    define static public property None     as EnumMember no-undo get. private set.
    define static public property Fatal    as EnumMember no-undo get. private set.
    define static public property Critical as EnumMember no-undo get. private set.
    define static public property Error    as EnumMember no-undo get. private set.
    define static public property Warning  as EnumMember no-undo get. private set.
    define static public property Message  as EnumMember no-undo get. private set.
    define static public property Info     as EnumMember no-undo get. private set.
    define static public property Debug    as EnumMember no-undo get. private set.
    
    constructor static ErrorSeverityEnum():
        ErrorSeverityEnum:None = new EnumMember(1, 'None').
        ErrorSeverityEnum:Fatal = new EnumMember(2, 'Fatal').
        ErrorSeverityEnum:Critical = new EnumMember(4, 'Critical').
        ErrorSeverityEnum:Error = new EnumMember(8, 'Error').
        ErrorSeverityEnum:Warning = new EnumMember(16, 'Warning').
        ErrorSeverityEnum:Message = new EnumMember(32, 'Message').
        ErrorSeverityEnum:Info = new EnumMember(64, 'Info').
        ErrorSeverityEnum:Debug  = new EnumMember(128, 'Debug').
        
        ErrorSeverityEnum:Default = ErrorSeverityEnum:Error.
    end constructor.

end class.