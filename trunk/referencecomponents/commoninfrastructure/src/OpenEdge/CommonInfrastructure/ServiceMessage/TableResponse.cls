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

using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse inherits TableContext
            implements ITableResponse: 

	define public property HasError as logical no-undo get. set. 
	define public property ErrorText as character no-undo get. set. 

	constructor public TableResponse ( input pcTableName as character ):
		super (input pcTableName).
	end constructor.
	 
end class.