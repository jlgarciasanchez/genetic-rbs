package es.mulcia.app;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;

public class Generador {

	public static void exportarFicherosPTL(String nombre, int n, int k, int copias) {
		for (int i = 0; i < copias; i++) {
			String nombreFichero = nombre + "_" + i + ".clp";
			exportarFicheroPTL(nombreFichero, n, k);
		}
	}

	public static void exportarFicheroPTL(String nombre, int n, int k) {
		File file = new File("src/es/mulcia/rbs/data/ptl/" + nombre);
		System.out.println(file.getAbsoluteFile());
		FileWriter fw = null;
		PrintWriter pw = null;
		try {
			fw = new FileWriter(file);
			pw = new PrintWriter(fw);
			pw.print("(deffacts datos-iniciales");
			pw.println("(n " + n + ")");
			pw.println("(k " + k + ")");
			int mercancia;
			int mercancia_total = (n + k) * 5;
			int mercancia_fuentes = mercancia_total;
			int mercancia_destinos = mercancia_total;
			for (int i = 0; i < n; i++) {
				if (i != n - 1) {
					mercancia = (int) (1 + (Math.random() * (mercancia_total / n)));
					mercancia_fuentes -= mercancia;
				} else {
					mercancia = mercancia_fuentes;
				}
				pw.println("(fuente (id " + i + ") (mercancia-total " + (mercancia) + ")(mercancia-actual 0))");
			}
			for (int i = 0; i < k; i++) {
				if (i != k - 1) {
					mercancia = (int) (1 + (Math.random() * (mercancia_total / k)));
					mercancia_destinos -= mercancia;
				} else {
					mercancia = mercancia_destinos;
				}
				pw.println("(destino (id " + i + ") (mercancia-total " + (mercancia) + ")(mercancia-actual 0))");
			}
			for (int i = 0; i < n; i++) {
				for (int j = 0; j < k; j++) {
					mercancia = (int) (1 + Math.random() * 15);
					pw.println("(esfuerzo (fuente " + i + ") (destino " + j + ") (esfuerzo " + mercancia + "))");
				}
			}
			pw.print(")");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (null != fw)
					fw.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public static void exportarFicherosPV(String nombre, int p, int copias) {
		for (int i = 0; i < copias; i++) {
			String nombreFichero = nombre + "_" + i + ".clp";
			exportarFicheroPV(nombreFichero, p);
		}
	}

	public static void exportarFicheroPV(String nombre, int p) {
		File file = new File("src/es/mulcia/rbs/data/pv/" + nombre);
		System.out.println(file.getAbsoluteFile());
		FileWriter fw = null;
		PrintWriter pw = null;
		try {
			fw = new FileWriter(file);
			pw = new PrintWriter(fw);
			pw.print("(deffacts datos-iniciales");
			pw.println("(p " + p + ")");
			int esfuerzo;
			for (int i = 0; i < p - 1; i++) {
				for (int j = i + 1; j < p; j++) {
					esfuerzo = (int) (1 + Math.random() * 15);
					pw.println("(esfuerzo (ciudadA " + i + ") (ciudadB " + j + ") (esfuerzo " + esfuerzo + "))");
				}
			}
			pw.print(")");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (null != fw)
					fw.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
}
