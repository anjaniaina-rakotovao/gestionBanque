<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Consulter Solde</title>
</head>
<body>
<h2>Ajouter une opération</h2>

<form method="post" action="${pageContext.request.contextPath}/solde">
    <label for="numeroCompte">Numéro du compte :</label>
    <input type="text" id="numeroCompte" name="numeroCompte" required /><br/><br/>

    <label for="dateOperation">Date :</label>
    <input type="date" id="dateOperation" name="dateOperation" required /><br/><br/>

    <input type="submit" value="Consulter" />
</form>

<c:if test="${not empty solde}">
    <p>
        Votre solde le <b>${param.dateOperation}</b> est : <b>${solde}</b>
    </p>
</c:if>

</body>
</html>
