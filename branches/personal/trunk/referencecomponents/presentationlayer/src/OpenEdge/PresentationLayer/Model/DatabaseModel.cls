/** ------------------------------------------------------------------------
    File        : DatabaseModel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu May 21 11:41:31 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.Model.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
 
class OpenEdge.PresentationLayer.Model.DatabaseModel  abstract 
        inherits Model:
    
    constructor public DatabaseModel(input pcServiceName as character, input poComponentInfo as IComponentInfo ):
        super(input pcServiceName, input poComponentInfo).
    end constructor.
    
    method override protected handle GetBufferHandle(input pcTableName as character):
       define variable hBuffer as handle no-undo.
       
       create buffer hBuffer for table pcTableName buffer-name pcTableName.
       
       return hBuffer.
    end method.
    
 end class.