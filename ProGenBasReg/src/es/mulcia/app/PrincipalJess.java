package es.mulcia.app;

import java.util.*;
import jess.Fact;
import jess.JessException;
import jess.Rete;
import jess.Value;

public class PrincipalJess {

	private final static String RULES = "es/mulcia/rbs/rules/";
	private final static String CONFIG = "es/mulcia/rbs/config/";
	private final static String DATA = "es/mulcia/rbs/data/";
	private final static String GENETIC_1 = "transportelineal.genetic1/";
	private final static String GENETIC_2 = "transportelineal.genetic2/";
	private final static String ADJACENCY = "tsp.adjacency_representation/";
	private final static String ORDINAL = "tsp.ordinal_representation/";
	private final static String PATH = "tsp.path_representation/";

	public static void main(String[] args) {
		// Creamos el motor RETE
		Rete jess = new Rete();

		try {
			// genetic1(jess);
			genetic2(jess, "Transporte_2x3_0.clp");
			// adjacencyRepresentation(jess);
			// ordinalRepresentation(jess);
			//pathRepresentationCX(jess,"viajante_5_0.clp");
			//adjacencyRepresentationHC(jess,"viajante_5_0.clp");
			// Reset ¡Muy importante!
			jess.reset();
			// Ejecutamos el motor
			jess.run();
			// Recogemos los resultados de los hechos generados (y
			// pre-existentes)
			Iterator<?> it = jess.listFacts();
			while (it.hasNext()) {
				Fact dd = (Fact) it.next();
				System.out.println(dd);
			}
			jess.clear();
		} catch (JessException e) {
			// Traza del error
			e.printStackTrace();
		}
	}

