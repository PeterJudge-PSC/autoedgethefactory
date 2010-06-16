/** ------------------------------------------------------------------------
    File        : TableRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:33:56 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequestCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest inherits ServiceMessage
        implements IFetchRequest, IServiceRequest: 
    
    define public property TableRequests as ITableRequestCollection no-undo get. private set. 

    constructor public FetchRequest(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Fetch).
    end constructor.

    constructor public FetchRequest(input pcMessageId as character,
                                    input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Fetch).
        
        TableRequests = new ITableRequestCollection().
    end constructor.
    
    method public ITableRequest GetTableRequest(input pcTableName as character):
        define variable oTableRequest as ITableRequest no-undo.
        define variable iIndex as integer no-undo.
        
        iIndex = TableRequests:IndexOf(new TableRequest(pcTableName)).
        
        if iIndex gt 0 then
            oTableRequest = cast(TableRequests:Get(iIndex), ITableRequest).
        
        return oTableRequest.  
    end method.
    
end class.