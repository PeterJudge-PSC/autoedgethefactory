/** ------------------------------------------------------------------------
    File        : IUserContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author      : pjudge
    Created     : Mon Jun 07 14:26:49 EDT 2010
    Notes       : 
  --------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.Common.IUserContext.

interface OpenEdge.CommonInfrastructure.Common.IUserContext:
    /** Unique identifier for the client session */
    define public property ClientSessionId as character no-undo get.
end interface.