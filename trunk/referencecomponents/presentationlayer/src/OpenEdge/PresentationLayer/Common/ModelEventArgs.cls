/** ------------------------------------------------------------------------
    File        : ModelEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 14 10:53:05 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageEventArgs. 
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.ModelEventArgs inherits ServiceMessageEventArgs: 
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property ModelAction as ModelActionEnum no-undo get. set.
    define public property QueryName as character no-undo get. set.
    define public property TableName as character no-undo get. set.
    define public property CurrentRowKey as character extent no-undo get. set.

    constructor public ModelEventArgs ():
        super().
    end constructor.

    constructor public ModelEventArgs (poModelService as IComponentInfo,
                                       pcQuery as char, 
                                       pcTable as char,
                                       pcKey as char extent  ):
        this-object(poModelService, ModelActionEnum:None, pcQuery, pcTable, pcKey).
    end constructor.
            
    constructor public ModelEventArgs (poModelService as IComponentInfo,
                                       poModelAction as ModelActionEnum,
                                       pcQuery as char, 
                                       pcTable as char,
                                       pcKey as char extent  ):
        this-object().
                                                
        assign ModelService = poModelService
               ModelAction = poModelAction
               QueryName = pcQuery
               TableName = pcTable
               CurrentRowKey = pcKey.
    end constructor.
    
    constructor public ModelEventArgs (poModelService as IComponentInfo,
                                       pcQuery as char,
                                       pcTable as char ):
        define variable cDummy as char extent 1 no-undo init [?].
        
        this-object(poModelService, ModelActionEnum:None, pcQuery, pcTable, cDummy).
    end constructor.
    
    constructor public ModelEventArgs (poModelService as IComponentInfo, pcQuery as char ):
        define variable cDummy as char extent 1 no-undo init [?].
                
        this-object(poModelService, ModelActionEnum:None, pcQuery, ?, cDummy).
    end constructor.
    
    constructor public ModelEventArgs (poModelService as IComponentInfo):
        define variable cDummy as char extent 1 no-undo init [?].
        
        this-object(poModelService, ModelActionEnum:None, ?, ?, cDummy).
    end constructor.
            
    constructor public ModelEventArgs (poModelService as IComponentInfo, poModelAction as ModelActionEnum):
        define variable cDummy as char extent 1 no-undo init [?].
        
        this-object(poModelService, poModelAction, ?, ?, cDummy).
    end constructor.
                
end class.