/*------------------------------------------------------------------------
    File        : AgentRequest
    Purpose     : 
    Syntax      : 
    Description : AgentRequest object : this object lives for the lifespan of 
                  an AppServer
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer activate/deactivate
                    procedures.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.AgentRequest.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IMap.

class OpenEdge.Lang.AgentRequest:
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property RequestProperties as IMap no-undo get. private set.
    
    define static public property Instance as AgentRequest no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new AgentRequest().
            return Instance.
        end get.
        private set.
    
    define public property Id as char no-undo get. private set.
    
    constructor private AgentRequest():
        assign this-object:Id = guid(generate-uuid)
               RequestProperties = new Map()
               ActiveSince = now.
    end constructor.

end class.