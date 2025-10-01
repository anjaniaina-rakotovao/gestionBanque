<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Formulaire de retrait ou de depot</title>
</head>
<body>
<h2>Ajouter une opération</h2>

<form method="post" action="${pageContext.request.contextPath}/depot">
    <label for="numeroCompte">Numéro du compte :</label>
    <input type="text" id="numeroCompte" name="numeroCompte" required /><br/><br/>

    <label for="typeOperation">Type d'opération :</label>
    <select id="typeOperation" name="typeOperation">
        <c:forEach var="typeOp" items="${typeOperations}">
            <option value="${typeOp.idTypeOperation}">${typeOp.codeOperation}</option>
        </c:forEach>
    </select><br/><br/>

    <label for="montant">Montant :</label>
    <input type="number" id="montant" name="montant" step="0.01" required /><br/><br/>

    <label for="dateOperation">Date :</label>
    <input type="date" id="dateOperation" name="dateOperation" required /><br/><br/>

    <input type="submit" value="Enregistrer" />
</form>

</body>
</html>
