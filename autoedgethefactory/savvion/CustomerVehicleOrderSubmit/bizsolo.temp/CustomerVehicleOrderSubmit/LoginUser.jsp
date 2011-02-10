<%@page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo"%>
<%@taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"/>
<jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"/>
<jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"/>

<%! String _PageName = "LoginUser"; %>
<%! String __webAppName = "CustomerVehicleOrderSubmit"; %>
<%! int res=-10; %><html>
<head>
<title><%=_PageName%></title>
<META HTTP-EQUIV="CONTENT-Type" CONTENT="text/html;charset=UTF-8"></META>
<bizsolo:link rel="stylesheet"/>
</head>
<body BGCOLOR="#FFFFFF">
<bizsolo:if test="<%=bean.getPropString("workitemName") != null%>">
  <table width="90%" cellpading="3" cellspacing="3" border="0">
    <tr>
       <td class="title" align="center" nowrap>
         Task: <bizsolo:getDS name="workitemName"/>
       </td>
    </tr>
  </table>
  <table width="90%" cellpading="3" cellspacing="3" border="0">
    <tr>
      <td class="Label" width="2%" align="left" nowrap>
        <bizsolo:getLabel name="BIZSITE_INSTRUCTION_LABEL" type="RESOURCE"/>
      </td>
      <td class="Data" width="5%" align="left" colspan=5 nowrap>
        <bizsolo:getDS name="bizsite_instruction"/>
      </td>
    </tr>
    <tr>
      <td class="Label" width="2%" align="left" nowrap>
        <bizsolo:getLabel name="BIZSITE_PRIORITY_LABEL" type="RESOURCE"/>
      </td>
      <td class="Data" width="5%" align="left" nowrap>
        <bizsolo:getDS name="bizsite_priority"/>
      </td>
      <td class="Label" width="2%" align="left" nowrap>
        <bizsolo:getLabel name="BIZSITE_STARTDATE_LABEL" type="RESOURCE"/>
      </td>
      <td class="Data" width="5%" align="left" nowrap>
        <bizsolo:getDS name="bizsite_startDate"/>
      </td>
      <td class="Label" width="2%" align="left" nowrap>
        <bizsolo:getLabel name="BIZSITE_DUEDATE_LABEL" type="RESOURCE"/>
      </td>
      <td class="Data" width="5%" align="left" nowrap>
        <bizsolo:getDS name="bizsite_dueDate"/>
      </td>
    </tr>
  </table>
</bizsolo:if>
<SCRIPT SRC="/sbm/bpmportal/javascript/validate.js"></SCRIPT>
<SCRIPT SRC="/sbm/bpmportal/javascript/validate2.js"></SCRIPT>
<SCRIPT SRC="/sbm/bpmportal/javascript/customValidation.js"></SCRIPT>
<SCRIPT SRC="/sbm/bpmportal/javascript/helpers.js"></SCRIPT>
<SCRIPT>var bizsiteroot='/sbm/bpmportal/javascript'; </SCRIPT>
<script language="JavaScript">
  function submit() {
    if (validate()) {
      document.form.submit();
    }
  }
</script>

<form method="post" name="form" onSubmit="action='<%=response.encodeURL("Start.jsp")%>'; return validate();this.onsubmit = new Function('return false');">




<bizsolo:pageInstruction>

</bizsolo:pageInstruction>





<br>
<table border=0 class="ApSegDataTbl">

<tr>
<td class="ApSegDataLabel"><bizsolo:getLabel name="userid" wsName="LoginUser"/></td>
<td class="ApSegDataVal"></td>
</tr>

<tr>
<td class="ApSegDataLabel"><bizsolo:getLabel name="password" wsName="LoginUser"/></td>
<td class="ApSegDataVal"></td>
</tr>

</table>



<input type=hidden name="crtApp" value="CustomerVehicleOrderSubmit">
<input type=hidden name="crtPage" value="LoginUser">
<input type=hidden name="activityMode" value="procReq">
<input type=hidden name="nextPage" value="<%=response.encodeUrl("Start.jsp") %>">









<table border=0 class="ApSegDataTbl">
<tr>
<td><input type=submit name="SB_Name" value="Submit" ONCLICK='clickedButton=this.name;'></td>

<td><input type=reset name="SB_Name"></td>

</tr>

</table>
</form>
<br>
</body>
</html>
