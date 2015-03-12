<%

  if(session.getAttribute("loggedIn") != null) {
  	out.println("Welcome to my website");
  } else {
  	response.sendRedirect("login.jsp");
  }

%>