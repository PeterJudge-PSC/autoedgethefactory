/** ------------------------------------------------------------------------
    File        : IAppServerConnectionParameters
    Purpose     : Specialised connection parameters for AppServers
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 13 12:34:26 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */

interface OpenEdge.CommonInfrastructure.Common.IAppServerConnectionParameters:  /* inherits IConnectionParameters */
    
    define public property UserName as character no-undo get. set.
    define public property UserPassword as character no-undo get. set.
    define public property AppServerInfo as character no-undo get. set.
    
end interface.