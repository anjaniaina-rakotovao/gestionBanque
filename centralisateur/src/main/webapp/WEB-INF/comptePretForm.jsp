<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Prêt</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .tabs-container {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
        }

        .tabs-header {
            display: flex;
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }

        .tab-button {
            flex: 1;
            padding: 18px 20px;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            color: #64748b;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .tab-button:hover {
            background: #f1f5f9;
            color: #1e3a8a;
        }

        .tab-button.active {
            color: #1e40af;
            background: #ffffff;
            border-bottom-color: #1e40af;
        }

        .tab-icon {
            font-size: 1.3rem;
        }

        .tabs-content {
            padding: 30px;
        }

        .tab-pane {
            display: none;
        }

        .tab-pane.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .tab-description {
            color: #64748b;
            margin-bottom: 25px;
            font-size: 0.95rem;
            text-align: center;
            padding: 15px;
            background: #f0f9ff;
            border-radius: 8px;
        }

        .form-grid {
            display: grid;
            gap: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        @media (max-width: 768px) {
            .tabs-header {
                flex-direction: column;
            }

            .tab-button {
                border-bottom: none;
                border-left: 3px solid transparent;
            }

            .tab-button.active {
                border-left-color: #1e40af;
                border-bottom-color: transparent;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }

        /* Résultats */
        .result-section {
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            border: 2px solid #86efac;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.15);
        }

        .result-section h3 {
            color: #065f46;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .result-content {
            background: #ffffff;
            padding: 15px;
            border-radius: 8px;
            color: #047857;
            white-space: pre-wrap;
            font-family: monospace;
            font-size: 0.9rem;
        }
    </style>
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
            <h1>💳 Gestion des prêts</h1>
            <p class="welcome-message">Gérez vos prêts en toute simplicité</p>
        </div>

        <!-- Affichage des résultats -->
        <% if (request.getAttribute("resultat") != null) { %>
            <div class="result-section">
                <h3>✅ Résultat de l'opération</h3>
                <div class="result-content"><%= request.getAttribute("resultat") %></div>
            </div>
        <% } %>

        <% if (request.getAttribute("erreur") != null) { %>
            <div class="error-box">
                <strong>❌ Erreur :</strong> <%= request.getAttribute("erreur") %>
            </div>
        <% } %>

        <!-- Système d'onglets -->
        <div class="tabs-container">
            <div class="tabs-header">
                <button class="tab-button active" data-tab="pret">
                    <span class="tab-icon">💰</span>
                    <span>Faire un prêt</span>
                </button>
                <button class="tab-button" data-tab="remboursement">
                    <span class="tab-icon">🔄</span>
                    <span>Rembourser</span>
                </button>
                <button class="tab-button" data-tab="etat">
                    <span class="tab-icon">📄</span>
                    <span>Consulter</span>
                </button>
            </div>

            <div class="tabs-content">
                <!-- Onglet : Faire un prêt -->
                <div class="tab-pane active" id="pret">
                    <div class="tab-description">
                        💡 Demandez un nouveau prêt pour votre compte
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/comptePret" class="form-grid">
                        <input type="hidden" name="action" value="fairePret"/>
                        
                        <div class="form-group">
                            <label for="pret-compte">Numéro de compte</label>
                            <input type="text" id="pret-compte" name="numeroCompte" required placeholder="Ex: EP123456789"/>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="pret-montant">Montant du prêt</label>
                                <input type="number" id="pret-montant" step="0.01" name="montant" required placeholder="5000.00"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="pret-duree">Durée (mois)</label>
                                <input type="number" id="pret-duree" name="dureeMois" required placeholder="12"/>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="pret-date">Date de l'opération</label>
                            <input type="date" id="pret-date" name="dateOperation" required/>
                        </div>
                        
                        <button type="submit" class="btn-submit">💰 Demander le prêt</button>
                    </form>
                </div>

                <!-- Onglet : Faire un remboursement -->
                <div class="tab-pane" id="remboursement">
                    <div class="tab-description">
                        💡 Remboursez tout ou partie de votre prêt
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/comptePret" class="form-grid">
                        <input type="hidden" name="action" value="faireRemboursement"/>
                        
                        <div class="form-group">
                            <label for="remb-compte">Numéro de compte</label>
                            <input type="text" id="remb-compte" name="numeroCompte" required placeholder="Ex: EP123456789"/>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="remb-idpret">ID du prêt</label>
                                <input type="number" id="remb-idpret" name="idPret" required placeholder="101"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="remb-montant">Montant à rembourser</label>
                                <input type="number" id="remb-montant" step="0.01" name="montant" required placeholder="500.00"/>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="remb-date">Date du remboursement</label>
                            <input type="date" id="remb-date" name="dateOperation" required/>
                        </div>
                        
                        <button type="submit" class="btn-submit">🔄 Effectuer le remboursement</button>
                    </form>
                </div>

                <!-- Onglet : Voir état du prêt -->
                <div class="tab-pane" id="etat">
                    <div class="tab-description">
                        💡 Consultez le détail et l'état d'un prêt
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/comptePret" class="form-grid">
                        <input type="hidden" name="action" value="etatPret"/>
                        
                        <div class="form-group">
                            <label for="etat-compte">Numéro de compte</label>
                            <input type="text" id="etat-compte" name="numeroCompte" required placeholder="Ex: EP123456789"/>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="etat-idpret">ID du prêt</label>
                                <input type="number" id="etat-idpret" name="idPret" required placeholder="101"/>
                            </div>
                            
                            <div class="form-group">
                                <label for="etat-date">Date de consultation</label>
                                <input type="date" id="etat-date" name="dateOperation" required/>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-submit">📄 Consulter l'état</button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script>
        // Gestion des onglets
        const tabButtons = document.querySelectorAll('.tab-button');
        const tabPanes = document.querySelectorAll('.tab-pane');

        tabButtons.forEach(button => {
            button.addEventListener('click', () => {
                const targetTab = button.getAttribute('data-tab');
                
                // Désactiver tous les onglets
                tabButtons.forEach(btn => btn.classList.remove('active'));
                tabPanes.forEach(pane => pane.classList.remove('active'));
                
                // Activer l'onglet sélectionné
                button.classList.add('active');
                document.getElementById(targetTab).classList.add('active');
            });
        });
    </script>
</body>

</html>