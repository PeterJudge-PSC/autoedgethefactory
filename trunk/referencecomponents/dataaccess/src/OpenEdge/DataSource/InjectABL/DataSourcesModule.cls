/** ------------------------------------------------------------------------
    File        : DataSourcesModule
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Aug 24 11:05:25 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.

class OpenEdge.DataSource.InjectABL.DataSourcesModule inherits InjectionModule:
    constructor public DataSourcesModule (  ):
        super ().
    end constructor.
    
    method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
    end method.
    
end class.