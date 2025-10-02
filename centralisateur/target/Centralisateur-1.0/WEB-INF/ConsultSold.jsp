<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html lang="fr">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Consulter Solde</title>

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
                        <h2>Consulter le solde de votre compte courant</h2>
                    </div>

                    <div class="quick-actions">
                        <form method="post" action="${pageContext.request.contextPath}/solde">
                            <label for="numeroCompte">Numéro de compte</label>
                            <input type="text" id="numeroCompte" name="numeroCompte" required
                                placeholder="Ex: 123456789" />

                            <label for="dateOperation">Date de consultation</label>
                            <input type="date" id="dateOperation" name="dateOperation" required />

                            <input type="submit" value="Consulter le solde" class="btn-submit" />
                        </form>

                        <c:if test="${not empty solde}">
                            <div class="result-box">
                                <p>
                                    Solde au <strong>${param.dateOperation}</strong> : <strong
                                        class="solde-amount">${solde}</strong>
                                </p>
                            </div>
                        </c:if>
                    </div>
                </main>
            </body>

            </html>