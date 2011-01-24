/** ------------------------------------------------------------------------
    File        : DatabaseModel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu May 21 11:41:31 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.PresentationLayer.Model.Model.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.IComponentInfo.
 
class OpenEdge.PresentationLayer.Model.DatabaseModel  abstract 
        inherits Model:
    
    constructor public DatabaseModel (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    constructor public DatabaseModel ( input pcServiceName as character, input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo ):
        super (input pcServiceName, input poServiceManager, input poComponentInfo).
    end constructor.
    
    method override protected handle GetBufferHandle(input pcTableName as character):
       define variable hBuffer as handle no-undo.
       
       create buffer hBuffer for table pcTableName buffer-name pcTableName.
       
       return hBuffer.
    end method.
    
 end class.