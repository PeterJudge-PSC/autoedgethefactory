/** ------------------------------------------------------------------------
    File        : ABLSession
    Purpose     : 
    Syntax      : 
    Description : ABLSession object : this object lives for the lifespan of 
                  an AVM Session. 
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.ABLSession.
using OpenEdge.Lang.Collections.Map.
using Progress.Lang.Class. 

class OpenEdge.Lang.ABLSession:
    
    define public property Id as char no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property SessionProperties as Map no-undo get. private set.
    
    define static public property Instance as ABLSession no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new ABLSession().
            
            return Instance.
        end get.
        private set.
    
    constructor private ABLSession():
        this-object:Id = guid(generate-uuid).
        
        SessionProperties = new Map().
    end constructor.
end class.