/*------------------------------------------------------------------------
    File        : ServiceMessageBundle
    Purpose     : A collection of requests and logic for dealing with their responses
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Apr 26 15:03:13 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundleCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessageCollection.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer.
using OpenEdge.CommonInfrastructure.ServiceMessage.IMessageRequestor.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceAdapter.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IDefineResponse.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.

using OpenEdge.Core.System.EventArgs.
using OpenEdge.Core.System.ServiceMessageActionEnum.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageBundle:
    
    define protected property ServiceManager as IServiceManager no-undo get. private set.
    define protected property ServiceMessages as IServiceMessageCollection no-undo get. private set. 
    define protected property MessageConsumers as IMap no-undo get. private set.
    
    define public property Requestor as IMessageRequestor no-undo get. private set.
    define public property ActionType as ServiceMessageActionEnum no-undo get. private set.
    define public property NumMessages as integer no-undo 
        get():
            return ServiceMessages:Size.
        end get.
    define public property OutstandingRequests as integer no-undo get. private set.
    
    destructor public ServiceMessageBundle():
        ServiceMessages:Clear().
        MessageConsumers:Clear().
    end destructor.
    
    constructor public ServiceMessageBundle(poServiceManager as IServiceManager,
                                            poMessageRequestor as IMessageRequestor,
                                            poActionType as ServiceMessageActionEnum):
        Assert:ArgumentNotNull(poMessageRequestor, 'Requesting component').
        Assert:ArgumentNotNull(poActionType, 'Message type').
        Assert:ArgumentNotNull(poServiceManager, 'Service manager').
        
        assign Requestor = poMessageRequestor
               ActionType = poActionType
               ServiceManager = poServiceManager
               ServiceMessages = new IServiceMessageCollection()
               MessageConsumers = new TypedMap(Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage'),
                                               Class:GetClass('OpenEdge.CommonInfrastructure.ServiceMessage.IMessageConsumer'))
               .
    end constructor.
    
    
    method public void AddMessage(poMessage as IServiceMessage, poMessageConsumer as IMessageConsumer):
        Assert:ArgumentNotNull(poMessage, 'Service message').
        Assert:ArgumentNotNull(poMessageConsumer, 'Message consumer').
        
        if not poMessage:ActionType:Equals(this-object:ActionType) then
            undo, throw new ArgumentError(
                        'Service message not of type ' + this-object:ActionType:ToString(),
                        'poMessage').
        
        ServiceMessages:Add(poMessage).
        MessageConsumers:Put(poMessage, poMessageConsumer).
    end method.
    
    method public void RemoveMessage(poMessage as IServiceMessage):
        ServiceMessages:Remove(poMessage).
        MessageConsumers:Remove(poMessage).
    end method.
    
    method public void ExecuteResponse(poResponse as IServiceMessage):
        cast(MessageConsumers:Get(poResponse), IMessageConsumer):ActionCompleted(poResponse).
        
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
    
    method public void ExecuteRequest():
        define variable oRequestByAdapter as IMap no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oMessage as IServiceMessage no-undo.
        define variable oString as String no-undo.
        define variable oServiceAdapter as IServiceAdapter no-undo.
        define variable cServiceAdapter as character no-undo.
        
        oRequestByAdapter = new TypedMap(Class:GetClass('OpenEdge.Lang.String'),
                                         Class:GetClass('OpenEdge.Lang.Collections.TypedCollection')).
        
        oIterator = ServiceMessages:Iterator().
        do while oIterator:HasNext():
            oMessage = cast(oIterator:Next(), IServiceMessage).
            oString = new String(oMessage:Service).
            
            if not oRequestByAdapter:ContainsKey(oString) then
                oRequestByAdapter:Put(oString, new IServiceMessageCollection()).
            
            cast(oRequestByAdapter:Get(oString), ICollection):Add(oMessage).
        end.
        
        oIterator = oRequestByAdapter:KeySet:Iterator().
        do while oIterator:HasNext():
            assign oString = cast(oIterator:Next(), String)
                   cServiceAdapter = oString:Value
                   oServiceAdapter = ServiceManager:GetServiceAdapter(cServiceAdapter)
                   /* increment before call since we're async, and so the Response call will be called
                      by the Fetch/Save/Define() call ... */
                   OutstandingRequests = OutstandingRequests + 1.
            
            case ActionType:
                when ServiceMessageActionEnum:Fetch then
                    oServiceAdapter:Fetch(cast(cast(oRequestByAdapter:Get(oString), ICollection):ToArray(), IFetchRequest)).
                when ServiceMessageActionEnum:Save then 
                    oServiceAdapter:Save(cast(cast(oRequestByAdapter:Get(oString), ICollection):ToArray(), ISaveRequest)).
                when ServiceMessageActionEnum:Define then 
                    oServiceAdapter:Define(cast(cast(oRequestByAdapter:Get(oString), ICollection):ToArray(), IDefineRequest)).
            end case.
        end.
        
        catch eApplError as ApplicationError:
            /* ... but if something goes wrong, we need to mark the request as not outstanding. */
            OutstandingRequests = OutstandingRequests - 1.
        end catch.
    end method.

end class.