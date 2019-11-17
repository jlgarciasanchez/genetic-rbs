package es.mulcia.app;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JFrame;
import javax.swing.JRadioButton;
import javax.swing.JSpinner;

import java.awt.BorderLayout;
import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SpinnerNumberModel;
import javax.swing.JButton;

public class GeneradorUI {

	private JFrame frame;
	private JSpinner nFuentes;
	private JSpinner nDestinos;
	private JSpinner nProblemas;
	private final String PROBLEMA_TRANSPORTE = "Problema del Transporte";
	private final String PROBLEMA_VIAJANTE = "Problema del Viajante";
	private JTextField nombre;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					GeneradorUI window = new GeneradorUI();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public GeneradorUI() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 300, 365);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		JPanel panelViajante = new JPanel();
		panelViajante.setBounds(10, 92, 269, 116);
		frame.getContentPane().add(panelViajante);
		panelViajante.setVisible(false);
		panelViajante.setLayout(null);
		
		JLabel nCiudadesInfo = new JLabel("Indique el n\u00FAmero de ciudades:");
		nCiudadesInfo.setBounds(0, 10, 249, 14);
		panelViajante.add(nCiudadesInfo);
		
		JSpinner nCiudades = new JSpinner(new SpinnerNumberModel(1, 1, 999999, 1));
		nCiudades.setBounds(0, 35, 60, 20);
		panelViajante.add(nCiudades);
		
		JLabel titulo = new JLabel("Generador de Problemas");
		titulo.setToolTipText("");
		titulo.setBounds(10, 11, 249, 14);
		frame.getContentPane().add(titulo);
		
		JLabel tipoProblemaInfo = new JLabel("Seleccione tipo de problema:");
		tipoProblemaInfo.setBounds(10, 36, 249, 14);
		frame.getContentPane().add(tipoProblemaInfo);
		
		JComboBox<String> tipoProblema = new JComboBox<>();
		tipoProblema.setBounds(10, 61, 176, 20);
		tipoProblema.addItem(PROBLEMA_TRANSPORTE);
		tipoProblema.addItem(PROBLEMA_VIAJANTE);
		frame.getContentPane().add(tipoProblema);
		
		JPanel panelTransporte = new JPanel();
		panelTransporte.setBounds(10, 92, 269, 116);
		frame.getContentPane().add(panelTransporte);
		panelTransporte.setLayout(null);
		
		JLabel nFuentesInfo = new JLabel("Indique n\u00FAmero de fuentes:");
		nFuentesInfo.setBounds(0, 10, 249, 14);
		panelTransporte.add(nFuentesInfo);
		
		nFuentes = new JSpinner(new SpinnerNumberModel(1, 1, 999999, 1));  
		nFuentes.setBounds(0, 35, 60, 20);
		panelTransporte.add(nFuentes);
		
		JLabel nDestinosInfo = new JLabel("Indique n\u00FAmero de destinos:");
		nDestinosInfo.setBounds(0, 60, 249, 14);
		panelTransporte.add(nDestinosInfo);
		
		nDestinos = new JSpinner(new SpinnerNumberModel(1, 1, 999999, 1));
		nDestinos.setBounds(0, 85, 60, 20);
		panelTransporte.add(nDestinos);
		
		JLabel nProblemasInfo = new JLabel("Indique n\u00FAmero de problemas que desea generar:");
		nProblemasInfo.setBounds(10, 219, 259, 14);
		frame.getContentPane().add(nProblemasInfo);
		
		nProblemas = new JSpinner(new SpinnerNumberModel(1, 1, 999999, 1));
		nProblemas.setBounds(10, 244, 60, 20);
		frame.getContentPane().add(nProblemas);
		
		JButton generar = new JButton("Generar");
		generar.setBounds(190, 300, 89, 23);
		frame.getContentPane().add(generar);
		
		JLabel nombreInfo = new JLabel("Indique un nombre para los problemas:");
		nombreInfo.setBounds(10, 275, 259, 14);
		frame.getContentPane().add(nombreInfo);
		
		nombre = new JTextField();
		nombre.setBounds(10, 300, 176, 20);
		frame.getContentPane().add(nombre);
		nombre.setColumns(10);
		
		tipoProblema.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
            	
            	if(PROBLEMA_TRANSPORTE.equals(tipoProblema.getSelectedItem())){
            		panelTransporte.setVisible(true);
            		panelViajante.setVisible(false);
            	}else{
            		panelTransporte.setVisible(false);
            		panelViajante.setVisible(true);
            	}
            	
            }
        });
		
		generar.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {	
            	if(PROBLEMA_TRANSPORTE.equals(tipoProblema.getSelectedItem())){
            		Generador.exportarFicherosPTL(nombre.getText(), (int) nFuentes.getValue(), (int) nDestinos.getValue(), (int) nProblemas.getValue());
            	}else{
            		Generador.exportarFicherosPV(nombre.getText(), (int) nCiudades.getValue(), (int) nProblemas.getValue());
            	}
            	
            }
        });
	}
}
