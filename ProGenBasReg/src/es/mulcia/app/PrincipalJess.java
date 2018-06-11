package es.mulcia.app;
import java.util.*;
import jess.Fact;
import jess.JessException;
import jess.Rete;

public class PrincipalJess {

    public static void main(String[] args) {
    	System.out.println(new Date());
        System.out.println("Problema del transporte");
       
        // Creamos el motor RETE
        Rete jess = new Rete();
        
        try {
        	adjacencyRepresentation(jess);
            // Reset ¡Muy importante!
        	jess.reset();
            // Ejecutamos el motor
            jess.run();
            // Recogemos los resultados de los hechos generados (y pre-existentes)
            Iterator<?> it = jess.listFacts();
            while(it.hasNext()){ 
                Fact dd = (Fact)it.next();
                System.out.println(dd);
            }
            jess.clear();
        } catch (JessException e) {
            // Traza del error
            e.printStackTrace();
        }
    }
    
    public static void genetic1(Rete jess) throws JessException{
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Principal.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/Datos.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Modulos.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Inicializacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Evaluacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-EvaluarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-EvaluarMejor.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Seleccion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-SeleccionarPadre.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Cruce.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-CruzarPadres.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-Mutacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-MutarElemento.clp");
    }
    public static void genetic2(Rete jess) throws JessException{
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Principal.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/Datos.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Modulos.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Inicializacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-GenerarMatriz.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Evaluacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-EvaluarMejor.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Seleccion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-SeleccionarPadre.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Cruce.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-DividirRem.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-GenerarHijos.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Mutacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-MutarElemento.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-PrepararMutacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-RealizarMutacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-Reemplazo.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic2/TransporteLineal-Genetic2-EliminarPadres.clp");
    }
    
    public static void adjacencyRepresentation(Rete jess) throws JessException{
    	jess.batch("es/mulcia/rbs/rules/tsp.adjacency_representation/TSP-AdyacencyRepresentation-Principal.clp");
    	jess.batch("es/mulcia/rbs/rules/tsp.adjacency_representation/Datos.clp");
    	jess.batch("es/mulcia/rbs/rules/tsp.adjacency_representation/TSP-AdyacencyRepresentation-Modulos.clp");
    	jess.batch("es/mulcia/rbs/rules/tsp.adjacency_representation/TSP-AdyacencyRepresentation-Inicializacion.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/transportelineal.genetic1/TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch("es/mulcia/rbs/rules/tsp.adjacency_representation/TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");

    }
}