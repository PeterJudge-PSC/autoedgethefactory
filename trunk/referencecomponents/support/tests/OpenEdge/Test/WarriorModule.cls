/*------------------------------------------------------------------------
    File        : WarriorModule
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:07:55 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.*.
using OpenEdge.Core.InjectABL.Binding.*.
using OpenEdge.Core.InjectABL.Binding.Conditions.*.
using OpenEdge.Core.InjectABL.Lifecycle.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Lang.*.
using Progress.Lang.*.

class OpenEdge.Test.WarriorModule inherits InjectionModule:
    
    constructor public WarriorModule():
        super().
    end constructor.

    method override public void Load():
        /* use oBS as bug workaround */
        def var obs as IBindingSyntax.
        def var ocs as IConditionSyntax.
        
        /* Samurai! */
        obs = Bind('OpenEdge.Test.IWeapon').
        obs = obs:To('OpenEdge.Test.Sword').
        
        obs = Bind('OpenEdge.Test.IWeapon').
        obs = obs:To('OpenEdge.Test.Shuriken'):Named('alternateweapon').
        
        obs = Bind('OpenEdge.Test.Samurai').
        obs = obs
            :ToSelf()
            :Using('OpenEdge.Test.SamuraiProvider')
                        
            :WithPropertyValue('Dojo', 'Ninja Gym East')
            
            :WithMethodValue('SetNinjaMasters', 'Mike')
            :WithMethodValue('SetNinjaMasters', 'Dwight')
            
            :WithMethodValue('SetAlternateWeapon',
                              Class:GetClass('OpenEdge.Test.Shuriken'))
            .
        ocs = obs:When().
           ocs:Session:Not(SessionTypeCondition:Client).

        
        obs = Bind('OpenEdge.Test.Samurai').
        obs = obs
            :To('OpenEdge.Test.ClientSamurai')
            :Using('OpenEdge.Test.SamuraiProvider').
        
        ocs = obs:When().
           ocs:Session:Is(SessionTypeCondition:Client).
           
    end method.
    

    
    method override public void Unload():
        Unbind(('IWeapon')).
        Unbind(('Samurai')).
    end method.

end class.