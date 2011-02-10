/** ------------------------------------------------------------------------
    File        : BuildModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 01 16:15:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.

using Progress.Lang.Class.

class AutoEdge.Factory.Client.InjectABL.BuildModule inherits InjectionModule:
    
    constructor public BuildModule (  ):
        super ().
    end constructor.

    /** BUSINESS WORKFLOWS **/
    method public void LoadWorkflows():
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.

    end method.
    
    method override public void Load(  ):
        
    end method.
    
end class.