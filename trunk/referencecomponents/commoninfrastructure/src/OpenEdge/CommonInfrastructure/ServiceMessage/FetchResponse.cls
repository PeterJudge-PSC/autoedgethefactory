/** ------------------------------------------------------------------------
    File        : FetchResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:16:14 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContextCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessage.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse inherits ServiceMessage
        implements IFetchResponse, IServiceResponse: 
                        
    define public property TableResponses as ITableContextCollection no-undo get. private set. 

    constructor public FetchResponse(input pcService as character):
        super(pcService, ServiceMessageActionEnum:Fetch).
    end constructor.
    
    constructor public FetchResponse(input pcMessageId as character,
                                     input pcService as character):
        super(pcMessageId, pcService, ServiceMessageActionEnum:Fetch).
        
        TableResponses = new ITableContextCollection().
    end constructor.

    method public ITableContext GetTableContext(input pcTableName as character):
        define variable oTableContext as ITableContext no-undo.
        define variable iIndex as integer no-undo.
        
        iIndex = TableResponses:IndexOf(new TableContext(pcTableName)).
        
        if iIndex gt 0 then
            oTableContext = cast(TableResponses:Get(iIndex), ITableContext).
        
        return oTableContext.
    end method.

end class.