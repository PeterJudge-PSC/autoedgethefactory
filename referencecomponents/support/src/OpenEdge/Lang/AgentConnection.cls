/*------------------------------------------------------------------------
    File        : AgentConnection
    Purpose     : 
    Syntax      : 
    Description : AgentConnection object : this object lives for the lifespan of 
                  an AppServer connection (stateless AppServer).
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer connect/disconnect
                    procedures.
                  * Note that this is meaninless for StateFree AppServers.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.AgentConnection.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IMap.

class OpenEdge.Lang.AgentConnection:
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property ConnectionProperties as IMap no-undo get. private set.
    
    define static public property Instance as AgentConnection no-undo
        get():
            if not valid-object(Instance) then
                Instance = new AgentConnection().
            return Instance.
        end get.
        private set.
    
    define public property Id as char no-undo get. private set.
    
    constructor private AgentConnection():
        assign this-object:Id = guid(generate-uuid)
               ConnectionProperties = new Map()
               ActiveSince = now.
    end constructor.
    
end class.