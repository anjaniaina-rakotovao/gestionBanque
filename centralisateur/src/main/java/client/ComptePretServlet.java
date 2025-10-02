package client;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.pret.entity.TypeOperation;
import com.pret.remote.ComptePretRemote;

public class ComptePretServlet extends HttpServlet {

    private ComptePretRemote getComptePretRemote() throws Exception {
        Properties props = new Properties();
        props.put(Context.INITIAL_CONTEXT_FACTORY, "org.wildfly.naming.client.WildFlyInitialContextFactory");
        props.put(Context.PROVIDER_URL, "http-remoting://localhost:8080");
        Context context = new InitialContext(props);

        return (ComptePretRemote) context.lookup(
                "ejb:/comptePret-1.0/ComptePretBeanUnique!com.pret.remote.ComptePretRemote");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/WEB-INF/comptePretForm.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ComptePretRemote remote = getComptePretRemote();

            String action = request.getParameter("action");

            String numeroCompte = request.getParameter("numeroCompte");
            String dateStr = request.getParameter("dateOperation");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateOperation = sdf.parse(dateStr);

            if ("fairePret".equals(action)) {
                double montant = Double.parseDouble(request.getParameter("montant"));
                int dureeMois = Integer.parseInt(request.getParameter("dureeMois"));
                remote.fairePretDate(numeroCompte, montant, dureeMois, dateOperation);

            } else if ("faireRemboursement".equals(action)) {
                int idPret = Integer.parseInt(request.getParameter("idPret"));
                double montant = Double.parseDouble(request.getParameter("montant"));
                remote.faireRemboursement(numeroCompte, idPret, montant, dateOperation);

            } else if ("etatPret".equals(action)) {
                int idPret = Integer.parseInt(request.getParameter("idPret"));
                double reste = remote.obtenirResteAPayer(numeroCompte, idPret, dateOperation);
                double capitalRestant = remote.obtenirResteCapBrutRembourse(numeroCompte, idPret, dateOperation);
                double interetRestant = remote.obtenirResteInteretRembourse(numeroCompte, idPret, dateOperation);

                DecimalFormat df = new DecimalFormat("#,##0.00");

                request.setAttribute("reste", df.format(reste));
                request.setAttribute("capitalRestant", df.format(capitalRestant));
                request.setAttribute("interetRestant", df.format(interetRestant));
                request.getRequestDispatcher("/WEB-INF/etatPret.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/comptePret");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
