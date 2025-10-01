package client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.net.URL;
import java.text.SimpleDateFormat;

import javax.naming.Context;
import javax.naming.InitialContext;

import com.courant.entity.TypeOperation;

public class ConsultSoldeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/WEB-INF/ConsultSold.jsp").forward(request, response);
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

            com.courant.remote.CompteCourantRemote remoteCompteCourantEJB = (com.courant.remote.CompteCourantRemote) context
                    .lookup(
                            "ejb:/compteCourant-1.0/CompteCourantBeanUnique!com.courant.remote.CompteCourantRemote");

            String numeroCompte = request.getParameter("numeroCompte");
            String dateOperationStr = request.getParameter("dateOperation");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false); // stricte
            Date dateOperation = null;
            try {
                dateOperation = sdf.parse(dateOperationStr);
            } catch (Exception e) {
                e.printStackTrace();
            }

            double solde = remoteCompteCourantEJB.getSoldeDate(numeroCompte, dateOperation);
            request.setAttribute("solde", solde);
            request.getRequestDispatcher("/WEB-INF/ConsultSold.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
