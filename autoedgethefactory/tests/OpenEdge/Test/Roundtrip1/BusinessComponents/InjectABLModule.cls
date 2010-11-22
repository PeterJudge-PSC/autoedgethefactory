 /*------------------------------------------------------------------------
    File        : InjectABLModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 15 09:23:06 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Core.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.Core.InjectABL.Binding.IBindingSyntax.
using Progress.Lang.Class.

class OpenEdge.Test.Roundtrip1.BusinessComponents.InjectABLModule inherits InjectionModule:
    
    method override public void Load(  ):
        /* Use local variables oBS as bug workaround */
        define variable oBindingSyntax as IBindingSyntax no-undo.
        define variable oArgs as IParameter extent.
        
        extent(oArgs) = 2.
        
        /** BUSINESS ENTITIES **/
        oArgs[1] = new Parameter('EmployeeService').
        oArgs[2] = new Parameter(Class:GetClass('OpenEdge.DataAccess.IDataAccess'), 'EmployeeService').
        
        oBindingSyntax = Bind('OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider').
        oBindingSyntax:To('OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeBE'):Named('EmployeeService')
            :WithConstructorArgument(oArgs)
            
            :Using('OpenEdge.CommonInfrastructure.InjectABL.ServiceProvider')
            .
        
        /** DATA ACCESS **/
        oArgs[1] = new Parameter('Employee').
        oArgs[2] = new Parameter(Class:GetClass('OpenEdge.DataSource.IDataSource'), 'EmployeeDataSource').
        
        oBindingSyntax = Bind('OpenEdge.DataAccess.IDataAccess').
        oBindingSyntax:To('OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDA'):Named('EmployeeService')
            :WithMethodValue('AddDataSource', oArgs).

        oArgs[1] = new Parameter('Department').
        oArgs[2] = new Parameter(Class:GetClass('OpenEdge.DataSource.IDataSource'), 'DepartmentDataSource').
        oBindingSyntax:WithMethodValue('AddDataSource', oArgs).
        
        oArgs[1] = new Parameter('Family').
        oArgs[2] = new Parameter(Class:GetClass('OpenEdge.DataSource.IDataSource'), 'FamilyDataSource').
        oBindingSyntax:WithMethodValue('AddDataSource', oArgs).
        /** DATA SOURCES **/
                
        /* Employee */
        oBindingSyntax = Bind('OpenEdge.DataSource.IDataSource').
        oBindingSyntax:To('OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDS'):Named('EmployeeDataSource')
            .
        /* Department */
        oBindingSyntax = Bind('OpenEdge.DataSource.IDataSource').
        oBindingSyntax:To('OpenEdge.Test.Roundtrip1.BusinessComponents.DepartmentDS'):Named('DepartmentDataSource')
            .
        
        /* Family */
        oBindingSyntax = Bind('OpenEdge.DataSource.IDataSource').
        oBindingSyntax:To('OpenEdge.Test.Roundtrip1.BusinessComponents.FamilyDS'):Named('FamilyDataSource')
            .
    end method.
    
end class.