	private static void adjacencyRepresentationPruebaHC(Rete jess) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Adyacency-HC.clp");
		jess.batch(DATA + "pv/Viajante_5_0.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Modulos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Evaluacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Cruce.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceAEC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceSCC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-RepararCiclos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-MutarElemento.clp");
		
	}

	public static void ejecutarJess(String tipo, String datos, int iteraciones) {
		ArrayList<Long> tiempos = new ArrayList<>();
		ArrayList<Integer> esfuerzos = new ArrayList<>();
		for (int i = 0; i < iteraciones; i++) {
			// Creamos el motor RETE
			Rete jess = new Rete();
			Value value = null;
			long time = -1;
			try {
				switch (tipo) {
				case "genetic1":
					genetic1(jess, datos);
					break;
				case "genetic2":
					genetic2(jess, datos);
					break;
				case "adjacency-aec":
					adjacencyRepresentationAEC(jess,datos);
					break;
				case "adjacency-scc":
					adjacencyRepresentationSCC(jess,datos);
					break;
				case "adjacency-hc":
					adjacencyRepresentationHC(jess,datos);
					break;
				case "ordinal":
					ordinalRepresentation(jess,datos);
					break;
				case "path-pmx":
					pathRepresentationPMX(jess,datos);
					break;
				case "path-ox":
					pathRepresentationOX(jess,datos);
					break;
				case "path-cx":
					pathRepresentationCX(jess,datos);
					break;
				}
				jess.reset();
				// Ejecutamos el motor
				time = System.currentTimeMillis();
				jess.run();
				time = System.currentTimeMillis() - time;
				// Recogemos los resultados de los hechos generados (y pre-existentes)
				Iterator<?> it = jess.listFacts();
				while (it.hasNext()) {
					Fact fact = (Fact) it.next();
					//System.out.println(fact.getName());
					if(fact.getName().equals("MAIN::solucion") || fact.getName().equals("MAIN::lista")){
						if(fact.getName().equals("MAIN::solucion")){
							value = fact.get(1);
							esfuerzos.add(Integer.valueOf(value.toString()));
						}
						else{
							//System.out.println(fact);
							if(fact.get(3).equals("mejor")){
								value = fact.get(2);
								esfuerzos.add(Integer.valueOf(value.toString()));
							}
						}
						tiempos.add(time);
					}
				}
				jess.clear();
			} catch (JessException e) {
				e.printStackTrace();
			}
		}
		long mejorTiempo = Long.MAX_VALUE;
		long peorTiempo = -1;
		long tiempoTotal = 0;
		int esfuerzoMinimo = Integer.MAX_VALUE;
		int esfuerzoMaximo = -1;
		int esfuerzoTotal = 0;
		for (int i = 0; i < iteraciones; i++) {
			long tiempoActual = tiempos.get(i);
			int esfuerzoActual = esfuerzos.get(i);
			if(tiempoActual < mejorTiempo){
				mejorTiempo = tiempoActual;
			}
			if(tiempoActual > peorTiempo){
				peorTiempo = tiempoActual;
			}
			tiempoTotal += tiempoActual;
			if(esfuerzoActual < esfuerzoMinimo){
				esfuerzoMinimo = esfuerzoActual;
			}
			if(esfuerzoActual > esfuerzoMaximo){
				esfuerzoMaximo = esfuerzoActual;
			}
			esfuerzoTotal += esfuerzoActual;
		}
		
		System.out.println("Tiempo medio = "+(tiempoTotal/iteraciones)/1000.0+" segundos");
		System.out.println("Mejor tiempo = "+mejorTiempo/1000.0+" segundos");
		System.out.println("Peor tiempo = "+peorTiempo/1000.0+" segundos");
		
		System.out.println("Esfuerzo medio = "+(esfuerzoTotal/iteraciones));
		System.out.println("Esfuerzo mínimo = "+esfuerzoMinimo);
		System.out.println("Esfuerzo máximo = "+esfuerzoMaximo);
		
	}

	public static void genetic1(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Principal.clp");
		jess.batch(CONFIG + "TransporteLineal.clp");
		jess.batch(DATA + "ptl/" + datafile);
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Modulos.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Evaluacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-EvaluarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Cruce.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-CruzarPadres.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Mutacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-MutarElemento.clp");
	}

	public static void genetic2(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Principal.clp");
		jess.batch(CONFIG + "TransporteLineal.clp");
		jess.batch(DATA + "ptl/" + datafile);
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Modulos.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-GenerarMatriz.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Evaluacion.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Seleccion.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-SeleccionarPadre.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Cruce.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-DividirRem.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-GenerarHijos.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Mutacion.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-MutarElemento.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-PrepararMutacion.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-RealizarMutacion.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-Reemplazo.clp");
		jess.batch(RULES + GENETIC_2 + "TransporteLineal-Genetic2-EliminarPadres.clp");
	}

	public static void adjacencyRepresentationAEC(Rete jess,String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Adyacency-AEC.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Modulos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Evaluacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Cruce.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceAEC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceSCC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-RepararCiclos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-MutarElemento.clp");
	}
	
	public static void adjacencyRepresentationSCC(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Adyacency-SCC.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Modulos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Evaluacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Cruce.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceAEC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceSCC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-RepararCiclos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-MutarElemento.clp");
	}
	
	public static void adjacencyRepresentationHC(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Adyacency-HC.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Modulos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Evaluacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Cruce.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceAEC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceSCC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-CruceHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-RepararCiclos.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-MutarElemento.clp");
	}


	public static void ordinalRepresentation(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Ordinal.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Modulos.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-GenerarListaOrdinal.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Evaluacion.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-EvaluarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Cruce.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-CruzarPadres.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-MutarElemento.clp");
	}

	public static void pathRepresentationPMX(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Path-PMX.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Modulos.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Evaluacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-EvaluarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Cruce.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCentro.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceOX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CrucePMX.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-MutarElemento.clp");
	}
	
	public static void pathRepresentationOX(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Path-OX.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Modulos.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Evaluacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-EvaluarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Cruce.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCentro.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceOX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CrucePMX.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-MutarElemento.clp");
	}
	
	public static void pathRepresentationCX(Rete jess, String datafile) throws JessException {
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Principal.clp");
		jess.batch(CONFIG + "TSP-Path-CX.clp");
		jess.batch(DATA + "pv/" + datafile);
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Modulos.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Inicializacion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-GenerarLista.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-DesordenarLista.clp");
		jess.batch(RULES + ORDINAL + "TSP-OrdinalRepresentation-Evaluacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-EvaluarLista.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-EvaluarMejor.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-Seleccion.clp");
		jess.batch(RULES + GENETIC_1 + "TransporteLineal-Genetic1-SeleccionarPadre.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-Cruce.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCentro.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceCX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CruceOX.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-CrucePMX.clp");
		jess.batch(RULES + ADJACENCY + "TSP-AdyacencyRepresentation-Mutacion.clp");
		jess.batch(RULES + PATH + "TSP-PathRepresentation-MutarElemento.clp");
	}
}