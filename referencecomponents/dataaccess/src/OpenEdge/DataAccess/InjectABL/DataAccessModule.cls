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
    constructor protected DataAccessModule (  ):
        super ().
    end constructor.

    method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        /* Example of standard DataAccess Object with named DataSource*/
        oBindingSyntax = Bind('OpenEdge.DataAccess.IDataAccess').
        oBindingSyntax
                :To('OpenEdge.DataAccess.StandardDataAccess')
                :WithMethodValue("AddDataSource", "Some-Named-DataSource")
                :WithMethodValue("AddDataSource", Class:GetClass('OpenEdge.DataSource.IDataSource')).
    end method.
    
end class.