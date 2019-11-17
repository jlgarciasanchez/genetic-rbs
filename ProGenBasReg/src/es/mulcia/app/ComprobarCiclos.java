package es.mulcia.app;

import java.util.ArrayList;

public class ComprobarCiclos {

	public static void main(String[] args) {
		ArrayList<Integer> input = new ArrayList<Integer>();
		input.add(2);
		input.add(9);
		input.add(7);
		input.add(0);
		input.add(1);
		input.add(4);
		input.add(3);
		input.add(8);
		input.add(5);
		input.add(6);
		
		String cadena = devovlerRuta(input);
		System.out.println(cadena);
		System.out.println(cadena.length());

	}
	
	public static String devovlerRuta(ArrayList<Integer> input){
		String cadena = "";
		Integer b = input.get(0);
		while(b > 0){
			cadena += b;
			b = input.get(b);
		}
		cadena += 0;
		return cadena;
	}

}
