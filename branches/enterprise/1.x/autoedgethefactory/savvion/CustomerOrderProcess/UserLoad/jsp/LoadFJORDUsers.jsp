<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_fjord")) { 
jdr.addGroup("FinanceManagementGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_fjord");
} 
if (!jdr.isUserExist("admin@fjord")) { 
jdr.addUser("admin@fjord");
user = ((JDBCUser)jdr.getUser("admin@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "fjord");
user.setAttribute(JDBCRealm.EMAIL, "admin@fjord.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("admin@fjord");
} 
if (!jdr.isUserExist("guest@fjord")) { 
jdr.addUser("guest@fjord");
user = ((JDBCUser)jdr.getUser("guest@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "fjord");
user.setAttribute(JDBCRealm.EMAIL, "admin@fjord.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("guest@fjord");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_fjord")) { 
jdr.addGroup("FactoryGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_fjord");
} 
if (!jdr.isUserExist("factory@fjord")) { 
jdr.addUser("factory@fjord");
user = ((JDBCUser)jdr.getUser("factory@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "fjord");
user.setAttribute(JDBCRealm.EMAIL, "admin@fjord.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("factory@fjord");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_fjord")) { 
jdr.addGroup("FinanceManagementGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_fjord");
} 
if (!jdr.isUserExist("lob_manager@fjord")) { 
jdr.addUser("lob_manager@fjord");
user = ((JDBCUser)jdr.getUser("lob_manager@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "fjord");
user.setAttribute(JDBCRealm.EMAIL, "admin@fjord.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("lob_manager@fjord");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_fjord")) { 
jdr.addGroup("FullfillmentStaffGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_fjord");
} 
if (!jdr.isUserExist("thomas_jackson@fjord")) { 
jdr.addUser("thomas_jackson@fjord");
user = ((JDBCUser)jdr.getUser("thomas_jackson@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Thomas");
user.setAttribute(JDBCRealm.LASTNAME, "Jackson");
user.setAttribute(JDBCRealm.EMAIL, "Thomas.Jackson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("thomas_jackson@fjord");
} 
if (!jdr.isUserExist("rebecca_robinson@fjord")) { 
jdr.addUser("rebecca_robinson@fjord");
user = ((JDBCUser)jdr.getUser("rebecca_robinson@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Robinson");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Robinson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("rebecca_robinson@fjord");
} 
if (!jdr.isUserExist("eric_evans@fjord")) { 
jdr.addUser("eric_evans@fjord");
user = ((JDBCUser)jdr.getUser("eric_evans@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Eric");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Eric.Evans@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("eric_evans@fjord");
} 
if (!jdr.isUserExist("brenda_alexander@fjord")) { 
jdr.addUser("brenda_alexander@fjord");
user = ((JDBCUser)jdr.getUser("brenda_alexander@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Brenda");
user.setAttribute(JDBCRealm.LASTNAME, "Alexander");
user.setAttribute(JDBCRealm.EMAIL, "Brenda.Alexander@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("brenda_alexander@fjord");
} 
if (!jdr.isUserExist("peter_miller@fjord")) { 
jdr.addUser("peter_miller@fjord");
user = ((JDBCUser)jdr.getUser("peter_miller@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Peter");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Peter.Miller@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("peter_miller@fjord");
} 
if (!jdr.isUserExist("jessica_wagner@fjord")) { 
jdr.addUser("jessica_wagner@fjord");
user = ((JDBCUser)jdr.getUser("jessica_wagner@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Wagner");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Wagner@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("jessica_wagner@fjord");
} 
if (!jdr.isUserExist("laura_hunt@fjord")) { 
jdr.addUser("laura_hunt@fjord");
user = ((JDBCUser)jdr.getUser("laura_hunt@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Hunt");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Hunt@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("laura_hunt@fjord");
} 
if (!jdr.isUserExist("alice_rose@fjord")) { 
jdr.addUser("alice_rose@fjord");
user = ((JDBCUser)jdr.getUser("alice_rose@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Rose");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Rose@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("alice_rose@fjord");
} 
if (!jdr.isUserExist("amy_ford@fjord")) { 
jdr.addUser("amy_ford@fjord");
user = ((JDBCUser)jdr.getUser("amy_ford@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Ford");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Ford@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("amy_ford@fjord");
} 
if (!jdr.isUserExist("linda_parker@fjord")) { 
jdr.addUser("linda_parker@fjord");
user = ((JDBCUser)jdr.getUser("linda_parker@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Parker");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Parker@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("linda_parker@fjord");
} 
if (!jdr.isUserExist("sarah_ramirez@fjord")) { 
jdr.addUser("sarah_ramirez@fjord");
user = ((JDBCUser)jdr.getUser("sarah_ramirez@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Ramirez");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Ramirez@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_fjord");
grp.addUserMember("sarah_ramirez@fjord");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_fjord")) { 
jdr.addGroup("FinanceStaffGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_fjord");
} 
if (!jdr.isUserExist("keith_hunter@fjord")) { 
jdr.addUser("keith_hunter@fjord");
user = ((JDBCUser)jdr.getUser("keith_hunter@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Keith");
user.setAttribute(JDBCRealm.LASTNAME, "Hunter");
user.setAttribute(JDBCRealm.EMAIL, "Keith.Hunter@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("keith_hunter@fjord");
} 
if (!jdr.isUserExist("julie_ward@fjord")) { 
jdr.addUser("julie_ward@fjord");
user = ((JDBCUser)jdr.getUser("julie_ward@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Ward");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Ward@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("julie_ward@fjord");
} 
if (!jdr.isUserExist("paul_cox@fjord")) { 
jdr.addUser("paul_cox@fjord");
user = ((JDBCUser)jdr.getUser("paul_cox@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Cox");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Cox@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("paul_cox@fjord");
} 
if (!jdr.isUserExist("alice_myers@fjord")) { 
jdr.addUser("alice_myers@fjord");
user = ((JDBCUser)jdr.getUser("alice_myers@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Myers@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("alice_myers@fjord");
} 
if (!jdr.isUserExist("joe_james@fjord")) { 
jdr.addUser("joe_james@fjord");
user = ((JDBCUser)jdr.getUser("joe_james@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joe");
user.setAttribute(JDBCRealm.LASTNAME, "James");
user.setAttribute(JDBCRealm.EMAIL, "Joe.James@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("joe_james@fjord");
} 
if (!jdr.isUserExist("janet_myers@fjord")) { 
jdr.addUser("janet_myers@fjord");
user = ((JDBCUser)jdr.getUser("janet_myers@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Myers@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("janet_myers@fjord");
} 
if (!jdr.isUserExist("laura_kennedy@fjord")) { 
jdr.addUser("laura_kennedy@fjord");
user = ((JDBCUser)jdr.getUser("laura_kennedy@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Kennedy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("laura_kennedy@fjord");
} 
if (!jdr.isUserExist("diane_rose@fjord")) { 
jdr.addUser("diane_rose@fjord");
user = ((JDBCUser)jdr.getUser("diane_rose@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Rose");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Rose@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("diane_rose@fjord");
} 
if (!jdr.isUserExist("donna_torres@fjord")) { 
jdr.addUser("donna_torres@fjord");
user = ((JDBCUser)jdr.getUser("donna_torres@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Torres");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Torres@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("donna_torres@fjord");
} 
if (!jdr.isUserExist("carol_higgins@fjord")) { 
jdr.addUser("carol_higgins@fjord");
user = ((JDBCUser)jdr.getUser("carol_higgins@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Higgins");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Higgins@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("carol_higgins@fjord");
} 
if (!jdr.isUserExist("sarah_lewis@fjord")) { 
jdr.addUser("sarah_lewis@fjord");
user = ((JDBCUser)jdr.getUser("sarah_lewis@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Lewis@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_fjord");
grp.addUserMember("sarah_lewis@fjord");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_fjord")) { 
jdr.addGroup("FactoryGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_fjord");
} 
if (!jdr.isUserExist("frank_geller@fjord")) { 
jdr.addUser("frank_geller@fjord");
user = ((JDBCUser)jdr.getUser("frank_geller@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Frank");
user.setAttribute(JDBCRealm.LASTNAME, "Geller");
user.setAttribute(JDBCRealm.EMAIL, "Frank.Geller@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("frank_geller@fjord");
} 
if (!jdr.isUserExist("amy_jordan@fjord")) { 
jdr.addUser("amy_jordan@fjord");
user = ((JDBCUser)jdr.getUser("amy_jordan@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Jordan");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Jordan@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("amy_jordan@fjord");
} 
if (!jdr.isUserExist("robert_miller@fjord")) { 
jdr.addUser("robert_miller@fjord");
user = ((JDBCUser)jdr.getUser("robert_miller@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Miller@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("robert_miller@fjord");
} 
if (!jdr.isUserExist("amanda_pierce@fjord")) { 
jdr.addUser("amanda_pierce@fjord");
user = ((JDBCUser)jdr.getUser("amanda_pierce@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Pierce");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Pierce@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("amanda_pierce@fjord");
} 
if (!jdr.isUserExist("paul_cox@fjord")) { 
jdr.addUser("paul_cox@fjord");
user = ((JDBCUser)jdr.getUser("paul_cox@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Cox");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Cox@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("paul_cox@fjord");
} 
if (!jdr.isUserExist("laura_ross@fjord")) { 
jdr.addUser("laura_ross@fjord");
user = ((JDBCUser)jdr.getUser("laura_ross@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Ross@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("laura_ross@fjord");
} 
if (!jdr.isUserExist("jessica_shaw@fjord")) { 
jdr.addUser("jessica_shaw@fjord");
user = ((JDBCUser)jdr.getUser("jessica_shaw@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Shaw@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("jessica_shaw@fjord");
} 
if (!jdr.isUserExist("helen_burns@fjord")) { 
jdr.addUser("helen_burns@fjord");
user = ((JDBCUser)jdr.getUser("helen_burns@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Burns");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Burns@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("helen_burns@fjord");
} 
if (!jdr.isUserExist("susan_kelly@fjord")) { 
jdr.addUser("susan_kelly@fjord");
user = ((JDBCUser)jdr.getUser("susan_kelly@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Kelly@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("susan_kelly@fjord");
} 
if (!jdr.isUserExist("heather_roberts@fjord")) { 
jdr.addUser("heather_roberts@fjord");
user = ((JDBCUser)jdr.getUser("heather_roberts@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Roberts");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Roberts@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("heather_roberts@fjord");
} 
if (!jdr.isUserExist("donna_sullivan@fjord")) { 
jdr.addUser("donna_sullivan@fjord");
user = ((JDBCUser)jdr.getUser("donna_sullivan@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Sullivan@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_fjord");
grp.addUserMember("donna_sullivan@fjord");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_fjord")) { 
jdr.addGroup("SalesrepGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_fjord");
} 
if (!jdr.isUserExist("scott_murphy@fjord")) { 
jdr.addUser("scott_murphy@fjord");
user = ((JDBCUser)jdr.getUser("scott_murphy@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Scott");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Scott.Murphy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("scott_murphy@fjord");
} 
if (!jdr.isUserExist("ann_graham@fjord")) { 
jdr.addUser("ann_graham@fjord");
user = ((JDBCUser)jdr.getUser("ann_graham@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Graham");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Graham@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("ann_graham@fjord");
} 
if (!jdr.isUserExist("frank_coleman@fjord")) { 
jdr.addUser("frank_coleman@fjord");
user = ((JDBCUser)jdr.getUser("frank_coleman@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Frank");
user.setAttribute(JDBCRealm.LASTNAME, "Coleman");
user.setAttribute(JDBCRealm.EMAIL, "Frank.Coleman@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("frank_coleman@fjord");
} 
if (!jdr.isUserExist("martha_long@fjord")) { 
jdr.addUser("martha_long@fjord");
user = ((JDBCUser)jdr.getUser("martha_long@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Long@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("martha_long@fjord");
} 
if (!jdr.isUserExist("john_webbs@fjord")) { 
jdr.addUser("john_webbs@fjord");
user = ((JDBCUser)jdr.getUser("john_webbs@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Webbs");
user.setAttribute(JDBCRealm.EMAIL, "John.Webbs@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("john_webbs@fjord");
} 
if (!jdr.isUserExist("laura_torres@fjord")) { 
jdr.addUser("laura_torres@fjord");
user = ((JDBCUser)jdr.getUser("laura_torres@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Torres");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Torres@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("laura_torres@fjord");
} 
if (!jdr.isUserExist("heather_coleman@fjord")) { 
jdr.addUser("heather_coleman@fjord");
user = ((JDBCUser)jdr.getUser("heather_coleman@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Coleman");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Coleman@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("heather_coleman@fjord");
} 
if (!jdr.isUserExist("lisa_stewart@fjord")) { 
jdr.addUser("lisa_stewart@fjord");
user = ((JDBCUser)jdr.getUser("lisa_stewart@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Stewart");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Stewart@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("lisa_stewart@fjord");
} 
if (!jdr.isUserExist("kelly_barnes@fjord")) { 
jdr.addUser("kelly_barnes@fjord");
user = ((JDBCUser)jdr.getUser("kelly_barnes@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Barnes");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Barnes@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("kelly_barnes@fjord");
} 
if (!jdr.isUserExist("alice_holmes@fjord")) { 
jdr.addUser("alice_holmes@fjord");
user = ((JDBCUser)jdr.getUser("alice_holmes@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Holmes");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Holmes@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("alice_holmes@fjord");
} 
if (!jdr.isUserExist("margaret_flores@fjord")) { 
jdr.addUser("margaret_flores@fjord");
user = ((JDBCUser)jdr.getUser("margaret_flores@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Flores");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Flores@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_fjord");
grp.addUserMember("margaret_flores@fjord");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_fjord")) { 
jdr.addGroup("FinanceManagementGroup_fjord"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_fjord");
} 
if (!jdr.isUserExist("keith_hunter@fjord")) { 
jdr.addUser("keith_hunter@fjord");
user = ((JDBCUser)jdr.getUser("keith_hunter@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Keith");
user.setAttribute(JDBCRealm.LASTNAME, "Hunter");
user.setAttribute(JDBCRealm.EMAIL, "Keith.Hunter@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("keith_hunter@fjord");
} 
if (!jdr.isUserExist("amanda_stevens@fjord")) { 
jdr.addUser("amanda_stevens@fjord");
user = ((JDBCUser)jdr.getUser("amanda_stevens@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Stevens");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Stevens@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("amanda_stevens@fjord");
} 
if (!jdr.isUserExist("greg_jackson@fjord")) { 
jdr.addUser("greg_jackson@fjord");
user = ((JDBCUser)jdr.getUser("greg_jackson@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Jackson");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Jackson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("greg_jackson@fjord");
} 
if (!jdr.isUserExist("joyce_gonzales@fjord")) { 
jdr.addUser("joyce_gonzales@fjord");
user = ((JDBCUser)jdr.getUser("joyce_gonzales@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Gonzales");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Gonzales@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("joyce_gonzales@fjord");
} 
if (!jdr.isUserExist("paul_watson@fjord")) { 
jdr.addUser("paul_watson@fjord");
user = ((JDBCUser)jdr.getUser("paul_watson@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Watson");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Watson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("paul_watson@fjord");
} 
if (!jdr.isUserExist("evelyn_stewart@fjord")) { 
jdr.addUser("evelyn_stewart@fjord");
user = ((JDBCUser)jdr.getUser("evelyn_stewart@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Stewart");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Stewart@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("evelyn_stewart@fjord");
} 
if (!jdr.isUserExist("evelyn_murphy@fjord")) { 
jdr.addUser("evelyn_murphy@fjord");
user = ((JDBCUser)jdr.getUser("evelyn_murphy@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Murphy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("evelyn_murphy@fjord");
} 
if (!jdr.isUserExist("nancy_myers@fjord")) { 
jdr.addUser("nancy_myers@fjord");
user = ((JDBCUser)jdr.getUser("nancy_myers@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Myers@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("nancy_myers@fjord");
} 
if (!jdr.isUserExist("amanda_bennet@fjord")) { 
jdr.addUser("amanda_bennet@fjord");
user = ((JDBCUser)jdr.getUser("amanda_bennet@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Bennet@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("amanda_bennet@fjord");
} 
if (!jdr.isUserExist("heather_miller@fjord")) { 
jdr.addUser("heather_miller@fjord");
user = ((JDBCUser)jdr.getUser("heather_miller@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Miller@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("heather_miller@fjord");
} 
if (!jdr.isUserExist("diane_james@fjord")) { 
jdr.addUser("diane_james@fjord");
user = ((JDBCUser)jdr.getUser("diane_james@fjord"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "James");
user.setAttribute(JDBCRealm.EMAIL, "Diane.James@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_fjord");
grp.addUserMember("diane_james@fjord");
} 
%> 
</html>