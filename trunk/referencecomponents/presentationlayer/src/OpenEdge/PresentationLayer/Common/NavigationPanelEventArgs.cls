/*------------------------------------------------------------------------
    File        : NavigationPanelEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 06 13:20:57 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.System.RowPositionEnum. 
using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.Core.System.EventArgs. 
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.NavigationPanelEventArgs inherits EventArgs  : 

    define public property RowPosition as RowPositionEnum no-undo get. set.
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as character no-undo get. set.
    
    constructor public NavigationPanelEventArgs ():
        super().
    end constructor.
            
    constructor public NavigationPanelEventArgs (poModelService as IComponentInfo,
                                                 pcQuery as char,
                                                 poRowPosition as RowPositionEnum):
        this-object().
                
        RowPosition = poRowPosition.
        ModelService = poModelService.
        QueryName = pcQuery.
    end constructor.
    
end class.