/** ------------------------------------------------------------------------
    File        : LockModeEnum
    Purpose     : Enumeration of record locking modes in ABL 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 20 11:56:34 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

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
    
    method static public LockModeEnum EnumFromValue(input piValue as integer):
        define variable oLockModeEnum as LockModeEnum no-undo.
        
        case piValue:
            when LockModeEnum:ShareLock:Value then oLockModeEnum = LockModeEnum:ShareLock.
            when LockModeEnum:ExclusiveLock:Value then oLockModeEnum = LockModeEnum:ExclusiveLock.
            when LockModeEnum:NoLock:Value then oLockModeEnum = LockModeEnum:NoLock. 
        end case.
        
        return oLockModeEnum.
    end method.

    method static public LockModeEnum EnumFromString(input pcName as character):
        define variable oLockModeEnum as LockModeEnum no-undo.
        
        case pcName:
            when LockModeEnum:ShareLock:ToString() then oLockModeEnum = LockModeEnum:ShareLock.
            when LockModeEnum:ExclusiveLock:ToString() then oLockModeEnum = LockModeEnum:ExclusiveLock.
            when LockModeEnum:NoLock:ToString() then oLockModeEnum = LockModeEnum:NoLock. 
        end case.
        
        return oLockModeEnum.
    end method.

end class.