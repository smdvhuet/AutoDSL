package info.scce.cinco.product.autoDSL.generator

class GuiGenerator {
	
	static def generateInteractiveSimulator()'''
		package info.scce.cinco.gui;
		
		import javax.swing.JFrame;
		import javax.swing.JOptionPane;
		import info.scce.cinco.product.EgoCar;
		import info.scce.cinco.core.IO;
		
		public class InteractiveSimulator {
		    
		    private SimulatorPanel simPanel;
		    private EgoCar egoCar;
		    
		    public InteractiveSimulator() {
		        
		        simPanel = new SimulatorPanel();        
		        JFrame frame = new JFrame();
		        frame.setContentPane(simPanel);
		        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		        frame.pack();
		        frame.setVisible(true);
		        egoCar = new EgoCar(0,0);
		    }
		    
		    public static void main(String[] args) {
		        
		        InteractiveSimulator sim = new InteractiveSimulator();
		        sim.run(); 
		    }
		    
		    public void run(){
		        double carPosInM = 0.0;
		        double carVelocityInMS = 0.0;
		        boolean hasCar = false;
		        boolean crash = false;
		    	long last = System.currentTimeMillis();
		    	boolean xPressed = false;
		          
		        while (true) {
		
		            try {
		                Thread.sleep(100);
		            } catch (InterruptedException ex) {
		                //
		            }
		              
		            if (!simPanel.isVisible()) {
		                break;
		            }
		
		            Mode mode = simPanel.getMode();
		            if (mode == Mode.PAUSE) {
		                last = System.currentTimeMillis();
		                continue;
		            }
		
		            // simulate world
		            long time = System.currentTimeMillis();                
		            double dt = ((double) (time-last)) / 1000.0;  
		              
		            if (hasCar) {
		                double oldCarPosInM = carPosInM;
		                carPosInM += carVelocityInMS * dt;
		                  
		                if (Math.abs(carPosInM - egoCar.getPositionM()) < 2.5 ||
		                        (oldCarPosInM > egoCar.getPositionM() && carPosInM < egoCar.getPositionM())) {
		                    crash = true; 
		                }
		            }                    
		              
		            if (crash) {
		                JOptionPane.showMessageDialog(null, "BOOOM!!!");
		                hasCar = false;
		                crash = false;                    
		                simPanel.setHasCar(false);
		            }
		              
		            // read gui
		            if (simPanel.hasCar()) {                    
		                  carVelocityInMS = simPanel.getCarVelocityInMS();                   
		                  if (!hasCar) {
		                      hasCar = true;
		                      carPosInM = egoCar.getPositionM() + simPanel.getDistanceInM();
		                  }                    
		              } else {
		                  hasCar = false;
		              }
		
		            final double MAX_DECEL = 7;
		            final double MAX_ACCEL = 2;
		            double acceleration = 0.0;
		            if(simPanel.getDeceleration() > 0)
		                acceleration = (-1) * simPanel.getDeceleration() * MAX_DECEL;
		            else
		                acceleration = simPanel.getAcceleration() * MAX_ACCEL;
		
		              //Feeding ACC
		              IO.in_GamepadThrottle = acceleration;
		              if(xPressed != simPanel.getAccActive()){
		            	  IO.in_GamepadX = simPanel.getAccActive();
		            	  IO.in_SetSpeed = egoCar.getVelocity();
		            	  xPressed = simPanel.getAccActive();
		              }
		              
		              
		              IO.in_GamepadB = acceleration < -0.1;
		              IO.in_DistanceFront = hasCar ? egoCar.getPositionM() - carPosInM : Double.MAX_VALUE;
		             
		              // simulate acc
		              egoCar.step(dt);                
		
		              last = time;
		              
		              // update gui    
		              simPanel.setAccSpeed(IO.in_SetSpeed);
		              simPanel.setVelocity(egoCar.getVelocity());
		              simPanel.setEgoPos(egoCar.getPositionM());
		              
		              simPanel.setDrawCar(hasCar);
		              simPanel.setCarPos(carPosInM);
		              
		              simPanel.update();   
		          }
		          System.exit(0);
		      }
		}
	'''
	
