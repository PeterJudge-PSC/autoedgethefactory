/*------------------------------------------------------------------------
    File        : CallbackNameEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 07 13:48:05 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo , throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.CallbackNameEnum final:
    
    /* Web Services */
    define public static property RequestHeader  as EnumMember no-undo get. private set.
    define public static property ResponseHeader as EnumMember no-undo get. private set.
    
    /* ProDataSet */
    define public static property BeforeFill     as EnumMember no-undo get. private set.
    define public static property AfterFill      as EnumMember no-undo get. private set.
    define public static property BeforeRowFill  as EnumMember no-undo get. private set.
    define public static property AfterRowFill   as EnumMember no-undo get. private set.
    define public static property RowCreate      as EnumMember no-undo get. private set.
    define public static property RowDelete      as EnumMember no-undo get. private set.
    define public static property RowUpdate      as EnumMember no-undo get. private set.
    define public static property FindFailed     as EnumMember no-undo get. private set.
    define public static property Syncronize     as EnumMember no-undo get. private set.
    
    /* Query */
    define public static property OffEnd         as EnumMember no-undo get. private set.
    
    constructor static CallbackNameEnum():
        CallbackNameEnum:RequestHeader = new EnumMember(1, 'request-header').
        CallbackNameEnum:ResponseHeader = new EnumMember(2, 'response-header').
        CallbackNameEnum:BeforeFill = new EnumMember(3, 'before-fill').
        CallbackNameEnum:AfterFill = new EnumMember(4, 'after-fill').
        CallbackNameEnum:BeforeRowFill = new EnumMember(5, 'before-row-fill').
        CallbackNameEnum:AfterRowFill = new EnumMember(6, 'after-row-fill').
        CallbackNameEnum:RowCreate = new EnumMember(7, 'row-create').
        CallbackNameEnum:RowDelete = new EnumMember(8, 'row-delete').
        CallbackNameEnum:RowUpdate = new EnumMember(9, 'row-update').
        CallbackNameEnum:FindFailed = new EnumMember(10, 'find-failed').
        CallbackNameEnum:Syncronize = new EnumMember(11, 'syncronize').
        CallbackNameEnum:OffEnd = new EnumMember(12, 'OFF-END').            
        
    end constructor.
    
end class.