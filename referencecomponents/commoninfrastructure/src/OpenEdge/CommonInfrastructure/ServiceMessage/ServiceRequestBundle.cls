/** -----------------------------------------------------------------------
    File        : ServiceRequestBundle
    Purpose     : A collection of requests and logic for dealing with their responses
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 26 15:03:13 EDT 2010
    Notes       : * This is the common
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequestBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IServiceMessageManager.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.System.InvalidValueSpecifiedError.

using OpenEdge.Lang.Assert.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.

using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceRequestBundle
        implements IServiceRequestBundle:
    
    define protected property ServiceMessages as IServiceMessageCollection no-undo get. private set.
    
    /** (mandatory) The ServiceMessageManager  managing the requests in this bundle. */
    define public property ServiceMessageManager as IServiceMessageManager no-undo get. private set.
    /** (mandatory) The object making the requests contained in this bundle */
    define public property Requestor as IMessageRequestor no-undo get. private set.
    /** (mandatory) The ServiceMessageActionEnum  type of action this bundle is performing */
    define public property ActionType as ServiceMessageActionEnum no-undo get. private set.
    /* (derived) The number of IServiceRequests that have outstanding requests */
    define public property OutstandingRequests as integer no-undo get. protected set.
    /* (derived) The total number of IServiceRequests this bundle is managing */
    define public property TotalRequests as integer no-undo 
        get():
            return ServiceMessages:Size.
        end get.    /* readonly; derived */
    
    destructor public ServiceRequestBundle():
        ServiceMessages:Clear().
    end destructor.
    
    constructor public ServiceRequestBundle(input poServiceMessageManager as IServiceMessageManager,
                                            input poMessageRequestor as IMessageRequestor,
                                            input poActionType as ServiceMessageActionEnum):
        
        Assert:ArgumentNotNull(poMessageRequestor, 'Requesting component').
        Assert:ArgumentNotNull(poActionType, 'Message type').
        
        assign Requestor = poMessageRequestor
               ActionType = poActionType
               ServiceMessageManager = poServiceMessageManager
               ServiceMessages = new IServiceMessageCollection().
    end constructor.
    
    /** Add a request to an existing bundle
    
        @param poRequest The request to add to the bundle   */    
    method public void AddRequest(input poRequest as IServiceRequest):
        Assert:ArgumentNotNull(poRequest, 'Service request message').
        
        if not cast(poRequest, IServiceMessage):ActionType:Equals(this-object:ActionType) then
            undo, throw new ArgumentError(
                        'Service message not of type ' + this-object:ActionType:ToString(),
                        'poMessage').
        
        ServiceMessages:Add(poRequest).
    end method.

    /** Remove a request from the bundle.
        
        @param poRequest The request to remove       */    
    method public void RemoveRequest(poRequest as IServiceRequest):
        ServiceMessages:Remove(poRequest).
    end method.

    /** A response has been received for a given message (by ID). The
        ServiceMessageManager informs the message consumer of the response.
        
        @param pcMessageId The unique identifier of the message.    */
    method public void ResponseReceived(pcMessageId as character).
        /* Decrement after call in case of error */
        OutstandingRequests = OutstandingRequests - 1.
        
        if OutstandingRequests eq 0 then
            Requestor:RequestCompleted(this-object).
        
        catch eApplError as ApplicationError:
            /* If something goes wrong, we need to mark the request as still outstanding,
               before throwing the error further. */
            OutstandingRequests = OutstandingRequests + 1.
            
            undo, throw eApplError.
        end catch.
    end method.
    
    /** Execute all of a bundle's requests. */        
    method public void ExecuteBundle():
        define variable oRequestByAdapter as IMap no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oRequest as IServiceRequest no-undo.
        define variable oString as String no-undo.
        define variable oServiceAdapter as IServiceAdapter no-undo.
        define variable cServiceAdapter as character no-undo.
        
        /* Group all together requests by service, which allows us to make one 
           call per service (via the service adapter). */
        oRequestByAdapter = new TypedMap(Class:GetClass('OpenEdge.Lang.String'),
                                         Class:GetClass('OpenEdge.Lang.Collections.TypedCollection')).
        
        oIterator = ServiceMessages:Iterator().
        do while oIterator:HasNext():
            oRequest = cast(oIterator:Next(), IServiceRequest).
            oString = new String(cast(oRequest, IServiceMessage):Service).
            
            if not oRequestByAdapter:ContainsKey(oString) then
                oRequestByAdapter:Put(oString, new IServiceMessageCollection()).
            
            cast(oRequestByAdapter:Get(oString), ICollection):Add(oRequest).
        end.
        
        oIterator = oRequestByAdapter:KeySet:Iterator().
        do while oIterator:HasNext():
            assign oString = cast(oIterator:Next(), String)
                   cServiceAdapter = oString:Value
                   oServiceAdapter = cast(ServiceMessageManager, IService):ServiceManager:GetServiceAdapter(cServiceAdapter)
                   /* increment before call since we're async, and so the Response call will be called
                      by the Fetch/Save/Define() call ... */
                   OutstandingRequests = OutstandingRequests + 1.
            
            oServiceAdapter:ExecuteRequest(cast(cast(oRequestByAdapter:Get(oString), ICollection):ToArray(), IServiceRequest),
                                           ServiceMessageManager).                                                    
        end.
        
        catch eApplError as ApplicationError:
            /* ... but if something goes wrong, we need to mark the request as not outstanding. */
            OutstandingRequests = OutstandingRequests - 1.
            
            undo, throw eApplError.
        end catch.
    end method.
    
end class.