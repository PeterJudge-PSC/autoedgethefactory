/*------------------------------------------------------------------------
    File        : LockModeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 20 11:56:34 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.*.
using OpenEdge.Lang.*.

class OpenEdge.Core.System.LockModeEnum final : 

    define public static property Default       as EnumMember no-undo get. private set.
    define public static property ShareLock     as EnumMember no-undo get. private set.
    define public static property ExclusiveLock as EnumMember no-undo get. private set.
    define public static property NoLock        as EnumMember no-undo get. private set.
        
    constructor static LockModeEnum():
        LockModeEnum:ShareLock = new EnumMember(share-lock, 'share-lock').
        LockModeEnum:ExclusiveLock = new EnumMember(exclusive-lock, 'exclusive-lock').
        LockModeEnum:NoLock = new EnumMember(no-lock, 'no-lock').
        
        /* ABL Default is ShareLock, but NoLock preferred here */                              
        LockModeEnum:Default = LockModeEnum:NoLock.
    end constructor.

end class.