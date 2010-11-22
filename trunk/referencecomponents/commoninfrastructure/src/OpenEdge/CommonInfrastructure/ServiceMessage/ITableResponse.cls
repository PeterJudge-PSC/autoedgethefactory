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
using OpenEdge.Lang.Collections.IMap.

interface OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse:
    
    /** (mandatory) The name of the table */  
    define property TableName as char no-undo get.
    
    /** Whether the service request resulted in an error or not. */
    define public property HasError as logical no-undo get. set.
    
    /** The error texts associated with the request, if any.
        There's an entry in the map for each row that has an error,
        keyed on the RowKey. */
    define public property ErrorText as IMap no-undo get.
    
    /** The ITableContext (page size retrieved, etc) for this response, if any.
        Typically only Fetch actions will have one of these; Save not so much.  */
    define public property TableContext as ITableContext no-undo get. set.
    
end interface.