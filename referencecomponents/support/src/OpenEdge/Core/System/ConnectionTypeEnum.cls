/** ------------------------------------------------------------------------
    File        : ConnectionTypeEnum
    Purpose     : Enumerates the types of connections the AVM can make
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 07 16:25:19 EST 2011
    Notes       : * Roughly equivalent to the ABL CONNECT method and statements
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.ConnectionTypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.ConnectionTypeEnum inherits EnumMember: 

    define static public property AppServer as ConnectionTypeEnum no-undo get. private set.
    define static public property Database as ConnectionTypeEnum no-undo get. private set.
    define static public property Socket as ConnectionTypeEnum no-undo get. private set.
    define static public property WebService as ConnectionTypeEnum no-undo get. private set.
    
    constructor static ConnectionTypeEnum():
        ConnectionTypeEnum:AppServer = new ConnectionTypeEnum('AppServer').
        ConnectionTypeEnum:Database = new ConnectionTypeEnum('Database').
        ConnectionTypeEnum:Socket = new ConnectionTypeEnum('Socket').
        ConnectionTypeEnum:WebService = new ConnectionTypeEnum('WebService').
    end constructor.
    
    constructor public ConnectionTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.