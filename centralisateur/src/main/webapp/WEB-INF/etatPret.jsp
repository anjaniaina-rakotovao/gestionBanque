<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="fr">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>État du Prêt</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <!-- Navbar -->
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
                    <li><a href="${pageContext.request.contextPath}/comptePret" class="active">Mes Prêts</a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="welcome-section">
                <h1>📄 État du prêt</h1>
                <p class="welcome-message">Consultez les détails et le reste à rembourser.</p>
            </div>

            <div class="etat-pret-card">
                <h2>Détails du prêt</h2>
                <table class="etat-pret-table">
                    <tr>
                        <th>Capital restant à rembourser</th>
                        <td><strong>${capitalRestant} </strong></td>
                    </tr>
                    <tr>
                        <th>Intérêts restants</th>
                        <td><strong>${interetRestant} </strong></td>
                    </tr>
                    <tr>
                        <th>Total restant</th>
                        <td><strong>${reste} </strong></td>
                    </tr>
                </table>
                <a href="${pageContext.request.contextPath}/comptePret" class="btn-return">⬅ Retour</a>
            </div>

        </main>
    </body>

    </html>