/** ------------------------------------------------------------------------
    File        : IConnectionManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 09:58:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.CommonInfrastructure.Common.IConnectionManager:
    
    /** set of connected services in this session (db, appserver, etc) */
    define public property ConnectedServices as IMap no-undo get.
    
end interface.