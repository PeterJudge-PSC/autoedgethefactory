/** ------------------------------------------------------------------------
    File        : TableRequestTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    @author hdaniels
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequestTypeEnum. 
using OpenEdge.Lang.EnumMember. 

class OpenEdge.CommonInfrastructure.ServiceMessage.TableRequestTypeEnum final inherits EnumMember: 
    
    define public static property First    as TableRequestTypeEnum no-undo get. private set.
    define public static property Next     as TableRequestTypeEnum no-undo get. private set.
    define public static property Prev     as TableRequestTypeEnum no-undo get. private set.
    define public static property Last     as TableRequestTypeEnum no-undo get. private set.
    /** position request resort/reopen to current key */
    define public static property Position as TableRequestTypeEnum no-undo get. private set.
    /** search in resultset  */
    define public static property Search   as TableRequestTypeEnum no-undo get. private set.
    /** For child tables = default defined by dataset relation (to not use All on a child 
        requires advanced data request management). Logically this is possibly more of a 
        jointype, but it will never conflict with the other options */        
    define public static property All      as TableRequestTypeEnum no-undo get. private set.

    constructor static TableRequestTypeEnum():
         TableRequestTypeEnum:First    = new TableRequestTypeEnum('first').
         TableRequestTypeEnum:Next     = new TableRequestTypeEnum('next').
         TableRequestTypeEnum:Prev     = new TableRequestTypeEnum('prev').
         TableRequestTypeEnum:Last     = new TableRequestTypeEnum('last'). 
         TableRequestTypeEnum:Position = new TableRequestTypeEnum('position').        
         TableRequestTypeEnum:Search   = new TableRequestTypeEnum('search').
         TableRequestTypeEnum:All      = new TableRequestTypeEnum('all').        
    end constructor.

    constructor public TableRequestTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
        
end class.