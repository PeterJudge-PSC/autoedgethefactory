/** ------------------------------------------------------------------------
    File        : BusinessEntityDecorator
    Purpose     : Decorator class for decoracting/customising Business Entities
                  without requiring inheritance.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Dec 07 08:02:04 EST 2010
    Notes       : * There's a decent description of Decorator pattern in Wikipedia
                    at http://en.wikipedia.org/wiki/Decorator_pattern
                  * This class should be extended to provide specific functionality.
                    For instance, there is a ServiceInterface class which extents this
                    decorator, and which is used to expose the Business Entity as a service.  
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ISaveResponse.

using OpenEdge.Lang.Assert.

class OpenEdge.BusinessComponent.Entity.BusinessEntityDecorator abstract implements IBusinessEntity:
    
    define protected property DecoratedBusinessEntity as IBusinessEntity no-undo get. private set.

    define public property DataAccess as IDataAccess no-undo
       get():
           return DecoratedBusinessEntity:DataAccess.
       end get.
       set (input poDA as IDataAccess):
           DecoratedBusinessEntity:DataAccess = poDA.
       end set.
    
    constructor public BusinessEntityDecorator (input poBusinessEntity as IBusinessEntity):
        Assert:ArgumentNotNull(poBusinessEntity, 'Decorated Business Entity').
        DecoratedBusinessEntity = poBusinessEntity.
    end constructor.

    method public void FetchData(input poRequest as IFetchRequest):
        DecoratedBusinessEntity:FetchData(poRequest).        
    end method.

    method public IFetchResponse FetchSchema(input poDefineRequest as IFetchRequest):
        return DecoratedBusinessEntity:FetchSchema(poDefineRequest).
    end method.

    method public IFetchResponse GetData(input pcMessageId as longchar):
        return DecoratedBusinessEntity:GetData(pcMessageId).
    end method.

    method public ISaveResponse SaveData(input poChanges as ISaveRequest):
        return DecoratedBusinessEntity:SaveData(poChanges).
    end method.

    method public void SetDataAccess(input poDataAccess as IDataAccess):
        DecoratedBusinessEntity:SetDataAccess(poDataAccess).        
    end method.

end class.