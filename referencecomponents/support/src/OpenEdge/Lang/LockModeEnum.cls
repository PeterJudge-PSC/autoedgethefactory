/** ------------------------------------------------------------------------
    File        : LockModeEnum
    Purpose     : Enumeration of record locking modes in ABL 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:56:34 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Lang.LockModeEnum final inherits EnumMember: 

    define public static property Default       as LockModeEnum no-undo get. private set.
    define public static property ShareLock     as LockModeEnum no-undo get. private set.
    define public static property ExclusiveLock as LockModeEnum no-undo get. private set.
    define public static property NoLock        as LockModeEnum no-undo get. private set.
        
    constructor static LockModeEnum():
        LockModeEnum:ShareLock = new LockModeEnum(share-lock, 'share-lock').
        LockModeEnum:ExclusiveLock = new LockModeEnum(exclusive-lock, 'exclusive-lock').
        LockModeEnum:NoLock = new LockModeEnum(no-lock, 'no-lock').
        
        /* ABL Default is ShareLock, but NoLock preferred here */                              
        LockModeEnum:Default = LockModeEnum:NoLock.
    end constructor.

    constructor public LockModeEnum ( input piValue as integer, input pcName as character ):
        super (input piValue, input pcName).
    end constructor.

end class.