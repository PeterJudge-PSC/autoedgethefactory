/*------------------------------------------------------------------------
    File        : IOModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 20 11:22:58 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.


class OpenEdge.Lang.IOModeEnum final: 

    define public static property Default                   as EnumMember no-undo get. private set.                                 
    define public static property Input                     as EnumMember no-undo get. private set.
    define public static property Output                    as EnumMember no-undo get. private set.
    define public static property OutputAppend              as EnumMember no-undo get. private set.
    define public static property InputOutput               as EnumMember no-undo get. private set.
    define public static property TableHandle               as EnumMember no-undo get. private set.
    define public static property TableHandleByReference    as EnumMember no-undo get. private set.
    define public static property DatasetHandle             as EnumMember no-undo get. private set.
    define public static property DatasetHandleByReference  as EnumMember no-undo get. private set.
    define public static property Return                    as EnumMember no-undo get. private set.
    
    constructor static IOModeEnum():
        IOModeEnum:Input = new EnumMember(1, 'Input').
        IOModeEnum:Output = new EnumMember(2,'Output').
        IOModeEnum:OutputAppend = new EnumMember(3, 'Output-Append').
        IOModeEnum:InputOutput = new EnumMember(4, 'Input-Output').
        IOModeEnum:TableHandle = new EnumMember(5, 'Table-Handle').
        IOModeEnum:TableHandleByReference = new EnumMember(6, 'Table-Handle-By-Reference').
        IOModeEnum:DatasetHandle = new EnumMember(7, 'Dataset-Handle').
        IOModeEnum:DatasetHandleByReference = new EnumMember(8, 'Dataset-Handle-By-Reference').
        IOModeEnum:Return = new EnumMember(9, 'Return').
        
        IOModeEnum:Default = IOModeEnum:Input.
    end constructor.
    
end class.