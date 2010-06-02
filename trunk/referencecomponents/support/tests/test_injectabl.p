/*------------------------------------------------------------------------
    File        : test_injectabl.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue Mar 02 10:56:02 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.Test.*.
using OpenEdge.Core.InjectABL.*.
using OpenEdge.Core.InjectABL.Binding.Parameters.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Lang.*.
using Progress.Lang.*.

def var kernel as IKernel.
def var modules as IInjectionModuleCollection.
def var params as IParameterCollection.

def var warrior as Samurai.

modules = new IInjectionModuleCollection().
modules:Add(new WarriorModule()).

kernel = new StandardKernel(modules).

warrior = cast(kernel:Get('OpenEdge.Test.Samurai'), Samurai). 

warrior:Attack("the evildoers").

params = new IParameterCollection().
params:Add(
    new MethodArgument('SetPrimaryWeapon',
            Class:GetClass('OpenEdge.Test.Shuriken'))).
           
params:Add(new PropertyValue('UseAlternate', 'true', DataTypeEnum:Logical)).

kernel:Inject(warrior, params).

warrior:Attack("a melon").

catch a as AppError:
    message     
    'msg=' a:GetMessage(1) skip
    'retval=' a:ReturnValue skip(2)
    a:CallStack
    view-as alert-box.
end catch.

catch e as Error:
    message     
        e:GetMessage(1) skip(2)
        e:CallStack
    view-as alert-box title 'Unhandled Progress.Lang.Error'.
end catch.

finally:
    if valid-object(kernel) then
        kernel:Release(warrior).

    kernel = ?.

    message 
    'are we ok?'
    view-as alert-box.        
end finally.

/* eof */