<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Choix consultation solde</title>
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
                <h1>Consultez vos soldes</h1>
                <p class="welcome-message">
                    Choisissez vos soldes à consulter
                </p>
            </div>
            <div class="quick-actions">
                <div class="action-card">
                    <div class="card-icon">💰</div>
                    <h3>Compte courant</h3>
                    <p>Consultez le solde de votre compte courant</p>
                    <a href="${pageContext.request.contextPath}/solde" class="btn-action">Consulter</a>
                </div>

                <div class="action-card">
                    <div class="card-icon">💳</div>
                    <h3>Compte épargne</h3>
                    <p>Consultez le solde de votre compte épargne</p>
                    <a href="${pageContext.request.contextPath}/calculOperations" class="btn-action">Consulter</a>
                </div>
            </div>
            </div>
        </main>
    </body>

    </html>