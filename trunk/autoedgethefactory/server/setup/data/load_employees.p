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
/*
{routinelevel.i}
*/

/* ********************  Preprocessor Definitions  ******************** */
function getRandom returns character (input cValueList as character):

    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, '|') .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, '|') .
        else return cValueList.
end function.

/* ***************************  Main Block  *************************** */
define variable cLastNames as character no-undo.
define variable cMiddleNames as character no-undo.
define variable cFirstNamesMale as character no-undo.
define variable cFirstNamesFemale as character no-undo.
define variable cSalutationsMale as character no-undo.
define variable cSalutationsFemale as character no-undo.
define variable cNotes as character no-undo.
define variable cEmailAddress as character no-undo.

define variable iNumAddresses as integer no-undo.
define variable iNumRegions as integer no-undo.
define variable iNumDealers as integer no-undo.

define query qryDealer for Dealer scrolling.
define query qryRegion for SalesRegion scrolling.
define query qryAddresses for AddressDetail scrolling.

cLastNames = "Miller|Anderson|Higgins|Gant|Jones|Smith|Johnson|Moore|Taylor|Jackson|Harris|Martin|Garcia|Martinez|Robinson|Lewis|Lee|Walker|Baker|Nelson|Carter|Roberts|Tuner|Parker|Evans|Collins|Stewart|Murphy|Cooper|Richardson|Cox|Howard|Geller|Bing|Ward|Torres|Peterson|Gray|Ramirez|James|Watson|Brooks|Kelly|Sanders|Price|Bennet|Wood|Barnes|Ross|Henderson|Coleman|Jenkins|Perry|Powell|Long|Patterson|Hughes|Flores|Washington|Butler|Simmons|Foster|Gonzales|Alexander|Hayes|Myers|Ford|Hamilton|Graham|Sullivan|Wallace|Woods|West|Jordan|Reynolds|Marshall|Freeman|Wells|Webbs|Simpson|Stevens|Tucker|Porter|Hunter|Hicks|Crawford|Kennedy|Burns|Shaw|Holmes|Robertson|Hunt|Black|Palmer|Rose|Spencer|Pierce|Wagner".
cMiddleNames = "A.|B.|M.|N.|L.||".
cFirstNamesMale = "John|Robert|Mike|David|Richard|Thomas|Chris|Paul|Mark|Donald|Steve|Anthony|Larry|Frank|Scott|Eric|Greg|Patrick|Peter|Carl|Arthur|Joe|Jack|Justin|Keith".
cFirstNamesFemale = "Mary|Linda|Barbara|Susan|Margaret|Lisa|Nancy|Betty|Helen|Donna|Carol|Laura|Sarah|Jessica|Melissa|Brenda|Amy|Rebecca|Martha|Amanda|Janet|Ann|Joyce|Diane|Alice|Julie|Heather|Evelyn|Kelly".
cSalutationsMale = "Mr.|Mr.|Mr.|Mr.|Mr.|Mr.|Dr.".
cSalutationsFemale = "Ms.|Miss|Ms.|Miss|Ms.|Miss|Dr.".
cNotes = "Some note|Another note|No note|||||".
cEmailAddress = "@aol.com|@mail.com|@progress.com|@company.com".

open query qryAddresses preselect each AddressDetail.
iNumAddresses = max(query qryAddresses:num-results - 1, 1).

run loadDepartments.

procedure loadSalesrep:
    define input parameter pcEmployeeId as character no-undo.
    define input parameter pcTenantId as character no-undo.
    define input parameter pcRepCode as character no-undo.
    define variable cCode as character no-undo.
    define variable iCount as integer no-undo.
    
    define buffer lbRep for Salesrep.
    
    reposition qryRegion to row random(0, iNumRegions).
    get next qryRegion no-lock.
    
    iCount =  0.
    cCode = pcRepCode. 
    find first lbRep where
               lbrep.Code eq cCode and 
               lbRep.TenantId eq pcTenantId
               no-lock no-error.
    do while available lbRep:
        iCount =  iCount + 1.
        cCode = pcRepCode + string(iCount, '99').
        
        find first lbRep where
                   lbrep.Code eq cCode and 
                   lbRep.TenantId eq pcTenantId
                   no-lock no-error.
    end.
                
    create Salesrep.
    assign Salesrep.EmployeeId = pcEmployeeId
           Salesrep.TenantId = pcTenantId
           Salesrep.SalesrepId = guid(generate-uuid)
           
           Salesrep.AnnualQuota = random(10, 100) * exp(10, 3)
           Salesrep.Code = cCode
           Salesrep.SalesRegion = SalesRegion.Name
           .
end procedure.
    
procedure loadEmployees:
    define input parameter pcDeptId as character no-undo.
    define input parameter pcTenantId as character no-undo.
    define input parameter pcDepartmentName as character no-undo.
    define input-output parameter piLastEmpNum as integer no-undo.
    
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    
    /* employees-per-departmnt */
    iMax = 5.
  
    if query qryDealer:num-results gt 0 then
    do iLoop = 1 to iMax:
        reposition qryDealer to row random(0, iNumDealers).
        get next qryDealer no-lock.
        
        create Employee.
        assign Employee.Birthdate = date(random(1,12), random(1,28), random(1950, 1980))
               Employee.DepartmentId = pcDeptId
               Employee.EmployeeId = guid(generate-uuid)
               piLastEmpNum = piLastEmpNum + 1
               Employee.EmpNum = piLastEmpNum
               Employee.FirstName = (if iLoop mod 2 eq 0 then getRandom(cFirstNamesFemale) else getRandom(cFirstNamesMale))  
               Employee.LastName = getRandom(cLastNames)
               Employee.Position = 'Member of ' + pcDepartmentName + ' staff '
               Employee.SickDaysLeft = random(0, 12)
               Employee.StartDate = date(random(1,12), random(1,28), random(2005, 2010))
               Employee.TenantId = pcTenantId
               Employee.VacationDaysLeft = random(0, 43)
               Employee.DealerId = Dealer.DealerId
               .
        
        reposition qryAddresses to row random(0, iNumAddresses).
        get next qryAddresses no-lock.
        
        run AddHomeAddress(Employee.EmployeeId, Employee.TenantId, AddressDetail.AddressDetailId).
        
        if pcDepartmentName eq 'sales' then
            run loadSalesrep(Employee.EmployeeId,
                             Employee.TenantId,
                             substring(Employee.FirstName, 1,1) + substring(Employee.LastName, 1,1)).
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
    define variable iLastEmpNo as integer no-undo.
    
    define buffer lbDept for Department.
    
    cNames = 'admin|field|admin:finance|field:sales|admin:hr|field:support|factory'.
    iMax = num-entries(cNames, '|').
    
    for each Tenant no-lock:
        iLastEmpNo = 100.
        
        open query qryRegion preselect each SalesRegion where SalesRegion.TenantId = Tenant.TenantId no-lock.
        iNumRegions = max(query qryRegion:num-results - 1, 1).
        
        open query qryDealer preselect each Dealer where Dealer.TenantId = Tenant.TenantId no-lock.
        iNumDealers = max(query qryDealer:num-results - 1, 1).
        
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
            
            run loadEmployees(Department.DepartmentId,
                              Department.TenantId,
                              Department.Name,
                              input-output iLastEmpNo).
        end.
        
        close query qryDealer.
        close query qryRegion.
    end.
end procedure.
