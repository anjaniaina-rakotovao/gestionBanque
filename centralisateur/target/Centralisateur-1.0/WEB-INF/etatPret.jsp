<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>État du Prêt</title>
</head>
<body>
<h2>État du prêt</h2>
<p>Capital restant à rembourser : ${capitalRestant}</p>
<p>Intérêts restants : ${interetRestant}</p>
<p>Total restant : ${reste}</p>

<a href="${pageContext.request.contextPath}/comptePret">Retour</a>
</body>
</html>
