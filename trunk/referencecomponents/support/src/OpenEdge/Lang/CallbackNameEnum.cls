/** ------------------------------------------------------------------------
    File        : CallbackNameEnum
    Purpose     : Enumeration of ABL callback types, including ProDataSets,
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 07 13:48:05 EDT 2009
    Notes       : * Taken from ABL documentation
  ----------------------------------------------------------------------*/
routine-level on error undo , throw.

using OpenEdge.Lang.CallbackNameEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.CallbackNameEnum final inherits EnumMember:
    
    /* Web Services */
    define public static property RequestHeader  as CallbackNameEnum no-undo get. private set.
    define public static property ResponseHeader as CallbackNameEnum no-undo get. private set.
    
    /* ProDataSet */
    define public static property BeforeFill     as CallbackNameEnum no-undo get. private set.
    define public static property AfterFill      as CallbackNameEnum no-undo get. private set.
    define public static property BeforeRowFill  as CallbackNameEnum no-undo get. private set.
    define public static property AfterRowFill   as CallbackNameEnum no-undo get. private set.
    define public static property RowCreate      as CallbackNameEnum no-undo get. private set.
    define public static property RowDelete      as CallbackNameEnum no-undo get. private set.
    define public static property RowUpdate      as CallbackNameEnum no-undo get. private set.
    define public static property FindFailed     as CallbackNameEnum no-undo get. private set.
    define public static property Syncronize     as CallbackNameEnum no-undo get. private set.
    
    /* Query */
    define public static property OffEnd         as CallbackNameEnum no-undo get. private set.
    
    constructor static CallbackNameEnum():
        CallbackNameEnum:RequestHeader = new CallbackNameEnum('request-header').
        CallbackNameEnum:ResponseHeader = new CallbackNameEnum('response-header').
        CallbackNameEnum:BeforeFill = new CallbackNameEnum('before-fill').
        CallbackNameEnum:AfterFill = new CallbackNameEnum('after-fill').
        CallbackNameEnum:BeforeRowFill = new CallbackNameEnum('before-row-fill').
        CallbackNameEnum:AfterRowFill = new CallbackNameEnum('after-row-fill').
        CallbackNameEnum:RowCreate = new CallbackNameEnum('row-create').
        CallbackNameEnum:RowDelete = new CallbackNameEnum('row-delete').
        CallbackNameEnum:RowUpdate = new CallbackNameEnum('row-update').
        CallbackNameEnum:FindFailed = new CallbackNameEnum('find-failed').
        CallbackNameEnum:Syncronize = new CallbackNameEnum('syncronize').
        CallbackNameEnum:OffEnd = new CallbackNameEnum('OFF-END').            
    end constructor.

	constructor public CallbackNameEnum( input pcName as character ):
		super (input pcName).
	end constructor.
    
end class.