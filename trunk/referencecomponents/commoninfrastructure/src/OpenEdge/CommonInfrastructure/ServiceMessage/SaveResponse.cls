/** ------------------------------------------------------------------------
    File        : SaveResponse
    Purpose     : General save response class 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 15:09:22 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponseCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.

using OpenEdge.Lang.Collections.IIterator.

class OpenEdge.CommonInfrastructure.ServiceMessage.SaveResponse inherits ServiceResponse
        implements ISaveResponse:
    
	/** A collection of individual table responses for this larger request */ 
    define public property TableResponses as ITableResponseCollection no-undo get. private set.
    
    /**  Constructor to create a request from a response, so we can tie 'em together again. */
	constructor public SaveResponse(input poServiceRequest as ISaveRequest):
		super (input cast(poServiceRequest, IServiceRequest)).
		
        TableResponses = new ITableResponseCollection().                      
	end constructor.
    
    destructor SaveResponse():
        TableResponses:Clear().
    end destructor.
    
    /** Pre-populates the table response collection from the request's tablerequests */
    method public void InitTableResponseFromRequest(input poRequestCollection as ITableRequestCollection):
        define variable oTableResponse as ITableResponse no-undo.
        define variable oTableRequest as ITableRequest no-undo.
        define variable oIterator as IIterator no-undo.
        
        oIterator = poRequestCollection:KeySet:Iterator().
        do while oIterator:HasNext():
            oTableRequest = cast(oIterator:Next(), ITableRequest).
            oTableResponse = new TableResponse(oTableRequest:TableName).
            oTableResponse:TableContext = CreateContextFromRequest(oTableRequest).
            TableResponses:Put(oTableRequest:TableName, oTableResponse).
        end.
    end method.
    
    method protected ITableContext CreateContextFromRequest(input poTableRequest as ITableRequest):
        @todo(task="implement", action="").
    end method.
    
end class.