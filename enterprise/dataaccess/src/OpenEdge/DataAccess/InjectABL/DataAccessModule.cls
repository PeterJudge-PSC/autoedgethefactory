/** ------------------------------------------------------------------------
    File        : DataAccessModule
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 11:05:25 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using Progress.Lang.Class
.
class OpenEdge.DataAccess.InjectABL.DataAccessModule inherits InjectionModule:
    constructor public DataAccessModule (  ):
        super ().
    end constructor.

    method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
    end method.
    
end class.