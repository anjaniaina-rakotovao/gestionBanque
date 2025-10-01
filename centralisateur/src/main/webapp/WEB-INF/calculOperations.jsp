<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Calculs bancaires</title>
    <style>
        fieldset {
            margin-bottom: 20px;
            padding: 15px;
        }
    </style>
</head>
<body>
<h2>Calculs bancaires</h2>

<!-- Bloc Solde avec intérêts -->
<fieldset>
    <legend>Solde avec intérêts</legend>
    <form action="<%= request.getContextPath() %>/calculOperations" method="post">
        <input type="hidden" name="typeCalcul" value="SoldeAvecInterets">
        <label>Numéro de compte:</label>
        <input type="text" name="numeroCompte" required><br><br>
        <label>Date:</label>
        <input type="date" name="date" required><br><br>
        <button type="submit">Calculer Solde</button>
    </form>
</fieldset>

<!-- Bloc Intérêts -->
<fieldset>
    <legend>Intérêts</legend>
    <form action="<%= request.getContextPath() %>/calculOperations" method="post">
        <input type="hidden" name="typeCalcul" value="Interets">
        <label>Numéro de compte:</label>
        <input type="text" name="numeroCompte" required><br><br>
        <label>Date:</label>
        <input type="date" name="date" required><br><br>
        <button type="submit">Calculer Intérêts</button>
    </form>
</fieldset>

<!-- Bloc Calcul intérêts sur période -->
<fieldset>
    <legend>Calcul intérêts sur période</legend>
    <form action="<%= request.getContextPath() %>/calculOperations" method="post">
        <input type="hidden" name="typeCalcul" value="CalculInterets">
        <label>Numéro de compte:</label>
        <input type="text" name="numeroCompte" required><br><br>
        <label>Date début:</label>
        <input type="date" name="dateDebut" required><br><br>
        <label>Date fin:</label>
        <input type="date" name="dateFin" required><br><br>
        <button type="submit">Calculer Intérêts sur période</button>
    </form>
</fieldset>

<!-- Bloc résultat -->
<% if (request.getAttribute("resultat") != null) { %>
    <fieldset>
        <legend>Résultat</legend>
        <p><%= request.getAttribute("resultat") %></p>
    </fieldset>
<% } %>

</body>
</html>
