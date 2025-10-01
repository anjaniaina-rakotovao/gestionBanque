<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Gestion Prêt</title>
</head>
<body>
<h2>Faire un Prêt</h2>
<form method="post" action="${pageContext.request.contextPath}/comptePret">
    <input type="hidden" name="action" value="fairePret"/>
    Numéro de compte: <input type="text" name="numeroCompte" required/><br/>
    Montant: <input type="number" step="0.01" name="montant" required/><br/>
    Durée (mois): <input type="number" name="dureeMois" required/><br/>
    Date: <input type="date" name="dateOperation" required/><br/>
    <button type="submit">Faire Prêt</button>
</form>

<hr/>

<h2>Faire un Remboursement</h2>
<form method="post" action="${pageContext.request.contextPath}/comptePret">
    <input type="hidden" name="action" value="faireRemboursement"/>
    Numéro de compte: <input type="text" name="numeroCompte" required/><br/>
    ID Prêt: <input type="number" name="idPret" required/><br/>
    Montant: <input type="number" step="0.01" name="montant" required/><br/>
    Date: <input type="date" name="dateOperation" required/><br/>
    <button type="submit">Rembourser</button>
</form>

<hr/>

<h2>Voir l'état du prêt</h2>
<form method="post" action="${pageContext.request.contextPath}/comptePret">
    <input type="hidden" name="action" value="etatPret"/>
    Numéro de compte: <input type="text" name="numeroCompte" required/><br/>
    ID Prêt: <input type="number" name="idPret" required/><br/>
    Date: <input type="date" name="dateOperation" required/><br/>
    <button type="submit">Voir État</button>
</form>
</body>
</html>
