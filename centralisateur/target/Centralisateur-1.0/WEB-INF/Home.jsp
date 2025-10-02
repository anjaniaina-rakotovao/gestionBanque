<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Votre Banque</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <span class="logo-icon">🏦</span>
                <span class="logo-text">VotreBanque</span>
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/choixsolde">Mon Solde</a></li>
                <li><a href="${pageContext.request.contextPath}/operation">Opérations</a></li>
                <li><a href="${pageContext.request.contextPath}/depot">Épargne</a></li>
                <li><a href="${pageContext.request.contextPath}/comptePret">Mes Prêts</a></li>
            </ul>
        </div>
    </nav>

    <main class="main-content">
        <div class="welcome-section">
            <h1>Bienvenue dans votre espace bancaire</h1>
            <p class="welcome-message">
                Gérez vos finances en toute simplicité. Accédez à vos comptes, 
                effectuez vos opérations et consultez vos épargnes en quelques clics.
            </p>
        </div>

        <div class="quick-actions">
            <div class="action-card">
                <div class="card-icon">💰</div>
                <h3>Consulter mon solde</h3>
                <p>Visualisez l'état de vos comptes</p>
                <a href="${pageContext.request.contextPath}/choixsolde" class="btn-action">Accéder</a>
            </div>

            <div class="action-card">
                <div class="card-icon">💳</div>
                <h3>Effectuer une opération</h3>
                <p>Créditer ou débiter votre compte</p>
                <a href="${pageContext.request.contextPath}/operation" class="btn-action">Accéder</a>
            </div>

            <div class="action-card">
                <div class="card-icon">📈</div>
                <h3>Gérer mon épargne</h3>
                <p>Faites fructifier votre argent</p>
                <a href="${pageContext.request.contextPath}/depot" class="btn-action">Accéder</a>
            </div>

            <div class="action-card">
                <div class="card-icon">🏠</div>
                <h3>Mes prêts</h3>
                <p>Suivez vos emprunts en cours</p>
                <a href="${pageContext.request.contextPath}/comptePret" class="btn-action">Accéder</a>
            </div>
        </div>
    </main>
</body>
</html>