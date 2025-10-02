<%@ page language="java" contentType="text/html; charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="fr">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Opérations - Votre Banque</title>
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
                        <li><a href="${pageContext.request.contextPath}/comptePret">Mes Prêts</a></li>
                    </ul>
                </div>
            </nav>

            <!-- Contenu principal -->
            <main class="main-content">
                <div class="welcome-section">
                    <h1>Ajouter ou retirer de l'argent</h1>
                    <p class="welcome-message">
                        Choisissez le type d'opération et entrez les informations nécessaires.
                    </p>
                </div>

                <div class="quick-actions">
                    <div class="action-card wide-form">
                        <div class="card-icon">💳</div>
                        <h3>Nouvelle Opération</h3>

                        <form method="post" action="${pageContext.request.contextPath}/operation">
                            <div class="form-group">
                                <label for="numeroCompte">Numéro du compte :</label>
                                <input type="text" id="numeroCompte" name="numeroCompte" required />
                            </div>

                            <div class="form-group">
                                <label>Type d'opération :</label>
                                <div class="operation-selector-operation">
                                    <c:forEach var="typeOp" items="${typeOperations}">
                                        <label class="operation-option-operation">
                                            <input type="radio" name="typeOperation" value="${typeOp.idTypeOperation}"
                                                required>
                                            <span class="operation-icon">
                                                <c:choose>
                                                    <c:when test="${typeOp.codeOperation eq 'CREDIT'}">➕</c:when>
                                                    <c:when test="${typeOp.codeOperation eq 'DEBIT'}">➖</c:when>
                                                    <c:otherwise>⚙️</c:otherwise>
                                                </c:choose>
                                            </span>
                                            <span class="operation-text">${typeOp.codeOperation}</span>
                                        </label>
                                    </c:forEach>
                                </div>

                            </div>

                            <div class="form-group">
                                <label for="montant">Montant :</label>
                                <input type="number" id="montant" name="montant" step="0.01" required />
                            </div>

                            <div class="form-group">
                                <label for="dateOperation">Date :</label>
                                <input type="date" id="dateOperation" name="dateOperation" required />
                            </div>

                            <input type="submit" class="btn-submit" value="Enregistrer" />
                        </form>
                    </div>
                </div>
            </main>

            <script>
                const options = document.querySelectorAll('.operation-option-operation');
                options.forEach(option => {
                    option.addEventListener('click', () => {
                        options.forEach(o => o.classList.remove('selected'));
                        option.classList.add('selected');
                    });
                });
            </script>
        </body>

        </html>