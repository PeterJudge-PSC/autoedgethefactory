/** ------------------------------------------------------------------------
    File        : IComponent
    Purpose     : Interface definition for base OERA component.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Feb 18 14:25:00 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.CommonInfrastructure.IComponent.
using OpenEdge.CommonInfrastructure.IComponentInfo.

interface OpenEdge.CommonInfrastructure.IComponent:
    
    /** (mandatory) Stores information about the component, such as a developer-defined instance name
        so as to be able to uniquely identify the component.   */
    define public property ComponentInfo as IComponentInfo no-undo get.
    
    /** General creation code; constructors should only be used for property setting, not
        for any more complex wiring.  */
    method public void CreateComponent().
    
    /** Not InitializeComponent, since the Gui for .NET uses that name already, 
       as a PRIVATE member, and we want to have only 1 IComponent interface. */
    method public void Initialize().

    /** General destruction code that can be called outside of the destructor
        if needed (but will also be called from within the dtor). */
    method public void DestroyComponent().
        
end interface.
