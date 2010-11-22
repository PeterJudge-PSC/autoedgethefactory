/** ------------------------------------------------------------------------
    File        : EmployeeBE
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 15 09:18:30 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.StandardBusinessEntity.

class OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeBE inherits StandardBusinessEntity:
    define private temp-table eEmployee no-undo  
          field EmpNum           as integer
          field DeptCode         as character
          field Address          as character
          field Address2         as character
          field Birthdate        as date     
          field City             as character
          field FirstName        as character
          field HomePhone        as character
          field LastName         as character
          field Position         as character
          field PostalCode       as character
          field SickDaysLeft     as integer  
          field StartDate        as date     
          field State            as character
          field VacationDaysLeft as integer
          field WorkPhone        as character
          index idx1 as primary EmpNum
          index idx2 DeptCode.
    
    define private temp-table eDepartment no-undo 
          field DeptCode as character
          field DeptName as character
          field Manager as integer /*eemployee.empnum */
          index idx1 as primary DeptCode.
    
    define private temp-table eFamily no-undo
          field BenefitDate       as date    
          field Birthdate         as date    
          field CoveredOnBenefits as logical 
          field EmpNum            as integer 
          field Relation          as character
          field RelativeName      as character
          index idx1 as primary EmpNum.
    
    define private dataset dsEmployee for eEmployee, eDepartment, eFamily
        data-relation for eEmployee, eDepartment relation-fields (DeptCode, DeptCode)
        data-relation for eEmployee, eFamily relation-fields (EmpNum, EmpNum).
    
	constructor public EmployeeBE ( input poServiceManager as OpenEdge.CommonInfrastructure.Common.IServiceManager, input poComponentInfo as OpenEdge.CommonInfrastructure.Common.IComponentInfo, input pcServiceName as character, input poDAO as OpenEdge.DataAccess.IDataAccess ):
		super (input poServiceManager, input poComponentInfo, input pcServiceName, input poDAO).
	end constructor.

	constructor public EmployeeBE ( input poServiceManager as OpenEdge.CommonInfrastructure.Common.IServiceManager, input poComponentInfo as OpenEdge.CommonInfrastructure.Common.IComponentInfo, input pcServiceName as character ):
		super (input poServiceManager, input poComponentInfo, input pcServiceName).
	end constructor.


	method override protected handle CopyStaticDataset (output dataset-handle phDataset):
	    phDataset = dataset dsEmployee:handle.	
    end method.
    
end class.