/*------------------------------------------------------------------------
    File        : load_employees.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 09:19:48 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

routine-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */
function getRandom returns character (input cValueList as character):

    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, '|') .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, '|') .
        else return cValueList.
end function.

/* ***************************  Main Block  *************************** */
define variable iNumTenants as integer no-undo.
define variable iNumAddresses as integer no-undo.
define variable iNumDepts as integer no-undo.

define query qryTenant for Tenant scrolling.
define query qryAddresses for AddressDetail scrolling.
define query qryDepartment for Department scrolling.

open query qryAddresses preselect each AddressDetail.
iNumAddresses = query qryAddresses:num-results - 1.

open query qryTenant preselect each Tenant no-lock.
iNumTenants = query qryTenant:num-results - 1.

run loadDepartments.

open query qryDepartment preselect each Department where Department.ParentDepartmentId = '' no-lock.
iNumDepts = query qryDepartment:num-results - 1.


run loadEmployees.

procedure loadEmployees:
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cLastNames as character no-undo.
define variable cMiddleNames as character no-undo.
define variable cFirstNamesMale as character no-undo.
define variable cFirstNamesFemale as character no-undo.
define variable cSalutationsMale as character no-undo.
define variable cSalutationsFemale as character no-undo.
define variable cNotes as character no-undo.
define variable cEmailAddress as character no-undo.

iMax = 20.

cLastNames = "Miller|Anderson|Higgins|Gant|Jones|Smith|Johnson|Moore|Taylor|Jackson|Harris|Martin|Garcia|Martinez|Robinson|Lewis|Lee|Walker|Baker|Nelson|Carter|Roberts|Tuner|Parker|Evans|Collins|Stewart|Murphy|Cooper|Richardson|Cox|Howard|Geller|Bing|Ward|Torres|Peterson|Gray|Ramirez|James|Watson|Brooks|Kelly|Sanders|Price|Bennet|Wood|Barnes|Ross|Henderson|Coleman|Jenkins|Perry|Powell|Long|Patterson|Hughes|Flores|Washington|Butler|Simmons|Foster|Gonzales|Alexander|Hayes|Myers|Ford|Hamilton|Graham|Sullivan|Wallace|Woods|West|Jordan|Reynolds|Marshall|Freeman|Wells|Webbs|Simpson|Stevens|Tucker|Porter|Hunter|Hicks|Crawford|Kennedy|Burns|Shaw|Holmes|Robertson|Hunt|Black|Palmer|Rose|Spencer|Pierce|Wagner".
cMiddleNames = "A.|B.|M.|N.|L.||".
cFirstNamesMale = "John|Robert|Mike|David|Richard|Thomas|Chris|Paul|Mark|Donald|Steve|Anthony|Larry|Frank|Scott|Eric|Greg|Patrick|Peter|Carl|Arthur|Joe|Jack|Justin|Keith".
cFirstNamesFemale = "Mary|Linda|Barbara|Susan|Margaret|Lisa|Nancy|Betty|Helen|Donna|Carol|Laura|Sarah|Jessica|Melissa|Brenda|Amy|Rebecca|Martha|Amanda|Janet|Ann|Joyce|Diane|Alice|Julie|Heather|Evelyn|Kelly".
cSalutationsMale = "Mr.|Mr.|Mr.|Mr.|Mr.|Mr.|Dr.".
cSalutationsFemale = "Ms.|Miss|Ms.|Miss|Ms.|Miss|Dr.".
cNotes = "Some note|Another note|No note|||||".
cEmailAddress = "@aol.com|@mail.com|@progress.com|@company.com".

do iLoop = 1 to iMax:
    reposition qryTenant to row random(0, iNumTenants).
    get next qryTenant no-lock.

    reposition qryDepartment to row random(0, iNumDepts).
    get next qryDepartment no-lock.

    create Employee.
    assign Employee.Birthdate = date(random(1,12), random(1,28), random(1950, 1980))
           Employee.DepartmentId = Department.DepartmentId
           Employee.EmployeeId = guid(generate-uuid)
           Employee.EmpNum = iLoop + 100
           Employee.FirstName = (if iLoop mod 2 eq 0 then getRandom(cFirstNamesFemale) else getRandom(cFirstNamesMale))  
           Employee.LastName = getRandom(cLastNames)
           Employee.Position = Department.Name
           Employee.SickDaysLeft = random(0, 12)
           Employee.StartDate = date(random(1,12), random(1,28), random(2005, 2010))
           Employee.TenantId = Tenant.TenantId
           Employee.VacationDaysLeft = random(0, 43)
           .
    reposition qryAddresses to row random(0, iNumAddresses).
    get next qryAddresses no-lock.
           
    run AddHomeAddress(Employee.EmployeeId, Employee.TenantId, AddressDetail.AddressDetailId).        
end.
end procedure.

procedure AddHomeAddress:
    define input parameter pcEmployeeId as character no-undo.
    define input parameter pcTenantId as character no-undo.
    define input parameter pcAddressDetailId as character no-undo.
    
    find AddressType where  AddressType.AddressType eq 'home' no-lock.
    
    create AddressXref.
    assign AddressXref.AddressDetailId = pcAddressDetailId
           AddressXref.AddressType = AddressType.AddressType
           AddressXref.ParentId = pcEmployeeId
           AddressXref.TenantId = pcTenantId.
end procedure.    

procedure loadDepartments:
    define variable cNames as character no-undo.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable cParent as character no-undo.
    define variable cCode as character no-undo.
    
    define buffer lbDept for Department.
        
    cNames = 'admin|field|admin:finance|field:sales|admin:hr|field:support'.
    iMax = num-entries(cNames, '|').
    
    for each Tenant no-lock:
        do iLoop = 1 to iMax:
            if num-entries(entry(iLoop, cNames, '|'), ':') eq 2 then
                assign cCode = entry(2, entry(iLoop, cNames, '|'), ':')
                       cParent = entry(1, entry(iLoop, cNames, '|'), ':').
            else
                assign cCode = entry(iLoop, cNames, '|')
                       cParent = ''.
            
            find lbDept where 
                 lbDept.TenantId = Tenant.TenantId and
                 lbDept.Name = cParent
                 no-lock no-error.
                                                
            create Department.
            assign Department.Code = string(iLoop * 100)
                   Department.DepartmentId = guid(generate-uuid)
                   Department.Name = cCode
                   Department.ParentDepartmentId = (if available lbDept then lbDept.DepartmentId else '')
                   Department.TenantId = Tenant.TenantId.
        end.
    end.
end procedure.



