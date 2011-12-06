<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_genericmotors")) { 
jdr.addGroup("FinanceManagementGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_genericmotors");
} 
if (!jdr.isUserExist("admin@genericmotors")) { 
jdr.addUser("admin@genericmotors");
user = ((JDBCUser)jdr.getUser("admin@genericmotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "genericmotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@genericmotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_genericmotors");
grp.addUserMember("admin@genericmotors");
} 
if (!jdr.isUserExist("guest@genericmotors")) { 
jdr.addUser("guest@genericmotors");
user = ((JDBCUser)jdr.getUser("guest@genericmotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "genericmotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@genericmotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_genericmotors");
grp.addUserMember("guest@genericmotors");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_genericmotors")) { 
jdr.addGroup("FactoryGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_genericmotors");
} 
if (!jdr.isUserExist("factory@genericmotors")) { 
jdr.addUser("factory@genericmotors");
user = ((JDBCUser)jdr.getUser("factory@genericmotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "genericmotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@genericmotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_genericmotors");
grp.addUserMember("factory@genericmotors");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_genericmotors")) { 
jdr.addGroup("FinanceManagementGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_genericmotors");
} 
if (!jdr.isUserExist("lob_manager@genericmotors")) { 
jdr.addUser("lob_manager@genericmotors");
user = ((JDBCUser)jdr.getUser("lob_manager@genericmotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "genericmotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@genericmotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_genericmotors");
grp.addUserMember("lob_manager@genericmotors");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_genericmotors")) { 
jdr.addGroup("FinanceManagementGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_genericmotors");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_genericmotors")) { 
jdr.addGroup("FinanceStaffGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_genericmotors");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_genericmotors")) { 
jdr.addGroup("SalesrepGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_genericmotors");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_genericmotors")) { 
jdr.addGroup("FullfillmentStaffGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_genericmotors");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_genericmotors")) { 
jdr.addGroup("FactoryGroup_genericmotors"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_genericmotors");
} 
%> 
</html>