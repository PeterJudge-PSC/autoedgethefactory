/*------------------------------------------------------------------------
    File        : IComponent
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Feb 18 14:25:00 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IComponent.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using Progress.Lang.Class.

interface OpenEdge.CommonInfrastructure.Common.IComponent:
    /** Stores information about the component, such as a developer-defined instance name
        (so as to be able to uniquely identify the component).   */
    define public property ComponentInfo as IComponentInfo no-undo get.
    
    /** General creation code; constructors should only be used for property setting, not
        for any more complex wiring.  */
    method public void CreateComponent().
    
    /** Not InitializeComponent, since the Gui for .NET uses that name already, 
       as a PRIVATE member, and we want to have only 1 IComponent interface. */
    method public void Initialize().
    
    method public void DestroyComponent().    
end interface.
