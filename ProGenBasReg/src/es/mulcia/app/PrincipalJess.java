package es.mulcia.app;
import java.io.File;
import java.util.*;
import jess.Fact;
import jess.JessException;
import jess.Rete;

public class PrincipalJess {

	private final static String RULES = "es/mulcia/rbs/rules/";
	private final static String CONFIG = "es/mulcia/rbs/config/";
	private final static String DATA = "es/mulcia/rbs/data/";
	private final static String GENETIC_1 = "transportelineal.genetic1/";
	private final static String GENETIC_2 = "transportelineal.genetic2/";
	private final static String ADJACENCY = "tsp.adjacency_representation/";
	private final static String ORDINAL = "tsp.ordinal_representation/";
	
	
    public static void main(String[] args) {
    	System.out.println(new Date());
        System.out.println("Problema del transporte");
       
        // Creamos el motor RETE
        Rete jess = new Rete();
        
        try {
        	//genetic1(jess);
        	genetic2(jess);
        	//adjacencyRepresentation(jess);
        	//ordinalRepresentation(jess);
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
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Principal.clp");
    	jess.batch(CONFIG+"TransporteLineal.clp");
    	jess.batch(DATA+"TransporteLineal-Data.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Modulos.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Inicializacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Evaluacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-EvaluarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-EvaluarMejor.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Seleccion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-SeleccionarPadre.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Cruce.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-CruzarPadres.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Mutacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-MutarElemento.clp");
    }
    public static void genetic2(Rete jess) throws JessException{
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Principal.clp");
    	jess.batch(CONFIG+"TransporteLineal.clp");
    	jess.batch(DATA+"TransporteLineal-Data.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Modulos.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Inicializacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-GenerarMatriz.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Evaluacion.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-EvaluarMejor.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Seleccion.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-SeleccionarPadre.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Cruce.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-DividirRem.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-GenerarHijos.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Mutacion.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-MutarElemento.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-PrepararMutacion.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-RealizarMutacion.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-Reemplazo.clp");
    	jess.batch(RULES+GENETIC_2+"TransporteLineal-Genetic2-EliminarPadres.clp");
    }
    
    public static void adjacencyRepresentation(Rete jess) throws JessException{
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Principal.clp");
    	jess.batch(CONFIG+"TSP.clp");
    	jess.batch(DATA+"TSP-Data.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Modulos.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Inicializacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Evaluacion.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-EvaluarMejor.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Seleccion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-SeleccionarPadre.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Cruce.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-CruceAEC.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-CruceSCC.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-CruceHC.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-RepararCiclos.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Mutacion.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-MutarElemento.clp");
    }
    
    public static void ordinalRepresentation(Rete jess) throws JessException{
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Principal.clp");
    	jess.batch(CONFIG+"TSP.clp");
    	jess.batch(DATA+"TSP-Data.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-Modulos.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-GenerarListaOrdinal.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-Inicializacion.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-Inicializacion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-GenerarLista.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-DesordenarLista.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-GenerarListaOrdinal.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-Evaluacion.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-EvaluarLista.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-EvaluarMejor.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-Seleccion.clp");
    	jess.batch(RULES+GENETIC_1+"TransporteLineal-Genetic1-SeleccionarPadre.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-Cruce.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-CruzarPadres.clp");
    	jess.batch(RULES+ADJACENCY+"TSP-AdyacencyRepresentation-Mutacion.clp");
    	jess.batch(RULES+ORDINAL+"TSP-OrdinalRepresentation-MutarElemento.clp");
    }
}