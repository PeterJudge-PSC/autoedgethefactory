<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_h2omotors")) { 
jdr.addGroup("FinanceManagementGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_h2omotors");
} 
if (!jdr.isUserExist("admin@h2omotors")) { 
jdr.addUser("admin@h2omotors");
user = ((JDBCUser)jdr.getUser("admin@h2omotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "h2omotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@h2omotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_h2omotors");
grp.addUserMember("admin@h2omotors");
} 
if (!jdr.isUserExist("guest@h2omotors")) { 
jdr.addUser("guest@h2omotors");
user = ((JDBCUser)jdr.getUser("guest@h2omotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "h2omotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@h2omotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_h2omotors");
grp.addUserMember("guest@h2omotors");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_h2omotors")) { 
jdr.addGroup("FactoryGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_h2omotors");
} 
if (!jdr.isUserExist("factory@h2omotors")) { 
jdr.addUser("factory@h2omotors");
user = ((JDBCUser)jdr.getUser("factory@h2omotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "h2omotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@h2omotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_h2omotors");
grp.addUserMember("factory@h2omotors");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_h2omotors")) { 
jdr.addGroup("FinanceManagementGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_h2omotors");
} 
if (!jdr.isUserExist("lob_manager@h2omotors")) { 
jdr.addUser("lob_manager@h2omotors");
user = ((JDBCUser)jdr.getUser("lob_manager@h2omotors"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "h2omotors");
user.setAttribute(JDBCRealm.EMAIL, "admin@h2omotors.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_h2omotors");
grp.addUserMember("lob_manager@h2omotors");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_h2omotors")) { 
jdr.addGroup("FinanceManagementGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_h2omotors");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_h2omotors")) { 
jdr.addGroup("FinanceStaffGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_h2omotors");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_h2omotors")) { 
jdr.addGroup("SalesrepGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_h2omotors");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_h2omotors")) { 
jdr.addGroup("FullfillmentStaffGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_h2omotors");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_h2omotors")) { 
jdr.addGroup("FactoryGroup_h2omotors"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_h2omotors");
} 
%> 
</html>