	static def generateSimulatorPanel()'''
		package info.scce.cinco.gui;
		
		import java.awt.BorderLayout;
		import javax.swing.JPanel;
		
		@SuppressWarnings("serial")
		public class SimulatorPanel extends JPanel {
		        
		    public InfoPanel info;
		    
		    public CarControlsPanel carControls;
		    
		    public SimControlPanel simControls;
		    
		    public RoadVisualizationPanel road; 
		    
		    public SimulatorPanel() {
		        initialize();
		    }
		    
		    private void initialize() {
		        
		        info = new InfoPanel();
		        carControls = new CarControlsPanel();
		        simControls = new SimControlPanel();
		        road = new RoadVisualizationPanel();
		        
		        setLayout(new BorderLayout());
		        
		        add(simControls, BorderLayout.NORTH);
		        add(road, BorderLayout.CENTER);
		        add(carControls, BorderLayout.SOUTH);
		        add(info, BorderLayout.EAST);     
		    }
		
		    public boolean hasCar() {
		        return simControls.hasCar();
		    }
		    
		    public void setHasCar(boolean hasCar) {
		        simControls.setHasCar(hasCar);
		    }
		    
		    public void setCheckable(double velocity) {
		    	carControls.setCheckable(velocity);
		    }
		    
		    public void setUnchecked() {
		    	carControls.setUnchecked();
		    }
		    
		    public double getDistance() {
		    	return carControls.getDistance();
		    }
		    
		    public double getAcceleration() {
		        return carControls.getAcceleration();
		    }
		
		    public double getDeceleration() {
		        return carControls.getDeceleration();
		    } 
		    
		    public Mode getMode() {
		        return simControls.getMode();
		    }
		
		    public boolean getAccActive() {
		        return carControls.getAccStatus();
		    }
		
		    public void setAccActive(boolean outActive) {
		        carControls.setAccStatus(outActive);
		        info.setAccState(outActive);
		    }
		
		    public void setAccSpeed(double ccVelocity) {
		        info.setACCSpeed(ccVelocity);
		    }
		
		    public void setWarning(boolean outWarning) {
		        info.setWarning(outWarning);
		    }
		
		    public void setVelocity(double egoVelocityInMS) {
		        info.setCurrentSpeed(egoVelocityInMS);
		    }
		
		    public void setEgoPos(double egoPosInM) {
		        road.setEgoPos(egoPosInM);
		    }
		    
		    public void update() {
		        info.update();
		        carControls.update();
		        simControls.update();
		        road.update();
		    }
		
		    public double getDistanceInM() {
		        return simControls.getDistance();
		    }
		
		    public double getCarVelocityInMS() {
		        return simControls.getVelocity() * 1000.0 / 3600.0;
		    }
		
		    public void setCarPos(double carPosInM) {
		        road.setCarPos(carPosInM);
		    }
		
		    public void setDrawCar(boolean draw) {
		        road.setDrawCar(draw);
		    }
		}
	'''
	
	
	static def generateSimControlPanel()'''
		package info.scce.cinco.gui;
		import java.awt.FlowLayout;
		import java.awt.event.ActionEvent;
		import java.awt.event.ActionListener;
		import javax.swing.JButton;
		import javax.swing.JLabel;
		import javax.swing.JPanel;
		import javax.swing.JSeparator;
		import javax.swing.JTextField;
		
		@SuppressWarnings("serial")
		class SimControlPanel extends JPanel {
		
		    private Mode mode = Mode.PAUSE;
		
		    private boolean hasCar = false;
		
		    private double distInM = 0.0;
		
		    private double velocity = 0.0;
		
		    private final JTextField distField = new JTextField(5);
		    private final JTextField velField = new JTextField(5);
		
		    SimControlPanel() {
		        initialize();
		    }
		
		    private void initialize() {
		
		        this.setLayout(new FlowLayout(FlowLayout.CENTER));
		
		        final JButton step = new JButton("Step");
		        step.addActionListener(new ActionListener() {
		            @Override
		            public void actionPerformed(ActionEvent e) {
		                mode = Mode.STEP;
		            }
		        });
		
		        final JButton play = new JButton("Play");
		        play.addActionListener(new ActionListener() {
		            @Override
		            public void actionPerformed(ActionEvent e) {
		                mode = Mode.PLAY;
		            }
		        });
		
		        final JButton pause = new JButton("Pause");
		        pause.addActionListener(new ActionListener() {
		            @Override
		            public void actionPerformed(ActionEvent e) {
		                mode = Mode.PAUSE;
		            }
		        });
		
		        add(step);
		        add(play);
		        add(pause);
		
		        add(new JSeparator(JSeparator.VERTICAL));
		
		        add(new JLabel("Dist [m]:"));
		        add(distField);
		        add(new JLabel("Vel [km/h]:"));
		        add(velField);
		        
		        final JButton setCar = new JButton("+");
		        setCar.addActionListener(new ActionListener() {
		            @Override
		            public void actionPerformed(ActionEvent e) {
		                distField.setEditable(false);
		                if (hasCar) {
		                    try {
		                        velocity = Double.parseDouble(velField.getText());
		                    } catch (NumberFormatException ex) {
		                        // do nothing
		                    }
		                } else {
		                    hasCar = true;
		                    try {
		                        velocity = Double.parseDouble(velField.getText());
		                        distInM = Double.parseDouble(distField.getText());
		                    } catch (NumberFormatException ex) {
		                        // do nothing
		                    }                    
		                }
		            }
		        });
		        
		        final JButton delCar = new JButton("-");
		        delCar.addActionListener(new ActionListener() {
		            @Override
		            public void actionPerformed(ActionEvent e) {
		                hasCar = false;
		                distField.setEditable(true);
		            }
		        });
		        
		        add(setCar);
		        add(delCar);
		    }
		
		    Mode getMode() {
		        if (mode == Mode.STEP) {
		            mode = Mode.PAUSE;
		            return Mode.STEP;
		        }
		        return mode;
		    }
		
		    boolean hasCar() {
		        return hasCar;
		    }
		
		    double getDistance() {
		        return distInM;
		    }
		
		    double getVelocity() {
		        return velocity;
		    }
		
		    void setHasCar(boolean hasCar) {
		        this.hasCar = hasCar;
		        distField.setEditable(!hasCar);        
		    }
		
		    final void update() {
		        repaint();
		    }    
		
		}
	'''
	
	
	static def generateRoadVisualizationPanel()'''
		package info.scce.cinco.gui;
		
		import java.awt.Color;
		import java.awt.Dimension;
		import java.awt.Graphics;
		import java.awt.Graphics2D;
		import java.awt.RenderingHints;
		import java.awt.geom.Ellipse2D;
		import java.awt.geom.Rectangle2D;
		import javax.swing.JPanel;
		
		@SuppressWarnings("serial")
		class RoadVisualizationPanel extends JPanel {
		
		    private Rectangle2D ego;    
		    private Rectangle2D car;
		    private Ellipse2D tree;
		    private Rectangle2D ground;
		    private Rectangle2D sky;
		    
		    public final static int PIXEL_HEIGHT = 400;
		    
		    public final static int PIXEL_WIDTH = 1000;
		    
		    private final static int GROUND_HEIGHT = 50;
		    
		    private double egoPosInM = 0;
		    
		    private double carPosInM = 0;
		    
		    private final double WIDTH_IN_M = 100.0;
		    
		    private final double meterToPixel = (double) PIXEL_WIDTH / WIDTH_IN_M;
		    
		    private boolean drawCar = false;
		    
		    private final double treeHeightinM = 10.0;
		    
		    private final int lengthCarInPixel = (int) (4.0 * meterToPixel);
		    
		    private final int heightCarInPixel = (int) (1.5 * meterToPixel);
		        
		    private final int heightTreeInPixel = (int) (treeHeightinM * meterToPixel);
		
		    private final double offsetInM = 10;
		        
		    private final int offsetInPixel = (int) (offsetInM * meterToPixel);
		    
		    RoadVisualizationPanel() {        
		        initialize();
		    }
		    
		    
		    private void initialize() {
		        
		        Dimension d = new Dimension(PIXEL_WIDTH, PIXEL_HEIGHT);
		        setSize(d);
		        setMinimumSize(d);
		        setPreferredSize(d);
		        
		        ground = new Rectangle2D.Float(0, PIXEL_HEIGHT - GROUND_HEIGHT, PIXEL_WIDTH, GROUND_HEIGHT);
		        sky = new Rectangle2D.Float(0, 0, PIXEL_WIDTH, PIXEL_HEIGHT - GROUND_HEIGHT);
		        ego = new Rectangle2D.Float(offsetInPixel, PIXEL_HEIGHT - GROUND_HEIGHT - 
		                heightCarInPixel -3 , lengthCarInPixel, heightCarInPixel);
		                
		    }
		
		    private void doDrawing(Graphics g) {
		
		        Graphics2D g2d = (Graphics2D) g.create();
		
		        //rectx = (rectx+10) % 250;        
		        //rect.setRect(rectx, 20f, 80f, 50f);
		        
		        RenderingHints rh = new RenderingHints(RenderingHints.KEY_ANTIALIASING,
		                RenderingHints.VALUE_ANTIALIAS_ON);
		
		        rh.put(RenderingHints.KEY_RENDERING,
		                RenderingHints.VALUE_RENDER_QUALITY);
		        
		        g2d.setRenderingHints(rh);
		
		        g2d.setPaint(new Color(0, 0, 0));        
		        g2d.fill(ground);
		
		        g2d.setPaint(new Color(235, 240, 255));        
		        g2d.fill(sky);
		
		        double treePosInM = WIDTH_IN_M - (egoPosInM % WIDTH_IN_M);
		        int treePosInPixel = (int) (treePosInM * meterToPixel);
		        tree = new Ellipse2D.Float(treePosInPixel, PIXEL_HEIGHT - GROUND_HEIGHT - 
		                heightTreeInPixel, heightTreeInPixel / 4.0f , heightTreeInPixel);
		                
		        g2d.setPaint(new Color(0, 200, 190));        
		        g2d.fill(tree);
		        
		        g2d.setPaint(new Color(235, 150, 150));        
		        g2d.fill(ego);
		        
		        if (drawCar) {
		            int carPosInPixel = (int) ((carPosInM - egoPosInM) * meterToPixel);
		            car = new Rectangle2D.Float(offsetInPixel + carPosInPixel, 
		                    PIXEL_HEIGHT - GROUND_HEIGHT - 
		                    heightCarInPixel -3 , lengthCarInPixel, heightCarInPixel);        
		
		            g2d.setPaint(new Color(0, 0, 210));        
		            g2d.fill(car);
		        }
		        
		        g2d.dispose();
		    }
		
		    @Override
		    public void paintComponent(Graphics g) {
		
		        super.paintComponent(g);
		        doDrawing(g);
		    }
		
		    void update() {
		        repaint();        
		    }
		    
		    void setDrawCar(boolean state) {
		        this.drawCar = state;
		    }
		    
		    void setEgoPos(double inM) {
		        this.egoPosInM = inM;
		    }
		    
		    void setCarPos(double inM) {
		        this.carPosInM = inM;
		    }    
		}
	'''
	
