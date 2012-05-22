<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_toyola")) { 
jdr.addGroup("FinanceManagementGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_toyola");
} 
if (!jdr.isUserExist("admin@toyola")) { 
jdr.addUser("admin@toyola");
user = ((JDBCUser)jdr.getUser("admin@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "toyola");
user.setAttribute(JDBCRealm.EMAIL, "admin@toyola.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("admin@toyola");
} 
if (!jdr.isUserExist("guest@toyola")) { 
jdr.addUser("guest@toyola");
user = ((JDBCUser)jdr.getUser("guest@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "toyola");
user.setAttribute(JDBCRealm.EMAIL, "admin@toyola.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("guest@toyola");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_toyola")) { 
jdr.addGroup("FactoryGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_toyola");
} 
if (!jdr.isUserExist("factory@toyola")) { 
jdr.addUser("factory@toyola");
user = ((JDBCUser)jdr.getUser("factory@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "toyola");
user.setAttribute(JDBCRealm.EMAIL, "admin@toyola.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("factory@toyola");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_toyola")) { 
jdr.addGroup("FinanceManagementGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_toyola");
} 
if (!jdr.isUserExist("lob_manager@toyola")) { 
jdr.addUser("lob_manager@toyola");
user = ((JDBCUser)jdr.getUser("lob_manager@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "toyola");
user.setAttribute(JDBCRealm.EMAIL, "admin@toyola.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("lob_manager@toyola");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_toyola")) { 
jdr.addGroup("FinanceStaffGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_toyola");
} 
if (!jdr.isUserExist("jack_geller@toyola")) { 
jdr.addUser("jack_geller@toyola");
user = ((JDBCUser)jdr.getUser("jack_geller@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jack");
user.setAttribute(JDBCRealm.LASTNAME, "Geller");
user.setAttribute(JDBCRealm.EMAIL, "Jack.Geller@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("jack_geller@toyola");
} 
if (!jdr.isUserExist("nancy_taylor@toyola")) { 
jdr.addUser("nancy_taylor@toyola");
user = ((JDBCUser)jdr.getUser("nancy_taylor@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Taylor");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Taylor@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("nancy_taylor@toyola");
} 
if (!jdr.isUserExist("chris_hughes@toyola")) { 
jdr.addUser("chris_hughes@toyola");
user = ((JDBCUser)jdr.getUser("chris_hughes@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Chris");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Chris.Hughes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("chris_hughes@toyola");
} 
if (!jdr.isUserExist("sarah_hayes@toyola")) { 
jdr.addUser("sarah_hayes@toyola");
user = ((JDBCUser)jdr.getUser("sarah_hayes@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Hayes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("sarah_hayes@toyola");
} 
if (!jdr.isUserExist("peter_evans@toyola")) { 
jdr.addUser("peter_evans@toyola");
user = ((JDBCUser)jdr.getUser("peter_evans@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Peter");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Peter.Evans@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("peter_evans@toyola");
} 
if (!jdr.isUserExist("sarah_carter@toyola")) { 
jdr.addUser("sarah_carter@toyola");
user = ((JDBCUser)jdr.getUser("sarah_carter@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Carter@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("sarah_carter@toyola");
} 
if (!jdr.isUserExist("amanda_harris@toyola")) { 
jdr.addUser("amanda_harris@toyola");
user = ((JDBCUser)jdr.getUser("amanda_harris@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Harris");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Harris@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("amanda_harris@toyola");
} 
if (!jdr.isUserExist("carol_webbs@toyola")) { 
jdr.addUser("carol_webbs@toyola");
user = ((JDBCUser)jdr.getUser("carol_webbs@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Webbs");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Webbs@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("carol_webbs@toyola");
} 
if (!jdr.isUserExist("mary_peterson@toyola")) { 
jdr.addUser("mary_peterson@toyola");
user = ((JDBCUser)jdr.getUser("mary_peterson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Peterson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("mary_peterson@toyola");
} 
if (!jdr.isUserExist("kelly_butler@toyola")) { 
jdr.addUser("kelly_butler@toyola");
user = ((JDBCUser)jdr.getUser("kelly_butler@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Butler");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Butler@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("kelly_butler@toyola");
} 
if (!jdr.isUserExist("kelly_alexander@toyola")) { 
jdr.addUser("kelly_alexander@toyola");
user = ((JDBCUser)jdr.getUser("kelly_alexander@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Alexander");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Alexander@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_toyola");
grp.addUserMember("kelly_alexander@toyola");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_toyola")) { 
jdr.addGroup("FactoryGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_toyola");
} 
if (!jdr.isUserExist("peter_kelly@toyola")) { 
jdr.addUser("peter_kelly@toyola");
user = ((JDBCUser)jdr.getUser("peter_kelly@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Peter");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Peter.Kelly@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("peter_kelly@toyola");
} 
if (!jdr.isUserExist("alice_kelly@toyola")) { 
jdr.addUser("alice_kelly@toyola");
user = ((JDBCUser)jdr.getUser("alice_kelly@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Kelly@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("alice_kelly@toyola");
} 
if (!jdr.isUserExist("john_hunter@toyola")) { 
jdr.addUser("john_hunter@toyola");
user = ((JDBCUser)jdr.getUser("john_hunter@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Hunter");
user.setAttribute(JDBCRealm.EMAIL, "John.Hunter@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("john_hunter@toyola");
} 
if (!jdr.isUserExist("kelly_woods@toyola")) { 
jdr.addUser("kelly_woods@toyola");
user = ((JDBCUser)jdr.getUser("kelly_woods@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Woods@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("kelly_woods@toyola");
} 
if (!jdr.isUserExist("larry_holmes@toyola")) { 
jdr.addUser("larry_holmes@toyola");
user = ((JDBCUser)jdr.getUser("larry_holmes@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Larry");
user.setAttribute(JDBCRealm.LASTNAME, "Holmes");
user.setAttribute(JDBCRealm.EMAIL, "Larry.Holmes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("larry_holmes@toyola");
} 
if (!jdr.isUserExist("martha_freeman@toyola")) { 
jdr.addUser("martha_freeman@toyola");
user = ((JDBCUser)jdr.getUser("martha_freeman@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Freeman");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Freeman@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("martha_freeman@toyola");
} 
if (!jdr.isUserExist("heather_moore@toyola")) { 
jdr.addUser("heather_moore@toyola");
user = ((JDBCUser)jdr.getUser("heather_moore@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Moore");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Moore@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("heather_moore@toyola");
} 
if (!jdr.isUserExist("amy_myers@toyola")) { 
jdr.addUser("amy_myers@toyola");
user = ((JDBCUser)jdr.getUser("amy_myers@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Myers@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("amy_myers@toyola");
} 
if (!jdr.isUserExist("susan_carter@toyola")) { 
jdr.addUser("susan_carter@toyola");
user = ((JDBCUser)jdr.getUser("susan_carter@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Carter@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("susan_carter@toyola");
} 
if (!jdr.isUserExist("mary_nelson@toyola")) { 
jdr.addUser("mary_nelson@toyola");
user = ((JDBCUser)jdr.getUser("mary_nelson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Nelson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("mary_nelson@toyola");
} 
if (!jdr.isUserExist("betty_simpson@toyola")) { 
jdr.addUser("betty_simpson@toyola");
user = ((JDBCUser)jdr.getUser("betty_simpson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Betty");
user.setAttribute(JDBCRealm.LASTNAME, "Simpson");
user.setAttribute(JDBCRealm.EMAIL, "Betty.Simpson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_toyola");
grp.addUserMember("betty_simpson@toyola");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_toyola")) { 
jdr.addGroup("SalesrepGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_toyola");
} 
if (!jdr.isUserExist("joe_geller@toyola")) { 
jdr.addUser("joe_geller@toyola");
user = ((JDBCUser)jdr.getUser("joe_geller@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joe");
user.setAttribute(JDBCRealm.LASTNAME, "Geller");
user.setAttribute(JDBCRealm.EMAIL, "Joe.Geller@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("joe_geller@toyola");
} 
if (!jdr.isUserExist("martha_ward@toyola")) { 
jdr.addUser("martha_ward@toyola");
user = ((JDBCUser)jdr.getUser("martha_ward@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Ward");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Ward@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("martha_ward@toyola");
} 
if (!jdr.isUserExist("anthony_higgins@toyola")) { 
jdr.addUser("anthony_higgins@toyola");
user = ((JDBCUser)jdr.getUser("anthony_higgins@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Anthony");
user.setAttribute(JDBCRealm.LASTNAME, "Higgins");
user.setAttribute(JDBCRealm.EMAIL, "Anthony.Higgins@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("anthony_higgins@toyola");
} 
if (!jdr.isUserExist("julie_martinez@toyola")) { 
jdr.addUser("julie_martinez@toyola");
user = ((JDBCUser)jdr.getUser("julie_martinez@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Martinez@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("julie_martinez@toyola");
} 
if (!jdr.isUserExist("arthur_richardson@toyola")) { 
jdr.addUser("arthur_richardson@toyola");
user = ((JDBCUser)jdr.getUser("arthur_richardson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Arthur");
user.setAttribute(JDBCRealm.LASTNAME, "Richardson");
user.setAttribute(JDBCRealm.EMAIL, "Arthur.Richardson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("arthur_richardson@toyola");
} 
if (!jdr.isUserExist("nancy_parker@toyola")) { 
jdr.addUser("nancy_parker@toyola");
user = ((JDBCUser)jdr.getUser("nancy_parker@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Parker");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Parker@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("nancy_parker@toyola");
} 
if (!jdr.isUserExist("evelyn_palmer@toyola")) { 
jdr.addUser("evelyn_palmer@toyola");
user = ((JDBCUser)jdr.getUser("evelyn_palmer@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Palmer@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("evelyn_palmer@toyola");
} 
if (!jdr.isUserExist("brenda_tuner@toyola")) { 
jdr.addUser("brenda_tuner@toyola");
user = ((JDBCUser)jdr.getUser("brenda_tuner@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Brenda");
user.setAttribute(JDBCRealm.LASTNAME, "Tuner");
user.setAttribute(JDBCRealm.EMAIL, "Brenda.Tuner@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("brenda_tuner@toyola");
} 
if (!jdr.isUserExist("laura_sullivan@toyola")) { 
jdr.addUser("laura_sullivan@toyola");
user = ((JDBCUser)jdr.getUser("laura_sullivan@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Sullivan@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("laura_sullivan@toyola");
} 
if (!jdr.isUserExist("jessica_hughes@toyola")) { 
jdr.addUser("jessica_hughes@toyola");
user = ((JDBCUser)jdr.getUser("jessica_hughes@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Hughes@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("jessica_hughes@toyola");
} 
if (!jdr.isUserExist("joyce_ford@toyola")) { 
jdr.addUser("joyce_ford@toyola");
user = ((JDBCUser)jdr.getUser("joyce_ford@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Ford");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Ford@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_toyola");
grp.addUserMember("joyce_ford@toyola");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_toyola")) { 
jdr.addGroup("FinanceManagementGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_toyola");
} 
if (!jdr.isUserExist("mike_henderson@toyola")) { 
jdr.addUser("mike_henderson@toyola");
user = ((JDBCUser)jdr.getUser("mike_henderson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mike");
user.setAttribute(JDBCRealm.LASTNAME, "Henderson");
user.setAttribute(JDBCRealm.EMAIL, "Mike.Henderson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("mike_henderson@toyola");
} 
if (!jdr.isUserExist("ann_crawford@toyola")) { 
jdr.addUser("ann_crawford@toyola");
user = ((JDBCUser)jdr.getUser("ann_crawford@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Crawford");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Crawford@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("ann_crawford@toyola");
} 
if (!jdr.isUserExist("mark_butler@toyola")) { 
jdr.addUser("mark_butler@toyola");
user = ((JDBCUser)jdr.getUser("mark_butler@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mark");
user.setAttribute(JDBCRealm.LASTNAME, "Butler");
user.setAttribute(JDBCRealm.EMAIL, "Mark.Butler@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("mark_butler@toyola");
} 
if (!jdr.isUserExist("donna_tucker@toyola")) { 
jdr.addUser("donna_tucker@toyola");
user = ((JDBCUser)jdr.getUser("donna_tucker@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Tucker");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Tucker@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("donna_tucker@toyola");
} 
if (!jdr.isUserExist("richard_crawford@toyola")) { 
jdr.addUser("richard_crawford@toyola");
user = ((JDBCUser)jdr.getUser("richard_crawford@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Crawford");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Crawford@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("richard_crawford@toyola");
} 
if (!jdr.isUserExist("carol_lee@toyola")) { 
jdr.addUser("carol_lee@toyola");
user = ((JDBCUser)jdr.getUser("carol_lee@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Lee");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Lee@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("carol_lee@toyola");
} 
if (!jdr.isUserExist("martha_freeman@toyola")) { 
jdr.addUser("martha_freeman@toyola");
user = ((JDBCUser)jdr.getUser("martha_freeman@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Freeman");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Freeman@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("martha_freeman@toyola");
} 
if (!jdr.isUserExist("laura_patterson@toyola")) { 
jdr.addUser("laura_patterson@toyola");
user = ((JDBCUser)jdr.getUser("laura_patterson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Patterson");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Patterson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("laura_patterson@toyola");
} 
if (!jdr.isUserExist("rebecca_robertson@toyola")) { 
jdr.addUser("rebecca_robertson@toyola");
user = ((JDBCUser)jdr.getUser("rebecca_robertson@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Robertson");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Robertson@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("rebecca_robertson@toyola");
} 
if (!jdr.isUserExist("amanda_miller@toyola")) { 
jdr.addUser("amanda_miller@toyola");
user = ((JDBCUser)jdr.getUser("amanda_miller@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Miller@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("amanda_miller@toyola");
} 
if (!jdr.isUserExist("betty_washington@toyola")) { 
jdr.addUser("betty_washington@toyola");
user = ((JDBCUser)jdr.getUser("betty_washington@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Betty");
user.setAttribute(JDBCRealm.LASTNAME, "Washington");
user.setAttribute(JDBCRealm.EMAIL, "Betty.Washington@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_toyola");
grp.addUserMember("betty_washington@toyola");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_toyola")) { 
jdr.addGroup("FullfillmentStaffGroup_toyola"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_toyola");
} 
if (!jdr.isUserExist("frank_ford@toyola")) { 
jdr.addUser("frank_ford@toyola");
user = ((JDBCUser)jdr.getUser("frank_ford@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Frank");
user.setAttribute(JDBCRealm.LASTNAME, "Ford");
user.setAttribute(JDBCRealm.EMAIL, "Frank.Ford@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("frank_ford@toyola");
} 
if (!jdr.isUserExist("linda_collins@toyola")) { 
jdr.addUser("linda_collins@toyola");
user = ((JDBCUser)jdr.getUser("linda_collins@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Collins");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Collins@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("linda_collins@toyola");
} 
if (!jdr.isUserExist("larry_roberts@toyola")) { 
jdr.addUser("larry_roberts@toyola");
user = ((JDBCUser)jdr.getUser("larry_roberts@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Larry");
user.setAttribute(JDBCRealm.LASTNAME, "Roberts");
user.setAttribute(JDBCRealm.EMAIL, "Larry.Roberts@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("larry_roberts@toyola");
} 
if (!jdr.isUserExist("frank_wallace@toyola")) { 
jdr.addUser("frank_wallace@toyola");
user = ((JDBCUser)jdr.getUser("frank_wallace@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Frank");
user.setAttribute(JDBCRealm.LASTNAME, "Wallace");
user.setAttribute(JDBCRealm.EMAIL, "Frank.Wallace@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("frank_wallace@toyola");
} 
if (!jdr.isUserExist("jessica_freeman@toyola")) { 
jdr.addUser("jessica_freeman@toyola");
user = ((JDBCUser)jdr.getUser("jessica_freeman@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Freeman");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Freeman@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("jessica_freeman@toyola");
} 
if (!jdr.isUserExist("ann_martin@toyola")) { 
jdr.addUser("ann_martin@toyola");
user = ((JDBCUser)jdr.getUser("ann_martin@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Martin");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Martin@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("ann_martin@toyola");
} 
if (!jdr.isUserExist("sarah_collins@toyola")) { 
jdr.addUser("sarah_collins@toyola");
user = ((JDBCUser)jdr.getUser("sarah_collins@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Collins");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Collins@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("sarah_collins@toyola");
} 
if (!jdr.isUserExist("nancy_ford@toyola")) { 
jdr.addUser("nancy_ford@toyola");
user = ((JDBCUser)jdr.getUser("nancy_ford@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Ford");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Ford@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("nancy_ford@toyola");
} 
if (!jdr.isUserExist("donna_rose@toyola")) { 
jdr.addUser("donna_rose@toyola");
user = ((JDBCUser)jdr.getUser("donna_rose@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Rose");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Rose@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("donna_rose@toyola");
} 
if (!jdr.isUserExist("laura_long@toyola")) { 
jdr.addUser("laura_long@toyola");
user = ((JDBCUser)jdr.getUser("laura_long@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Long@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("laura_long@toyola");
} 
if (!jdr.isUserExist("evelyn_wagner@toyola")) { 
jdr.addUser("evelyn_wagner@toyola");
user = ((JDBCUser)jdr.getUser("evelyn_wagner@toyola"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Wagner");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Wagner@stillerinc.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_toyola");
grp.addUserMember("evelyn_wagner@toyola");
} 
%> 
</html>