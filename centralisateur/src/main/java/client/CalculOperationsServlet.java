package client;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;

public class CalculOperationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/calculOperations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String numeroCompte = request.getParameter("numeroCompte");
        String typeCalcul = request.getParameter("typeCalcul");
        String dateStr = request.getParameter("date");
        String dateDebutStr = request.getParameter("dateDebut");
        String dateFinStr = request.getParameter("dateFin");

        try {
            String apiUrl = "http://localhost:5010/api/CompteDepot/";
            String result = "";
            String typeLabel = "";

            switch (typeCalcul) {
                case "solde":
                    apiUrl += "Solde?numeroCompte=" + numeroCompte + "&date=" + dateStr;
                    typeLabel = "Solde";
                    break;
                case "SoldeAvecInterets":
                    apiUrl += "SoldeAvecInterets?numeroCompte=" + numeroCompte + "&date=" + dateStr;
                    typeLabel = "Solde avec intérêts";
                    break;
                case "Interets":
                    apiUrl += "Interets?numeroCompte=" + numeroCompte + "&date=" + dateStr;
                    typeLabel = "Intérêts accumulés";
                    break;
                case "CalculInterets":
                    apiUrl += "CalculInterets?numeroCompte=" + numeroCompte + "&dateDebut=" + dateDebutStr + "&dateFin="
                            + dateFinStr;
                    typeLabel = "Intérêts sur période";
                    break;
                default:
                    throw new IllegalArgumentException("Type de calcul invalide");
            }

            result = getApiResult(apiUrl);

            String resultatFormate = result;
            try {
                double valeur = Double.parseDouble(result);
                DecimalFormat df = new DecimalFormat("#,##0.00"); // format bancaire
                resultatFormate = df.format(valeur);
            } catch (NumberFormatException e) {
                // ce n’est pas un nombre => on laisse brut
            }

            request.setAttribute("resultat", resultatFormate);
            request.setAttribute("typeLabel", typeLabel);
            request.setAttribute("numeroCompte", numeroCompte);
            request.setAttribute("typeCalcul", typeCalcul);
            request.getRequestDispatcher("/WEB-INF/calculOperations.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du calcul : " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/calculOperations.jsp").forward(request, response);
        }
    }

    private String getApiResult(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder jsonResponse = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            jsonResponse.append(line);
        }
        conn.disconnect();
        return jsonResponse.toString();
    }
}