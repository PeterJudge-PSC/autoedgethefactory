/** ------------------------------------------------------------------------
    File        : DataSourcesModule
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

class OpenEdge.DataSource.InjectABL.DataSourcesModule inherits InjectionModule:
    constructor protected DataSourcesModule (  ):
        super ().
    end constructor.

    method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        
        oBindingSyntax = Bind('OpenEdge.DataSource.IDataSource').
        oBindingSyntax
                :To('OpenEdge.DataSource.StandardDataSource').
    end method.
    
end class.