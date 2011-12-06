/** ------------------------------------------------------------------------
    File        : setup/create_savvion_users.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue May 31 10:03:38 EDT 2011
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

/** -- defs -- **/
define variable cUserName as character no-undo.
define variable cGroupName as character no-undo.
define variable cParentGroupName as character no-undo.
define variable cChildPage as character no-undo.
define stream strJSPMain.
define stream strJSPChild.

/** -- main -- **/
output stream strJSPMain  to value(session:parameter + '\autoedgethefactory\savvion\UserLoad\jsp\LoadAutoEdgeTheFactoryUsers.jsp').

put stream strJSPMain unformatted
    '<html>' skip.

find ContactType where ContactType.Name eq 'email-work' no-lock no-error.

for each Tenant no-lock:
    
    cChildPage = substitute('Load&1Users.jsp', caps(Tenant.Name)).
    
    put stream strJSPMain unformatted
        '<jsp:include page="' +  cChildPage + '" />' skip.
    
    output stream strJSPChild to value(session:parameter + '\autoedgethefactory\savvion\UserLoad\jsp\' + cChildPage).

    put stream strJSPChild unformatted
        '<html>' skip
        '<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>' skip
        '<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />' skip
        '<% ' skip
        'JDBCGroup grp;' skip
        'JDBCUser user;' skip
        'String[] attrNames;' skip
        'Hashtable attrs;' skip
        skip.
    
    /* brand users */
    for each ApplicationUser where
             ApplicationUser.TenantId eq Tenant.TenantId and
             ApplicationUser.EmployeeId eq '' and
             ApplicationUser.CustomerId eq ''
             no-lock,
       first ContactXref where
             ContactXref.TenantId eq Tenant.TenantId and
             ContactXref.ContactType eq ContactType.Name and
             ContactXref.ParentId eq Tenant.TenantId
             no-lock,
       first ContactDetail where
             ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
             no-lock:

        case ApplicationUser.LoginName:
            when 'admin' or when 'lob_manager' then cParentGroupName = 'FinanceManagementGroup'.
            when 'factory' then cParentGroupName = 'FactoryGroup'.
            when 'sales' then cParentGroupName = 'SalesrepGroup'.
            when 'support' then cParentGroupName = 'FullfillmentStaffGroup'.
            when 'finance' then cParentGroupName = 'FinanceStaffGroup'.
            otherwise cParentGroupName = ''.
        end case.
        
        if cParentGroupName ne '' then
        do:
            cGroupName = substitute('&1_&2',
                            cParentGroupName,
                            Tenant.Name).
            
            put stream strJSPChild unformatted 
                'if (!jdr.isGroupExist("' + cParentGroupName + '")) ~{ jdr.addGroup("' + cParentGroupName + '"); ~} ' skip
                'if (!jdr.isGroupExist("' + cGroupName + '")) ~{ ' skip
                'jdr.addGroup("' + cGroupName + '"); ' 
                'grp = (JDBCGroup)jdr.getGroup("' + cParentGroupName + '");' skip            
                'grp.addGroupMember("' + cGroupName + '");' skip
                '~} ' skip
                 .
        end.    /* has group */
        
        cUserName = substitute('&1@&2',
                        replace(ApplicationUser.LoginName, '.', '_'),
                        Tenant.Name).
        
        put stream strJSPChild unformatted 
            'if (!jdr.isUserExist("' + cUserName + '")) ~{ ' skip
            'jdr.addUser("' + cUserName + '");' skip
            'user = ((JDBCUser)jdr.getUser("' + cUserName + '"));' skip
            'user.setAttribute(JDBCRealm.PASSWORD, "letmein");' skip
            'user.setAttribute(JDBCRealm.FIRSTNAME, "' + ApplicationUser.LoginName + '");' skip
            'user.setAttribute(JDBCRealm.LASTNAME, "' + Tenant.Name + '");' skip
            'user.setAttribute(JDBCRealm.EMAIL, "' + ContactDetail.Detail + '");' skip
            'grp = (JDBCGroup)jdr.getGroup("' + cGroupName + '");' skip
            'grp.addUserMember("' + cUserName + '");' skip
            '~} ' skip
             .
    end.
    
    /* employees */
    for each Department where
             Department.TenantId eq Tenant.TenantId
             no-lock:
        
        /* Keep our groups intact from the model */
        case Department.Name:
            when 'sales' then cParentGroupName = 'SalesrepGroup'.
            when 'factory' then cParentGroupName = 'FactoryGroup'.
            when 'support' then cParentGroupName = 'FullfillmentStaffGroup'.
            when 'admin' then cParentGroupName = 'FinanceManagementGroup'.
            when 'finance' then cParentGroupName = 'FinanceStaffGroup'.
            otherwise cParentGroupName = ''.
        end case.
        
        if cParentGroupName eq '' then
            next.
        
        cGroupName = substitute('&1_&2',
                        cParentGroupName,
                        Tenant.Name).
        
        put stream strJSPChild unformatted 
            'if (!jdr.isGroupExist("' + cParentGroupName + '")) ~{ jdr.addGroup("' + cParentGroupName + '"); ~} ' skip
            'if (!jdr.isGroupExist("' + cGroupName + '")) ~{ ' skip
            'jdr.addGroup("' + cGroupName + '"); ' 
            'grp = (JDBCGroup)jdr.getGroup("' + cParentGroupName + '");' skip            
            'grp.addGroupMember("' + cGroupName + '");' skip
            '~} ' skip
             .
        
        for each Employee where
                 Employee.TenantId eq Department.TenantId and
                 Employee.DepartmentId eq Department.DepartmentId
                 no-lock,
           first ApplicationUser where
                 ApplicationUser.TenantId eq Employee.TenantId and
                 ApplicationUser.EmployeeId eq Employee.EmployeeId
                 no-lock,
           first ContactXref where
                 ContactXref.TenantId eq Employee.TenantId and
                 ContactXref.ContactType eq ContactType.Name and
                 ContactXref.ParentId eq Employee.EmployeeId
                 no-lock,
           first ContactDetail where
                 ContactDetail.ContactDetailId eq ContactXref.ContactDetailId
                 no-lock:
            
            cUserName = substitute('&1@&2',
                            replace(ApplicationUser.LoginName, '.', '_'),
                            Tenant.Name).
            
            put stream strJSPChild unformatted 
                'if (!jdr.isUserExist("' + cUserName + '")) ~{ ' skip
                'jdr.addUser("' + cUserName + '");' skip
                'user = ((JDBCUser)jdr.getUser("' + cUserName + '"));' skip
                'user.setAttribute(JDBCRealm.PASSWORD, "letmein");' skip
                'user.setAttribute(JDBCRealm.FIRSTNAME, "' + Employee.FirstName + '");' skip
                'user.setAttribute(JDBCRealm.LASTNAME, "' + Employee.LastName + '");' skip
                'user.setAttribute(JDBCRealm.EMAIL, "' + ContactDetail.Detail + '");' skip
                'grp = (JDBCGroup)jdr.getGroup("' + cGroupName + '");' skip
                'grp.addUserMember("' + cUserName + '");' skip
                '~} ' skip
                 .
        end.    /* employee */
    end.    /* department */
    
    put stream strJSPChild unformatted
        '%> ' skip
        '</html>'.
    output stream strJSPChild close. 
end.    /* tenant */

put stream strJSPMain unformatted
    '</html>'.
    
finally:
    output stream strJSPChild close.
    output stream strJSPMain close.
end finally.

/** -- eof -- **/