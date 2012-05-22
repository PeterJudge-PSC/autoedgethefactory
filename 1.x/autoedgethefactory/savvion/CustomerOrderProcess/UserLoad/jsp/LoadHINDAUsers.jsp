<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_hinda")) { 
jdr.addGroup("FinanceManagementGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_hinda");
} 
if (!jdr.isUserExist("admin@hinda")) { 
jdr.addUser("admin@hinda");
user = ((JDBCUser)jdr.getUser("admin@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "hinda");
user.setAttribute(JDBCRealm.EMAIL, "admin@hinda.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("admin@hinda");
} 
if (!jdr.isUserExist("guest@hinda")) { 
jdr.addUser("guest@hinda");
user = ((JDBCUser)jdr.getUser("guest@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "hinda");
user.setAttribute(JDBCRealm.EMAIL, "admin@hinda.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("guest@hinda");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_hinda")) { 
jdr.addGroup("FactoryGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_hinda");
} 
if (!jdr.isUserExist("factory@hinda")) { 
jdr.addUser("factory@hinda");
user = ((JDBCUser)jdr.getUser("factory@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "hinda");
user.setAttribute(JDBCRealm.EMAIL, "admin@hinda.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("factory@hinda");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_hinda")) { 
jdr.addGroup("FinanceManagementGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_hinda");
} 
if (!jdr.isUserExist("lob_manager@hinda")) { 
jdr.addUser("lob_manager@hinda");
user = ((JDBCUser)jdr.getUser("lob_manager@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "hinda");
user.setAttribute(JDBCRealm.EMAIL, "admin@hinda.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("lob_manager@hinda");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_hinda")) { 
jdr.addGroup("FactoryGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_hinda");
} 
if (!jdr.isUserExist("greg_murphy@hinda")) { 
jdr.addUser("greg_murphy@hinda");
user = ((JDBCUser)jdr.getUser("greg_murphy@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Murphy@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("greg_murphy@hinda");
} 
if (!jdr.isUserExist("kelly_ross@hinda")) { 
jdr.addUser("kelly_ross@hinda");
user = ((JDBCUser)jdr.getUser("kelly_ross@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Ross@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("kelly_ross@hinda");
} 
if (!jdr.isUserExist("mark_stewart@hinda")) { 
jdr.addUser("mark_stewart@hinda");
user = ((JDBCUser)jdr.getUser("mark_stewart@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mark");
user.setAttribute(JDBCRealm.LASTNAME, "Stewart");
user.setAttribute(JDBCRealm.EMAIL, "Mark.Stewart@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("mark_stewart@hinda");
} 
if (!jdr.isUserExist("mary_cooper@hinda")) { 
jdr.addUser("mary_cooper@hinda");
user = ((JDBCUser)jdr.getUser("mary_cooper@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Cooper");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Cooper@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("mary_cooper@hinda");
} 
if (!jdr.isUserExist("thomas_sullivan@hinda")) { 
jdr.addUser("thomas_sullivan@hinda");
user = ((JDBCUser)jdr.getUser("thomas_sullivan@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Thomas");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Thomas.Sullivan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("thomas_sullivan@hinda");
} 
if (!jdr.isUserExist("jessica_palmer@hinda")) { 
jdr.addUser("jessica_palmer@hinda");
user = ((JDBCUser)jdr.getUser("jessica_palmer@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Palmer@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("jessica_palmer@hinda");
} 
if (!jdr.isUserExist("ann_price@hinda")) { 
jdr.addUser("ann_price@hinda");
user = ((JDBCUser)jdr.getUser("ann_price@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Price");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Price@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("ann_price@hinda");
} 
if (!jdr.isUserExist("alice_lewis@hinda")) { 
jdr.addUser("alice_lewis@hinda");
user = ((JDBCUser)jdr.getUser("alice_lewis@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Lewis@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("alice_lewis@hinda");
} 
if (!jdr.isUserExist("joyce_sullivan@hinda")) { 
jdr.addUser("joyce_sullivan@hinda");
user = ((JDBCUser)jdr.getUser("joyce_sullivan@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Sullivan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("joyce_sullivan@hinda");
} 
if (!jdr.isUserExist("alice_collins@hinda")) { 
jdr.addUser("alice_collins@hinda");
user = ((JDBCUser)jdr.getUser("alice_collins@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Collins");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Collins@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("alice_collins@hinda");
} 
if (!jdr.isUserExist("linda_marshall@hinda")) { 
jdr.addUser("linda_marshall@hinda");
user = ((JDBCUser)jdr.getUser("linda_marshall@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Marshall");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Marshall@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_hinda");
grp.addUserMember("linda_marshall@hinda");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_hinda")) { 
jdr.addGroup("SalesrepGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_hinda");
} 
if (!jdr.isUserExist("robert_black@hinda")) { 
jdr.addUser("robert_black@hinda");
user = ((JDBCUser)jdr.getUser("robert_black@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Black");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Black@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("robert_black@hinda");
} 
if (!jdr.isUserExist("richard_lewis@hinda")) { 
jdr.addUser("richard_lewis@hinda");
user = ((JDBCUser)jdr.getUser("richard_lewis@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Lewis@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("richard_lewis@hinda");
} 
if (!jdr.isUserExist("laura_murphy@hinda")) { 
jdr.addUser("laura_murphy@hinda");
user = ((JDBCUser)jdr.getUser("laura_murphy@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Murphy@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("laura_murphy@hinda");
} 
if (!jdr.isUserExist("john_barnes@hinda")) { 
jdr.addUser("john_barnes@hinda");
user = ((JDBCUser)jdr.getUser("john_barnes@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Barnes");
user.setAttribute(JDBCRealm.EMAIL, "John.Barnes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("john_barnes@hinda");
} 
if (!jdr.isUserExist("rebecca_ramirez@hinda")) { 
jdr.addUser("rebecca_ramirez@hinda");
user = ((JDBCUser)jdr.getUser("rebecca_ramirez@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Ramirez");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Ramirez@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("rebecca_ramirez@hinda");
} 
if (!jdr.isUserExist("janet_carter@hinda")) { 
jdr.addUser("janet_carter@hinda");
user = ((JDBCUser)jdr.getUser("janet_carter@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Carter@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("janet_carter@hinda");
} 
if (!jdr.isUserExist("evelyn_lewis@hinda")) { 
jdr.addUser("evelyn_lewis@hinda");
user = ((JDBCUser)jdr.getUser("evelyn_lewis@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Lewis@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("evelyn_lewis@hinda");
} 
if (!jdr.isUserExist("diane_robinson@hinda")) { 
jdr.addUser("diane_robinson@hinda");
user = ((JDBCUser)jdr.getUser("diane_robinson@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Robinson");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Robinson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("diane_robinson@hinda");
} 
if (!jdr.isUserExist("amanda_woods@hinda")) { 
jdr.addUser("amanda_woods@hinda");
user = ((JDBCUser)jdr.getUser("amanda_woods@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Woods@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("amanda_woods@hinda");
} 
if (!jdr.isUserExist("joyce_graham@hinda")) { 
jdr.addUser("joyce_graham@hinda");
user = ((JDBCUser)jdr.getUser("joyce_graham@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Graham");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Graham@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("joyce_graham@hinda");
} 
if (!jdr.isUserExist("diane_jordan@hinda")) { 
jdr.addUser("diane_jordan@hinda");
user = ((JDBCUser)jdr.getUser("diane_jordan@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Jordan");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Jordan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_hinda");
grp.addUserMember("diane_jordan@hinda");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_hinda")) { 
jdr.addGroup("FinanceStaffGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_hinda");
} 
if (!jdr.isUserExist("john_baker@hinda")) { 
jdr.addUser("john_baker@hinda");
user = ((JDBCUser)jdr.getUser("john_baker@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "John.Baker@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("john_baker@hinda");
} 
if (!jdr.isUserExist("laura_long@hinda")) { 
jdr.addUser("laura_long@hinda");
user = ((JDBCUser)jdr.getUser("laura_long@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Long@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("laura_long@hinda");
} 
if (!jdr.isUserExist("john_lee@hinda")) { 
jdr.addUser("john_lee@hinda");
user = ((JDBCUser)jdr.getUser("john_lee@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Lee");
user.setAttribute(JDBCRealm.EMAIL, "John.Lee@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("john_lee@hinda");
} 
if (!jdr.isUserExist("larry_anderson@hinda")) { 
jdr.addUser("larry_anderson@hinda");
user = ((JDBCUser)jdr.getUser("larry_anderson@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Larry");
user.setAttribute(JDBCRealm.LASTNAME, "Anderson");
user.setAttribute(JDBCRealm.EMAIL, "Larry.Anderson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("larry_anderson@hinda");
} 
if (!jdr.isUserExist("donna_ross@hinda")) { 
jdr.addUser("donna_ross@hinda");
user = ((JDBCUser)jdr.getUser("donna_ross@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Ross@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("donna_ross@hinda");
} 
if (!jdr.isUserExist("helen_pierce@hinda")) { 
jdr.addUser("helen_pierce@hinda");
user = ((JDBCUser)jdr.getUser("helen_pierce@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Pierce");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Pierce@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("helen_pierce@hinda");
} 
if (!jdr.isUserExist("alice_gant@hinda")) { 
jdr.addUser("alice_gant@hinda");
user = ((JDBCUser)jdr.getUser("alice_gant@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Gant");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Gant@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("alice_gant@hinda");
} 
if (!jdr.isUserExist("ann_walker@hinda")) { 
jdr.addUser("ann_walker@hinda");
user = ((JDBCUser)jdr.getUser("ann_walker@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Walker");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Walker@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("ann_walker@hinda");
} 
if (!jdr.isUserExist("heather_kelly@hinda")) { 
jdr.addUser("heather_kelly@hinda");
user = ((JDBCUser)jdr.getUser("heather_kelly@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Kelly@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("heather_kelly@hinda");
} 
if (!jdr.isUserExist("martha_miller@hinda")) { 
jdr.addUser("martha_miller@hinda");
user = ((JDBCUser)jdr.getUser("martha_miller@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Miller@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("martha_miller@hinda");
} 
if (!jdr.isUserExist("evelyn_peterson@hinda")) { 
jdr.addUser("evelyn_peterson@hinda");
user = ((JDBCUser)jdr.getUser("evelyn_peterson@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Peterson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_hinda");
grp.addUserMember("evelyn_peterson@hinda");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_hinda")) { 
jdr.addGroup("FullfillmentStaffGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_hinda");
} 
if (!jdr.isUserExist("paul_sullivan@hinda")) { 
jdr.addUser("paul_sullivan@hinda");
user = ((JDBCUser)jdr.getUser("paul_sullivan@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Sullivan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("paul_sullivan@hinda");
} 
if (!jdr.isUserExist("frank_martinez@hinda")) { 
jdr.addUser("frank_martinez@hinda");
user = ((JDBCUser)jdr.getUser("frank_martinez@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Frank");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Frank.Martinez@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("frank_martinez@hinda");
} 
if (!jdr.isUserExist("carol_martin@hinda")) { 
jdr.addUser("carol_martin@hinda");
user = ((JDBCUser)jdr.getUser("carol_martin@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Martin");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Martin@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("carol_martin@hinda");
} 
if (!jdr.isUserExist("david_reynolds@hinda")) { 
jdr.addUser("david_reynolds@hinda");
user = ((JDBCUser)jdr.getUser("david_reynolds@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "David");
user.setAttribute(JDBCRealm.LASTNAME, "Reynolds");
user.setAttribute(JDBCRealm.EMAIL, "David.Reynolds@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("david_reynolds@hinda");
} 
if (!jdr.isUserExist("amanda_burns@hinda")) { 
jdr.addUser("amanda_burns@hinda");
user = ((JDBCUser)jdr.getUser("amanda_burns@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Burns");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Burns@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("amanda_burns@hinda");
} 
if (!jdr.isUserExist("evelyn_ross@hinda")) { 
jdr.addUser("evelyn_ross@hinda");
user = ((JDBCUser)jdr.getUser("evelyn_ross@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Ross@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("evelyn_ross@hinda");
} 
if (!jdr.isUserExist("lisa_baker@hinda")) { 
jdr.addUser("lisa_baker@hinda");
user = ((JDBCUser)jdr.getUser("lisa_baker@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Baker@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("lisa_baker@hinda");
} 
if (!jdr.isUserExist("alice_moore@hinda")) { 
jdr.addUser("alice_moore@hinda");
user = ((JDBCUser)jdr.getUser("alice_moore@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Moore");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Moore@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("alice_moore@hinda");
} 
if (!jdr.isUserExist("melissa_wood@hinda")) { 
jdr.addUser("melissa_wood@hinda");
user = ((JDBCUser)jdr.getUser("melissa_wood@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Wood");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Wood@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("melissa_wood@hinda");
} 
if (!jdr.isUserExist("susan_kennedy@hinda")) { 
jdr.addUser("susan_kennedy@hinda");
user = ((JDBCUser)jdr.getUser("susan_kennedy@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Kennedy@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("susan_kennedy@hinda");
} 
if (!jdr.isUserExist("ann_sullivan@hinda")) { 
jdr.addUser("ann_sullivan@hinda");
user = ((JDBCUser)jdr.getUser("ann_sullivan@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Sullivan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_hinda");
grp.addUserMember("ann_sullivan@hinda");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_hinda")) { 
jdr.addGroup("FinanceManagementGroup_hinda"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_hinda");
} 
if (!jdr.isUserExist("steve_myers@hinda")) { 
jdr.addUser("steve_myers@hinda");
user = ((JDBCUser)jdr.getUser("steve_myers@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Myers@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("steve_myers@hinda");
} 
if (!jdr.isUserExist("diane_kennedy@hinda")) { 
jdr.addUser("diane_kennedy@hinda");
user = ((JDBCUser)jdr.getUser("diane_kennedy@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Kennedy@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("diane_kennedy@hinda");
} 
if (!jdr.isUserExist("thomas_hughes@hinda")) { 
jdr.addUser("thomas_hughes@hinda");
user = ((JDBCUser)jdr.getUser("thomas_hughes@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Thomas");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Thomas.Hughes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("thomas_hughes@hinda");
} 
if (!jdr.isUserExist("barbara_cox@hinda")) { 
jdr.addUser("barbara_cox@hinda");
user = ((JDBCUser)jdr.getUser("barbara_cox@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Cox");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Cox@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("barbara_cox@hinda");
} 
if (!jdr.isUserExist("john_bing@hinda")) { 
jdr.addUser("john_bing@hinda");
user = ((JDBCUser)jdr.getUser("john_bing@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Bing");
user.setAttribute(JDBCRealm.EMAIL, "John.Bing@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("john_bing@hinda");
} 
if (!jdr.isUserExist("margaret_long@hinda")) { 
jdr.addUser("margaret_long@hinda");
user = ((JDBCUser)jdr.getUser("margaret_long@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Long@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("margaret_long@hinda");
} 
if (!jdr.isUserExist("nancy_powell@hinda")) { 
jdr.addUser("nancy_powell@hinda");
user = ((JDBCUser)jdr.getUser("nancy_powell@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Powell");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Powell@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("nancy_powell@hinda");
} 
if (!jdr.isUserExist("melissa_murphy@hinda")) { 
jdr.addUser("melissa_murphy@hinda");
user = ((JDBCUser)jdr.getUser("melissa_murphy@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Murphy@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("melissa_murphy@hinda");
} 
if (!jdr.isUserExist("brenda_hayes@hinda")) { 
jdr.addUser("brenda_hayes@hinda");
user = ((JDBCUser)jdr.getUser("brenda_hayes@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Brenda");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "Brenda.Hayes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("brenda_hayes@hinda");
} 
if (!jdr.isUserExist("mary_hunt@hinda")) { 
jdr.addUser("mary_hunt@hinda");
user = ((JDBCUser)jdr.getUser("mary_hunt@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Hunt");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Hunt@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("mary_hunt@hinda");
} 
if (!jdr.isUserExist("melissa_black@hinda")) { 
jdr.addUser("melissa_black@hinda");
user = ((JDBCUser)jdr.getUser("melissa_black@hinda"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Black");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Black@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_hinda");
grp.addUserMember("melissa_black@hinda");
} 
%> 
</html>