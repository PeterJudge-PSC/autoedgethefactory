/*------------------------------------------------------------------------
    File        : DataFetchEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Sep 01 17:11:58 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using OpenEdge.PresentationLayer.Common.ModelActionEnum.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.DataFetchEventArgs inherits ModelEventArgs:
    define public property NewData as logical no-undo get. set.
        
    constructor public DataFetchEventArgs ():
       super().
       
       this-object:ModelAction = ModelActionEnum:Fetch.
    end constructor.
    
    constructor public DataFetchEventArgs (poModelService as IComponentInfo, plNewData as log):
        super(poModelService, ModelActionEnum:Fetch).
        
        this-object:NewData = plNewData.
    end constructor.
    
end class.