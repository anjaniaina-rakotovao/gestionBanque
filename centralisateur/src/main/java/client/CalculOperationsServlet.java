package client;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

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

            if ("SoldeAvecInterets".equals(typeCalcul)) {
                apiUrl += "SoldeAvecInterets?numeroCompte=" + numeroCompte + "&date=" + dateStr;
                result = getApiResult(apiUrl);

            } else if ("Interets".equals(typeCalcul)) {
                apiUrl += "Interets?numeroCompte=" + numeroCompte + "&date=" + dateStr;
                result = getApiResult(apiUrl);

            } else if ("CalculInterets".equals(typeCalcul)) {
                apiUrl += "CalculInterets?numeroCompte=" + numeroCompte + "&dateDebut=" + dateDebutStr + "&dateFin="
                        + dateFinStr;
                result = getApiResult(apiUrl);
            }

            request.setAttribute("resultat", result);
            request.getRequestDispatcher("/WEB-INF/calculOperations.jsp").forward(request, response);


        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("resultat", "Erreur : " + e.getMessage());
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
