/*------------------------------------------------------------------------
    File        : DatabaseModel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu May 21 11:41:31 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.Model.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
 
class OpenEdge.PresentationLayer.Model.DatabaseModel  abstract 
        inherits Model:
        
    define private temp-table ttBufferHandle no-undo
        field TableName as character
        field BufferHandle as handle
        index idx1 as primary unique TableName. 

    constructor public DatabaseModel (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    method override protected handle GetBufferHandle(pcTable as character):
        define buffer lbBuffer for ttBufferHandle.
        
        find lbBuffer where lbBuffer.TableName = pcTable no-error.
        if not available lbBuffer then
        do:
            create lbBuffer.
            lbBuffer.TableName = pcTable.
            
            create buffer lbBuffer.BufferHandle for table lbBuffer.TableName.
        end.
                                       
        return lbBuffer.BufferHandle.
    end method.    
    
    method override public void DestroyComponent():
        define buffer lbBuffer for ttBufferHandle.
        
        super:DestroyComponent().
        
        for each lbBuffer:
            delete object lbBuffer.BufferHandle no-error.
            delete lbBuffer.
        end.
    end method.
            
    method override protected void DoCommitData():
    end method.
    
    method override protected void AssignDefaultValues(pcTable as character, phBuffer as handle):
    end method.
    
    method override protected void AfterCommitData(  ):
    end method.
    
    method override protected void AssignKeyValues( input pcTable as character, input phBuffer as widget-handle ):
    end method.

 end class.