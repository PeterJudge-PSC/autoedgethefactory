/*------------------------------------------------------------------------
    File        : NavigationPanelEventArgs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 06 13:20:57 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using OpenEdge.Core.System.EventArgs. 
using OpenEdge.Lang.EnumMember.
using Progress.Lang.Class.

class OpenEdge.PresentationLayer.Common.NavigationPanelEventArgs inherits EventArgs  : 

    define public property RowPosition as EnumMember no-undo get. set. /* OpenEdge.PresentationLayer.System.RowPositionEnum */
    define public property ModelService as IComponentInfo no-undo get. set.
    define public property QueryName as character no-undo get. set.
    
    constructor public NavigationPanelEventArgs ():
        super().
    end constructor.
            
    constructor public NavigationPanelEventArgs (poModelService as IComponentInfo,
                                                 pcQuery as char,
                                                 poRowPosition as EnumMember):
        this-object().
                
        RowPosition = poRowPosition.
        ModelService = poModelService.
        QueryName = pcQuery.
    end constructor.
    
end class.