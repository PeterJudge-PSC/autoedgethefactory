/** ------------------------------------------------------------------------
    File        : ITableResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 14:05:55 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
  
interface OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse /* inherits ITableContext */:
    
    define public property HasError as logical no-undo get. set.
    define public property ErrorText as character no-undo get. set.
    
end interface.