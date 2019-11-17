package es.mulcia.app;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JFrame;
import javax.swing.JRadioButton;
import javax.swing.JSpinner;

import java.awt.BorderLayout;
import javax.swing.JLabel;
import javax.swing.JComboBox;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SpinnerNumberModel;

import com.sun.xml.internal.fastinfoset.algorithm.IEEE754FloatingPointEncodingAlgorithm;

import javax.swing.JButton;

public class EjecutorUI {

	private JFrame frame;
	private JSpinner nIteraciones;
	

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					EjecutorUI window = new EjecutorUI();
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
	public EjecutorUI() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 300, 245);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		JLabel titulo = new JLabel("Ejecutar algoritmos");
		titulo.setToolTipText("");
		titulo.setBounds(10, 11, 249, 14);
		frame.getContentPane().add(titulo);
		
		JLabel tipoProblemaInfo = new JLabel("Seleccione tipo de problema:");
		tipoProblemaInfo.setBounds(10, 36, 249, 14);
		frame.getContentPane().add(tipoProblemaInfo);
		
		JComboBox<String> tipoProblema = new JComboBox<>();
		tipoProblema.setBounds(10, 61, 176, 20);
		tipoProblema.addItem("genetic1");
		tipoProblema.addItem("genetic2");
		tipoProblema.addItem("adjacency-aec");
		tipoProblema.addItem("adjacency-scc");
		tipoProblema.addItem("adjacency-hc");
		tipoProblema.addItem("ordinal");
		tipoProblema.addItem("path-pmx");
		tipoProblema.addItem("path-ox");
		tipoProblema.addItem("path-cx");
		frame.getContentPane().add(tipoProblema);
		
		JLabel nIteracionesInfo = new JLabel("Indique el n\u00FAmero de iteraciones:");
		nIteracionesInfo.setBounds(10, 153, 259, 14);
		frame.getContentPane().add(nIteracionesInfo);
		
		nIteraciones = new JSpinner(new SpinnerNumberModel(1, 1, 999999, 1));
		nIteraciones.setBounds(10, 178, 60, 20);
		frame.getContentPane().add(nIteraciones);
		
		JButton ejecutar = new JButton("Ejecutar");
		ejecutar.setBounds(185, 178, 89, 23);
		frame.getContentPane().add(ejecutar);
		
		JLabel problemaInfo = new JLabel("Seleccione el problema:");
		problemaInfo.setBounds(10, 97, 249, 14);
		frame.getContentPane().add(problemaInfo);
		
		JComboBox<String> problema = new JComboBox<String>();
		problema.setBounds(10, 122, 176, 20);
		File dir = new File("src/es/mulcia/rbs/data/ptl/");
		for(File current : dir.listFiles()){
			problema.addItem(current.getName());
		}
		frame.getContentPane().add(problema);
		
		tipoProblema.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
            	File dir;
            	if(((String) tipoProblema.getSelectedItem()).indexOf("genetic") > -1){
            		dir = new File("src/es/mulcia/rbs/data/ptl/");
            	}else{
            		dir = new File("src/es/mulcia/rbs/data/pv/");
            	}
            	problema.removeAllItems();
        		for(File current : dir.listFiles()){
        			problema.addItem(current.getName());
        		}
            	
            }
        });
		
		ejecutar.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {	
            	PrincipalJess.ejecutarJess((String) tipoProblema.getSelectedItem(), (String) problema.getSelectedItem(), (int) nIteraciones.getValue());
            }
        });
	}
}
