/** ------------------------------------------------------------------------
    File        : WriteModeEnum
    Purpose     : Enumeration of WRITE-*() method modes.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Oct 12 14:17:26 EDT 2010
    Notes       : * Based on the ABL documentation
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.WriteModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.WriteModeEnum inherits EnumMember final:

    define static public property File as WriteModeEnum  no-undo get. private set.
    define static public property Stream as WriteModeEnum  no-undo get. private set.
    define static public property StreamHandle as WriteModeEnum  no-undo get. private set.
    define static public property Memptr as WriteModeEnum  no-undo get. private set.
    define static public property Handle as WriteModeEnum  no-undo get. private set.
    define static public property LongChar as WriteModeEnum  no-undo get. private set.
    
    constructor static WriteModeEnum():
        WriteModeEnum:File = new WriteModeEnum('File').
        WriteModeEnum:Stream = new WriteModeEnum('Stream').
        WriteModeEnum:StreamHandle = new WriteModeEnum('Stream-Handle').
        WriteModeEnum:Memptr = new WriteModeEnum('Memptr').
        WriteModeEnum:Handle = new WriteModeEnum('Handle').
        WriteModeEnum:LongChar = new WriteModeEnum('LongChar').
    end constructor.
    
    constructor public WriteModeEnum(input pcName as character):
        super (input pcName).
    end constructor.     

    method static public WriteModeEnum EnumFromString(pcWriteMode as character):
        define variable oMember as WriteModeEnum no-undo.
        
        case pcWriteMode:
            when WriteModeEnum:File:ToString()         then oMember = WriteModeEnum:File.
            when WriteModeEnum:Stream:ToString()       then oMember = WriteModeEnum:Stream.
            when WriteModeEnum:StreamHandle:ToString() then oMember = WriteModeEnum:StreamHandle.
            when WriteModeEnum:Memptr:ToString()       then oMember = WriteModeEnum:Memptr.
            when WriteModeEnum:Handle:ToString()       then oMember = WriteModeEnum:Handle.
            when WriteModeEnum:LongChar:ToString()     then oMember = WriteModeEnum:LongChar.
        end case.
                
        return oMember.   
    end method.
end class.