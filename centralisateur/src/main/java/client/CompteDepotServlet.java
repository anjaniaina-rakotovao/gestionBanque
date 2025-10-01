package client;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.courant.entity.TypeOperation;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.InitialContext;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

public class CompteDepotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            URL url = new URL("http://localhost:5010/api/CompteDepot/TypesRetraitDepot");
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

            Gson gson = new Gson();
            Type listType = new TypeToken<List<Map<String, Object>>>() {}.getType();
            List<Map<String, Object>> rawList = gson.fromJson(jsonResponse.toString(), listType);

            List<TypeOperation> typeOperations = new ArrayList<>();

            // Context JNDI pour EJB
            Properties props = new Properties();
            props.put(Context.INITIAL_CONTEXT_FACTORY, "org.wildfly.naming.client.WildFlyInitialContextFactory");
            props.put(Context.PROVIDER_URL, "http-remoting://localhost:8080");
            Context context = new InitialContext(props);

            com.courant.remote.CompteCourantRemote remoteCompteCourantEJB =
                    (com.courant.remote.CompteCourantRemote) context.lookup(
                            "ejb:/compteCourant-1.0/CompteCourantBeanUnique!com.courant.remote.CompteCourantRemote");

            for (Map<String, Object> obj : rawList) {
                Double idDouble = (Double) obj.get("idTypeOperation");
                int idTypeOperation = idDouble.intValue();

                TypeOperation tp = remoteCompteCourantEJB.getTypeOperationId(idTypeOperation);
                if (tp != null) {
                    typeOperations.add(tp);
                }
            }

            request.setAttribute("typeOperations", typeOperations);
            request.getRequestDispatcher("/WEB-INF/operationDepotForm.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Properties props = new Properties();
            props.put(Context.INITIAL_CONTEXT_FACTORY, "org.wildfly.naming.client.WildFlyInitialContextFactory");
            props.put(Context.PROVIDER_URL, "http-remoting://localhost:8080");
            Context context = new InitialContext(props);

            com.courant.remote.CompteCourantRemote remoteCompteCourantEJB =
                    (com.courant.remote.CompteCourantRemote) context.lookup(
                            "ejb:/compteCourant-1.0/CompteCourantBeanUnique!com.courant.remote.CompteCourantRemote");

            String numeroCompte = request.getParameter("numeroCompte");
            Integer typeOperationId = Integer.valueOf(request.getParameter("typeOperation"));
            Double montant = Double.valueOf(request.getParameter("montant"));
            String dateOperationStr = request.getParameter("dateOperation");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            Date dateOperation = sdf.parse(dateOperationStr);

            TypeOperation tp = remoteCompteCourantEJB.getTypeOperationId(typeOperationId);
            String codeOperation = tp.getCodeOperation();

            if ("DEPOT".equals(codeOperation)) {
                effectuerOperation("http://localhost:5010/api/CompteDepot/Depot", dateOperation, montant, numeroCompte);
            } else if ("RETRAIT".equals(codeOperation)) {
                effectuerOperation("http://localhost:5010/api/CompteDepot/Retrait", dateOperation, montant, numeroCompte);
            }

            response.sendRedirect(request.getContextPath() + "/depot");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void effectuerOperation(String urlStr, Date dateOperation, Double montant, String numeroCompte) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        String jsonInput = "{"
                + "\"dateOperation\":\"" + new SimpleDateFormat("yyyy-MM-dd").format(dateOperation) + "\","
                + "\"montant\":" + montant + ","
                + "\"numeroCompte\":\"" + numeroCompte + "\""
                + "}";

        conn.getOutputStream().write(jsonInput.getBytes("UTF-8"));
        conn.getOutputStream().flush();
        conn.getOutputStream().close();

        int responseCode = conn.getResponseCode();
        if (responseCode != HttpURLConnection.HTTP_OK && responseCode != HttpURLConnection.HTTP_CREATED) {
            throw new RuntimeException("Échec de l’opération : HTTP code " + responseCode);
        }

        conn.disconnect();
    }
}
