/*------------------------------------------------------------------------
    File        : IService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Apr 15 14:59:18 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.IService /* inherits IComponent */:  
    /** (mandatory) Stores a reference to the session's Service Manager */
    define public property ServiceManager as IServiceManager no-undo get.
    
end interface.