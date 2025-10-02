<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Compte Épargne - Opérations</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <meta charset="UTF-8">

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

        <div class="main-content">
            <div class="welcome-section">
                <h1>💰 Compte Épargne</h1>
                <p class="welcome-message">Consultez votre solde et calculez vos intérêts</p>
            </div>

            <% if (request.getAttribute("erreur") !=null) { %>
                <div class="error-box-depot">
                    <strong>❌ Erreur :</strong>
                    <%= request.getAttribute("erreur") %>
                </div>
                <% } %>

                    <% if (request.getAttribute("resultat") !=null) { %>
                        <div class="result-box-depot">
                            <h3>
                                <%= request.getAttribute("typeLabel") %>
                            </h3>
                            <p>Compte : <strong>
                                    <%= request.getAttribute("numeroCompte") %>
                                </strong></p>
                            <p class="solde-amount-depot">
                                <%= request.getAttribute("resultat") %>
                            </p>
                        </div>
                        <% } %>

                            <form method="post" class="wide-form" action="${pageContext.request.contextPath}/calculOperations">

                                <div class="content-wrapper">
                                    <div class="left-column">
                                        <div class="info-box">
                                            ℹ️ Sélectionnez le type d'opération que vous souhaitez effectuer
                                        </div>

                                        <div class="operation-selector">
                                            <label class="operation-option" id="opt-solde">
                                                <input type="radio" name="typeCalcul" value="solde" <%="solde"
                                                    .equals(request.getAttribute("typeCalcul")) ? "checked" : "" %>>
                                                <div class="operation-icon">💵</div>
                                                <div class="operation-title">Solde</div>
                                                <div class="operation-desc">Consulter le solde</div>
                                            </label>

                                            <label class="operation-option" id="opt-soldeInterets">
                                                <input type="radio" name="typeCalcul" value="SoldeAvecInterets"
                                                    <%="SoldeAvecInterets" .equals(request.getAttribute("typeCalcul"))
                                                    ? "checked" : "" %>>
                                                <div class="operation-icon">📈</div>
                                                <div class="operation-title">Solde + Intérêts</div>
                                                <div class="operation-desc">Solde avec intérêts</div>
                                            </label>

                                            <label class="operation-option" id="opt-interets">
                                                <input type="radio" name="typeCalcul" value="Interets" <%="Interets"
                                                    .equals(request.getAttribute("typeCalcul")) ? "checked" : "" %>>
                                                <div class="operation-icon">💎</div>
                                                <div class="operation-title">Intérêts</div>
                                                <div class="operation-desc">Intérêts accumulés</div>
                                            </label>

                                            <label class="operation-option" id="opt-periode">
                                                <input type="radio" name="typeCalcul" value="CalculInterets"
                                                    <%="CalculInterets" .equals(request.getAttribute("typeCalcul"))
                                                    ? "checked" : "" %>>
                                                <div class="operation-icon">📊</div>
                                                <div class="operation-title">Sur période</div>
                                                <div class="operation-desc">Calcul sur intervalle</div>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="right-column">
                                        <div class="form-group">
                                            <label for="numeroCompte">Numéro de compte épargne</label>
                                            <input type="text" id="numeroCompte" name="numeroCompte"
                                                value="<%= request.getAttribute(" numeroCompte") !=null ?
                                                request.getAttribute("numeroCompte") : "" %>"
                                            required placeholder="Ex: EP123456789">
                                        </div>

                                        <!-- Champs date simple -->
                                        <div class="form-group date-fields" id="dateSimple">
                                            <label for="date">Date de consultation</label>
                                            <input type="date" id="date" name="date">
                                        </div>

                                        <!-- Champs période -->
                                        <div class="date-fields" id="datePeriode">
                                            <div class="form-group">
                                                <label for="dateDebut">Date de début</label>
                                                <input type="date" id="dateDebut" name="dateDebut">
                                            </div>
                                            <div class="form-group">
                                                <label for="dateFin">Date de fin</label>
                                                <input type="date" id="dateFin" name="dateFin">
                                            </div>
                                        </div>

                                        <input type="submit" value="Calculer" class="btn-submit">
                                    </div>

                                </div>
                            </form>
        </div>

        <script>
            const radios = document.querySelectorAll('input[name="typeCalcul"]');
            const dateSimple = document.getElementById('dateSimple');
            const datePeriode = document.getElementById('datePeriode');
            const options = document.querySelectorAll('.operation-option');

            function updateFields() {
                const selected = document.querySelector('input[name="typeCalcul"]:checked');

                options.forEach(opt => opt.classList.remove('selected'));
                if (selected) {
                    selected.closest('.operation-option').classList.add('selected');
                }

                if (selected && selected.value === 'CalculInterets') {
                    dateSimple.classList.remove('active');
                    datePeriode.classList.add('active');
                    document.getElementById('date').removeAttribute('required');
                    document.getElementById('dateDebut').setAttribute('required', 'required');
                    document.getElementById('dateFin').setAttribute('required', 'required');
                } else {
                    dateSimple.classList.add('active');
                    datePeriode.classList.remove('active');
                    document.getElementById('date').setAttribute('required', 'required');
                    document.getElementById('dateDebut').removeAttribute('required');
                    document.getElementById('dateFin').removeAttribute('required');
                }
            }

            radios.forEach(radio => {
                radio.addEventListener('change', updateFields);
            });

            // Initialisation au chargement
            updateFields();
        </script>
    </body>

    </html>