/** ------------------------------------------------------------------------
    File        : TableResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 20:48:33 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse
            implements ITableResponse:
    
    /** (mandatory) The name of the table */  
    define property TableName as character no-undo get. private set.
    
    /** Whether the service request resulted in an error or not.
        Defaults to false.  */
    define public property HasError as logical no-undo get. set.
    
    /** The error text associated with the error, if any. */
    define public property ErrorText as character no-undo get. set.

    /** The ITableContext (page size retrieved, etc) for this response, if any.
        Typically only Fetch actions will have one of these; Save not so much.  */
    define public property TableContext as ITableContext no-undo get. set.

	constructor public TableResponse ( input pcTableName as character ):
		super().
		
		TableName = pcTableName.
	end constructor.
		 
end class.