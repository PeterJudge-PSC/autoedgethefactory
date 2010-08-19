@todo(task="This is identical to ModelEventArgs").
/*------------------------------------------------------------------------
    File        : UpdatePanelEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 09 10:05:46 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.PresentationLayer.Common.ModelEventArgs.
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.UpdatePanelEventArgs inherits ModelEventArgs  : 

    constructor public UpdatePanelEventArgs ():
        super().
    end constructor.
            
    constructor public UpdatePanelEventArgs (poModelService as IComponentInfo,
                                             pcQuery as char,
                                             pcTable as char  ):
        super(poModelService, pcQuery, pcTable).
    end constructor.
        
end class.