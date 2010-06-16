/*------------------------------------------------------------------------
    File        : AgentConnection
    Purpose     : 
    Syntax      : 
    Description : AgentConnection object : this object lives for the lifespan of 
                  an AppServer connection (stateless AppServer).
    Author(s)   : pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer connect/disconnect
                    procedures.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.AgentConnection.
using OpenEdge.Lang.Collections.Map.

class OpenEdge.Lang.AgentConnection:
    /* A collection of user-defined properties */
    define public property ConnectionProperties as Map no-undo get. private set.
    
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
               ConnectionProperties = new Map().
    end constructor.
    
end class.