/*------------------------------------------------------------------------
    File        : ByteOrderEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Dec 21 09:40:59 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.*.

class OpenEdge.Lang.ByteOrderEnum final:

    define public static property Default       as EnumMember no-undo get. private set.
    define public static property HostByteOrder as EnumMember no-undo get. private set.
    define public static property BigEndian     as EnumMember no-undo get. private set.
    define public static property LittleEndian  as EnumMember no-undo get. private set.
    
    constructor static ByteOrderEnum():
        ByteOrderEnum:HostByteOrder = new EnumMember(host-byte-order, 'host-byte-order').
        ByteOrderEnum:BigEndian = new EnumMember(big-endian, 'big-endian').
        ByteOrderEnum:LittleEndian = new EnumMember(little-endian, 'little-endian').
        
        ByteOrderEnum:Default = ByteOrderEnum:HostByteOrder.
    end constructor.
    
    @todo(task="this make sense?").
    method static public EnumMember EnumFromString(pcByteOrder as char):
        define variable oMember as EnumMember no-undo.
        
        case pcByteOrder:
            when ByteOrderEnum:HostByteOrder:ToString() then oMember = ByteOrderEnum:HostByteOrder.
            when ByteOrderEnum:BigEndian:ToString() then oMember = ByteOrderEnum:BigEndian.
            when ByteOrderEnum:LittleEndian:ToString() then oMember = ByteOrderEnum:LittleEndian.
        end case.
        
        return oMember.        
    end method.
    
    method static public EnumMember EnumFromValue(piByteOrder as integer):
        define variable oMember as EnumMember no-undo.
        
        case piByteOrder:
            when ByteOrderEnum:HostByteOrder:Value then oMember = ByteOrderEnum:HostByteOrder.
            when ByteOrderEnum:BigEndian:Value then oMember = ByteOrderEnum:BigEndian.
            when ByteOrderEnum:LittleEndian:Value then oMember = ByteOrderEnum:LittleEndian.
        end case.
        
        return oMember.
    end method.

end class.