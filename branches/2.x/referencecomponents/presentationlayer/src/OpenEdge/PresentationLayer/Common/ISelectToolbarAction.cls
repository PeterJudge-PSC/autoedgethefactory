/** ------------------------------------------------------------------------
    File        : ISelectToolbarAction
    Purpose     : Interface for selecting toolbar actions.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 03 10:30:20 EST 2009
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.PresentationLayer.Common.ToolbarActionEventArgs.

interface OpenEdge.PresentationLayer.Common.ISelectToolbarAction:
    
    method public void SelectToolbarAction(input poAction as ToolbarActionEventArgs).
    
end interface.