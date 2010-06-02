/*------------------------------------------------------------------------
    File        : ISelectAction
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 03 10:30:20 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.PresentationLayer.Common.ActionEventArgs.

interface OpenEdge.PresentationLayer.Common.ISelectAction:
    
    method public void SelectAction (poAction as ActionEventArgs).
    
end interface.