	static def generateMode()'''
		package info.scce.cinco.gui;
		
		public enum Mode {
		        PAUSE, STEP, PLAY    
		}
	'''
	
	static def generateInfoPanel()'''
		package info.scce.cinco.gui;
		import java.awt.Color;
		import java.awt.Dimension;
		import java.awt.Font;
		import java.text.DecimalFormat;
		import javax.swing.BoxLayout;
		import javax.swing.JLabel;
		import javax.swing.JPanel;
		import javax.swing.SwingConstants;
		import javax.swing.border.EmptyBorder;
		
		@SuppressWarnings("serial")
		class InfoPanel extends JPanel {
		
		    private boolean accInfo = false;
		
		    private double accSpeedInMproS = 0.0;
		
		    private double currentSpeedInMproS = 0.0;
		
		    private boolean warning = false;
		
		    private JLabel accLabel;
		
		    private JLabel warnLabel;
		
		    private JLabel speedLabel;
		
		    private static final DecimalFormat formatter = new DecimalFormat(".##");
		    
		    InfoPanel() {
		        initialize();
		        update();
		    }
		
		    private void initialize() {
		        
		        Dimension d = new Dimension(300, 200);
		        setSize(d);
		        setMinimumSize(d);
		        setPreferredSize(d);
		        
		        BoxLayout bl = new BoxLayout(this, BoxLayout.Y_AXIS);
		        setLayout(bl);
		                
		        accLabel = new JLabel();
		        speedLabel = new JLabel();
		        warnLabel = new JLabel();
		        
		        Font font = new Font("SansSerif", Font.BOLD, 30);
		
		        accLabel.setFont(font);
		        accLabel.setForeground(Color.green);
		        accLabel.setVerticalAlignment(SwingConstants.CENTER);
		
		        speedLabel.setFont(font);
		        speedLabel.setVerticalAlignment(SwingConstants.CENTER);
		        
		        warnLabel.setFont(font);
		        warnLabel.setForeground(Color.red);
		        warnLabel.setVerticalAlignment(SwingConstants.CENTER);
		        
		        accLabel.setBorder(new EmptyBorder(5, 20, 5, 20));
		        speedLabel.setBorder(new EmptyBorder(5, 20, 5, 20));        
		        warnLabel.setBorder(new EmptyBorder(5, 20, 5, 20));        
		        
		        add(accLabel);
		        add(speedLabel);
		        add(warnLabel);
		    }
		    
		    final void update() {
		        
		        if (accInfo) {
		            accLabel.setText("<html><div style='text-align: center;'>" + 
		                    formatter.format(accSpeedInMproS * 3.6) + " KM/H</div></html>");            
		            
		        } else {
		            accLabel.setText("<html><div style='text-align: center;'>OFF</div></html>");
		        }
		        
		        speedLabel.setText("<html><div style='text-align: center;'>" +
		                formatter.format(currentSpeedInMproS * 3.6) + " KM/H</div></html>");
		        
		        warnLabel.setText( warning ? 
		                "<html><div style='text-align: center;'>WARN</div></html>" : "");      
		        
		        repaint();
		    }
		    
		    void setAccState(boolean state) {
		        this.accInfo = state;
		    }
		    
		    void setCurrentSpeed(double inMperS) {
		        this.currentSpeedInMproS = inMperS;
		    }
		    
		    void setACCSpeed(double inMperS) {
		        this.accSpeedInMproS = inMperS;
		    }
		 
		    void setWarning(boolean state) {
		        this.warning = state;
		    }    
		}
	'''
	
	
	static def generateCarControlsPanel()'''
		package info.scce.cinco.gui;
		import java.awt.FlowLayout;
		import javax.swing.JCheckBox;
		import javax.swing.JLabel;
		import javax.swing.JPanel;
		import javax.swing.JSlider;
		
		@SuppressWarnings("serial")
		class CarControlsPanel extends JPanel {
		        
		    private JSlider accelerator;
		
		    private JSlider decelerator;
		    
		    private JSlider distance;
		    
		    private JCheckBox accOn;
		    
		    public CarControlsPanel() {
		        initialize();
		    }
		    
		    private void initialize() {
		        
		        setLayout(new FlowLayout(FlowLayout.CENTER));
		                
		        accelerator = new JSlider(JSlider.HORIZONTAL, 0, 100, 0);
		        decelerator = new JSlider(JSlider.HORIZONTAL, 0, 100, 0);
		        distance = new JSlider(JSlider.HORIZONTAL, 8, 22, 15);
		        
		        add(decelerator);        
		        add(new JLabel("Brake"));
		        add(accelerator);
		        add(new JLabel("Accel."));
		        add(distance);
		        add(new JLabel("Dist."));
		        
		        accOn = new JCheckBox("ACC");        
		        add(accOn);
		    }
		        
		    void update() {
		        repaint();
		    }
		    
		    void setCheckable(double velocity) {
		    	accOn.setEnabled(!(velocity > 200 || velocity < 30));
		    }
		
		    void setAccStatus(boolean state) {
		        this.accOn.setSelected(state);
		    }
		    
		    boolean getAccStatus() {
		        return this.accOn.isSelected();
		    }
		    
		    double getDistance() {
		    	return ((double) this.distance.getValue()) / 10.0;
		    }
		    
		    double getAcceleration() {
		        return ((double) this.accelerator.getValue()) / 100.0 ;
		    }
		
		    double getDeceleration() {
		        return ((double) this.decelerator.getValue()) / 100.0 ;
		    }
		
			public void setUnchecked() {
				accOn.setSelected(false);
			}    
		}
	'''
	
}