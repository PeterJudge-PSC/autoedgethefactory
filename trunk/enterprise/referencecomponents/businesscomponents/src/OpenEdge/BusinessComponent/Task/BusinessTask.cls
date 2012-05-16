/** ------------------------------------------------------------------------
    File        : BusinessTask
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 26 11:59:49 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Task.IBusinessTask.
using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.BusinessComponent.Task.BusinessTask.

using OpenEdge.CommonInfrastructure.Common.Service.
using OpenEdge.CommonInfrastructure.Common.IService.
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITaskResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.TaskResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IServiceMessage.

using OpenEdge.Core.System.UnsupportedOperationError.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.IList.
using OpenEdge.Lang.Collections.TypedList.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Assert.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.BusinessComponent.Task.BusinessTask abstract inherits Service
            implements IBusinessTask: 
    /** A protected property so that an empty request will get everything. */
    define protected property FetchAllEntities as logical no-undo get. set.
                                    
    define static public property IBusinessTaskType as class Class no-undo get. private set.
    
/*TODO: IBusinessComponent or IBusinessService instead of IBusinessEntity ? */
    /** Contains a collection of the entities that this Task knows about and operates on with. */
    define public property BusinessEntities as IList no-undo
        get():
            if not valid-object(BusinessEntities) then
                BusinessEntities = new TypedList(Class:GetClass('OpenEdge.BusinessComponent.Entity.IBusinessEntity')).
            return BusinessEntities.
        end get.
        protected set.
        
    /** Typically we'd only have a single request-response at a time, but we have no
        guarantee of that, so we use a map to be safe. */
    define protected property TaskResponses as IMap no-undo
        get():
            if not valid-object(TaskResponses) then
                TaskResponses = new Map().
            
            return TaskResponses.
        end get.
        private set.
    
    constructor static BusinessTask():        
        BusinessTask:IBusinessTaskType = Class:GetClass('OpenEdge.BusinessComponent.Task.IBusinessTask').
    end constructor.
	constructor public BusinessTask(input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
        FetchAllEntities = false.
	end constructor.
    constructor public BusinessTask(input poComponentInfo as IComponentInfo,
                                    input poEntities as IList):
        this-object(input poComponentInfo).
        
        Assert:ArgumentNotNullOrEmpty(poEntities, 'Business Entity Collection').
        BusinessEntities = poEntities.
    end constructor.

    constructor public BusinessTask(input poComponentInfo as IComponentInfo,
                                    input poEntities as IBusinessEntity extent):
        this-object(poComponentInfo).
        
        Assert:ArgumentNotNullOrEmpty(poEntities, 'Business Entity Array').
        BusinessEntities:AddArray(poEntities).
    end constructor.
	
	/** External method to dynamically set the BusinessEntities property via InjectABL */ 
    method public void SetBusinessEntities(input poEntities as IList):
        BusinessEntities = poEntities.
    end method.

    /** Executes a requested task.
        
        We have the task request's contained service requests, which may be 
        ordered; we also have the task's entities, which are potentially ordered.
        The Task has knowledge of the order, and so we default to the task determining
        the order of operations on the request. 
        
        @param ITaskRequest The request for this task
        @return ITaskResponse The response */
    method public ITaskResponse PerformTask(input poTaskRequest as ITaskRequest):
        define variable oIterator as IIterator no-undo.
        define variable oEntity as IBusinessEntity no-undo.
        define variable oServiceName as String no-undo.
        define variable oTaskResponse as ITaskResponse no-undo.
        define variable oEntityRequest as IServiceMessage no-undo.
        
        /* group service requests by type */
        oTaskResponse = new TaskResponse(poTaskRequest).
        TaskResponses:Put(
            new String(cast(oTaskResponse, IServiceMessage):MessageId),
            oTaskResponse).
        
        /* If there are no individual service requests, and we're not already getting all entities, get 'em all. */ 
        if not FetchAllEntities then
            FetchAllEntities = poTaskRequest:ServiceRequests:IsEmpty().
                            
        oIterator = BusinessEntities:Iterator().
        do transaction
           while oIterator:HasNext():
            
            oEntity = cast(oIterator:Next(), IBusinessEntity).
            
            /* The instance name is the unique name of this IBusinessEntity service. */
            oServiceName = new String(cast(oEntity, IComponent):ComponentInfo:InstanceName).
            /* Is there a request for this business entity? */
            oEntityRequest = cast(poTaskRequest:ServiceRequests:Get(oServiceName), IServiceMessage).            
            if FetchAllEntities or valid-object(oEntityRequest) then
            case oEntityRequest:ActionType:
                when ServiceMessageActionEnum:FetchSchema then
                    oTaskResponse:ServiceResponses:Put(oServiceName, oEntity:FetchSchema(cast(oEntityRequest, IFetchRequest))). 
                
                when ServiceMessageActionEnum:FetchData then
                do:               
                    oEntity:FetchData(cast(oEntityRequest, IFetchRequest)).
                    oTaskResponse:ServiceResponses:Put(
                        oServiceName,
                        oEntity:GetData(cast(oEntityRequest, IServiceMessage):MessageId)).
                end.
                
                when ServiceMessageActionEnum:SaveData then
                    oTaskResponse:ServiceResponses:Put(
                            oServiceName,
                            oEntity:SaveData(cast(oEntityRequest, ISaveRequest))).               
            end case.
        end.
        
        return oTaskResponse.        
	end method.

end class.