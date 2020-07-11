package jMonkeyStuff;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import nasa_api_stuff.Asteroid;

/* Author: Marko Ranković
 * Testing a system where a motion event may be stopped for the other one play, both events switch mid-play. 
 *  On success this should make the design of the animation sequence for the size comparison easier and more reliable. */

public class TestSizeComparison extends SimpleApplication {

	Box box1 = new Box(3, 4, 2);
	Box box2 = new Box(5, 2, 3);
	
	ArrayList<MotionEvent> motionEvents;
	
	MotionEvent firstEvent;
	
	Cinematic cinematic;
		
	ArrayList<Asteroid> realAsteroids;
	
	ArrayList<ComparisonAsteroid> asteroids;	
	
	CameraNode motionCam; 
	
	MotionEvent asteroidTraversal;
	
	ArrayList<Vector3f> wayPoints;
	
	ArrayList<MotionEvent> moveEvents;
	
	
	public TestSizeComparison(ArrayList<Asteroid> realAsteroids) {
		this.realAsteroids = realAsteroids;
	}
	
	
	ArrayList<ComparisonAsteroid> getAsteroids(int count) {
		System.out.println("getAsteroids: Getting asteroids");
		ArrayList<ComparisonAsteroid> asteroids = new ArrayList<ComparisonAsteroid>();
		for (int i = 1; i < count + 1; i++) {
			Spatial spatial = assetManager.loadModel("Assets/asteroid" + i + ".obj");
			float size = (float) Math.pow(2, i);
			Geometry model = getGeometry(spatial);
			model.scale((float) Math.pow(2, i), (float) Math.pow(2, i), (float) Math.pow(2, i));
			ComparisonAsteroid asteroid = new ComparisonAsteroid("Asteroid " + i, size, model, assetManager);
			asteroids.add(asteroid);
		}
		return asteroids;
	}
	
	ArrayList<ComparisonAsteroid> getRealAsteroids() {
		System.out.println("getRealAsteroids: Getting real asteroids");
		ArrayList<ComparisonAsteroid> asteroids = new ArrayList<ComparisonAsteroid>();
		int i = 1;
		for (Asteroid realAsteroid : realAsteroids) {
			Spatial spatial = assetManager.loadModel("Assets/asteroid" + i + ".obj");
			float size = (float) realAsteroid.getEstimatedDiameter();
			Geometry model = getGeometry(spatial);
			model.scale((float) size / 10, size / 10, size / 10);
			ComparisonAsteroid asteroid = new ComparisonAsteroid(realAsteroid.getName(), size, model, assetManager);
			asteroids.add(asteroid); 
			i++;
		}
		return asteroids;
	}

												
	void lineUpAsteroids() {
		
		System.out.println("lineUpAsteroids: Lining up asteroids");
		
		for (ComparisonAsteroid asteroid : asteroids) {
			rootNode.attachChild(asteroid.model);
			int previousIndex = asteroids.indexOf(asteroid) - 1;
			
			ComparisonAsteroid previousAsteroid = previousIndex >= 0 ? asteroids.get(previousIndex) : null;
			
			Vector3f previousScale = previousAsteroid != null ? previousAsteroid.model.getWorldScale() : new Vector3f(0, 0, 0);
			Vector3f scale = asteroid.model.getWorldScale();
			
			Vector3f previousPosition = previousAsteroid != null ? previousAsteroid.model.getLocalTranslation() : new Vector3f(0, 0, 0);
			
			float combinedDiameters = previousScale.x + scale.x;
			
			asteroid.model.setLocalTranslation(previousPosition.x + previousScale.x + previousScale.x / 2 + scale.x / 2 + combinedDiameters / 2, (scale.y / 2) + (scale.y / 3), -scale.z / 2);
		}
		
	} 
	
	void addText() {
		System.out.println("addText: Adding text");
		
		for (ComparisonAsteroid asteroid : asteroids) {
			asteroid.text.setLocalTranslation(asteroid.model.getLocalTranslation().add(-asteroid.model.getWorldScale().x * 1.5f, asteroid.model.getWorldScale().y * 1.5f, 0));
			rootNode.attachChild(asteroid.text);
		}
	}
    
    public Geometry getGeometry(Spatial spatial){
    	System.out.println("getGeometry: Getting geometry");
		Geometry g = null;
		
		final List<Spatial> ants = new LinkedList<Spatial>();
		//node.breadthFirstTraversal(new SceneGraphVisitor() {
		spatial.depthFirstTraversal(new SceneGraphVisitor() { 
			@Override 
			public void visit(Spatial spatial) {
				//System.out.println("visit class is " + spatial.getClass().getName());
				//System.out.println("visit spatial is " + spatial);
				if (spatial.getClass().getName().equals("com.jme3.scene.Geometry")) {
					ants.add(spatial);
				}
			}
		});
		if (!ants.isEmpty()) {
			//redundant - borrowed from Quixote TerrainTrackControl
			for (int i = 0;i < ants.size();i++){
				if (ants.get(i).getClass().getName().equals("com.jme3.scene.Geometry")){
					g = (Geometry)ants.get(i);
					//System.out.println("g (" + i + "/" + (ants.size() - 1) + ")=" + g);
					return(g);
				}
			}
		}
		else
		{
			System.out.println("	getGeometry: Geometry not found");
		}
		return(g);
	}

		
	@Override
	public void simpleInitApp() {

		System.out.println("simpleInitApp: Application Started");
		
		//setupTestSequence();
		
		//settings.setFrameRate(60);
		
		setupSizeComparisonSequence(); 
		
	} 
	
	void setupSizeComparisonSequence() {
		
		System.out.println("setupSizeComparisonSequence: Setting up size comparison sequence");
		
		flyCam.setEnabled(false);
		
		rootNode.addLight(new AmbientLight());
		
		asteroids = getRealAsteroids(); 
		
		lineUpAsteroids();
		
		addText();
		
		initKeys();
				
		cam.setFrustumFar(1999999999);
		
		initCinematic();
																
	}
	
	void initCinematic() {		
		System.out.println("initCinematic: Initializing cinematic");
		
		cinematic = createCinematicSequence();
		
		motionCam = cinematic.bindCamera("someCamera", cam);
		
		motionCam.rotate(0, (float) Math.PI, 0);
		
		startCinematicSequence(); 
						
		cinematic.activateCamera(0, "someCamera");
		
		rootNode.attachChild(motionCam);
			
		//routeEvents();
	}
	
	void routeEvents() {		
		System.out.println("routeEvents: Routing events");
		
		wayPoints = getWayPoints();
		
		float period = 3f;
		
		moveEvents = getMoveEvents(period);
		
		addEventsToCinematic(period);
	}
	
	void addEventsToCinematic(float period) {
		System.out.println("addEventsToCinematic: Adding events to cinematic");
		
		float time = cinematic.getTime();
		
		System.out.println("	addEventsToCinematic: time: " + time);

		
		int i = 0;
		for (MotionEvent motionEvent : moveEvents) {			
			cinematic.addCinematicEvent(0.1f + period * i + time + 3 * i, motionEvent);
			i++;
		}
	} 
	 	
	ArrayList<MotionEvent> getMoveEvents(float period) {
		System.out.println("getMoveEvents: Initializing move events");
		
		ArrayList<MotionEvent> moveEvents = new ArrayList<MotionEvent>();
		
		for (int i = 0; i < wayPoints.size() - 1; i++) {
			MotionPath path = new MotionPath();
			
			path.addWayPoint(wayPoints.get(i));
			path.addWayPoint(wayPoints.get(i + 1));
			
			path.addListener(new MotionPathListener() { 

				@Override
				public void onWayPointReach(MotionEvent arg0, int arg1) {
					
					System.out.println("onWayPointReach: Way point " + wayPoints.indexOf(arg0.getPath().getWayPoint(arg1)) + " reached"); 
					
				}
				
			});
			
			MotionEvent motionEvent = new MotionEvent(motionCam, path);
			
			motionEvent.setInitialDuration(period);
			
			moveEvents.add(motionEvent);
			
			System.out.println("	initMoveEvents: Move event added");
		}
		
		return moveEvents;
	}
	
	int getLastIndexInAsteroids(Vector3f pos) {
		System.out.println("getLastIndexInAsteroids: Getting last index in asteroids");
		
		int lastIndex = 0;
		for (ComparisonAsteroid a : asteroids) {
			if (a.model.getLocalTranslation().x < pos.x) {
				lastIndex++;
			}
		}
		System.out.println("	getLastIndexInAsteroids: Got " + lastIndex);

		return lastIndex;
	}
	
	ArrayList<ComparisonAsteroid> getRelevantAsteroids() {
		
		System.out.println("getRelevantAsteroids: Getting relevant asteroids");
		
		ArrayList<ComparisonAsteroid> asteroids = new ArrayList<ComparisonAsteroid>();
		Vector3f camPos = motionCam.getLocalTranslation();
		int lastIndex = getLastIndexInAsteroids(camPos);
		int end = this.asteroids.size();
		
		if (backwards) {
			lastIndex--;
			end = 0;
		}
				
		System.out.println("	getRelevantAsteroids: end: " + end);
		
		for (int i = lastIndex; (backwards ? (i >= end) : (i < end)); i += (backwards ? -1 : 1)) {
			System.out.println("	getRelevantAsteroids: Getting relevant asteroid " + i);
			asteroids.add(this.asteroids.get(i));
		}
		
		return asteroids;
		
	}    
	
	ArrayList<Vector3f> getWayPoints() {
		System.out.println("getWayPoints: Getting way points");
		
		ArrayList<Vector3f> wayPoints = new ArrayList<Vector3f>();
		
		wayPoints.add(motionCam.getLocalTranslation());
		
		for (ComparisonAsteroid asteroid : getRelevantAsteroids()) {
			wayPoints.add(asteroid.model.getLocalTranslation().add(0, 0, asteroid.model.getWorldScale().z * 10));
			
			System.out.println("	getWayPoints: Way point added");
		}
		
		return wayPoints;
	}
	
	void positionCameraAtFirstWayPoint() {
		System.out.println("positionCameraAtFirstWayPoint: Positioning camera at first way point");
		motionCam.setLocalTranslation(asteroids.get(0).model.getLocalTranslation().add(0, 0, asteroids.get(0).model.getWorldScale().z * 5));
	}
	
	MotionEvent getAsteroidTraversalEvent(CameraNode motionCam) { 
		
		System.out.println("getAsteroidTraversalEvent: Getting asteroid traversal event");
				
		MotionPath asteroidsPath = new MotionPath();
		
		asteroidsPath.addWayPoint(motionCam.getLocalTranslation());
		
		for (ComparisonAsteroid asteroid : asteroids) {
			asteroidsPath.addWayPoint(asteroid.model.getLocalTranslation().add(0, 0, asteroid.model.getWorldScale().z * 5));
			
			System.out.println("	getAsteroidTraversalEvent: Way point added");
		}
		
		asteroidsPath.addListener(new MotionPathListener() {

			@Override
			public void onWayPointReach(MotionEvent arg0, int arg1) {
				
				System.out.println("onWayPointReach: Way point " + arg1 + " reached");
								
			}
			
		});
		
		asteroidsPath.setCurveTension(0); 
				
		asteroidTraversal = new MotionEvent(motionCam, asteroidsPath);
		
		asteroidTraversal.setInitialDuration(3 * asteroids.size());
						
		return asteroidTraversal;
		
	} 
	
	void setupTestSequence() {
		
		System.out.println("setupTestSequence: Setting up test sequence");
		
		flyCam.setEnabled(false);
		
		Spatial[] boxSpatials = createBoxSpatials();
		
		addBoxSpatials(boxSpatials);
		
		MotionEvent[] motionEvents = createEvents(boxSpatials);
		
		cinematic = createCinematicSequence();
		
		addEventsToList(motionEvents);
		
		setupPathListeners();
		
		startCinematicSequence(); 
		
		firstEvent = this.motionEvents.get(0);
		
		addEvent(firstEvent);
				
		initKeys();
		
	}
	
	float tpf = 0;
	
	@Override
	public void simpleUpdate(float tpf) {
		
		this.tpf = tpf;
		
//		System.out.println("simpleUpdate: motionCam: " + motionCam.getLocalTranslation()); 
//		System.out.println("simpleUpdate: Cinematic time: " + cinematic.getTime()); 
//		System.out.println("simpleUpdate: MotionEvent1 time: " + motionEvents.get(0).getTime()); 
//		System.out.println("simpleUpdate: MotionEvent2 time: " + motionEvents.get(1).getTime()); 
//		System.out.println();
		
		if (cinematic.getPlayState().equals(PlayState.Playing)) {
			for (ComparisonAsteroid a : asteroids) {
				a.model.rotate(0, 0.01f, 0);
			}
		}

	}
		
	boolean backwards = false;
	
	void initKeys() {
		
        inputManager.addMapping("play_stop", new KeyTrigger(KeyInput.KEY_SPACE));
        inputManager.addMapping("forwards", new KeyTrigger(KeyInput.KEY_RIGHT));
        inputManager.addMapping("backwards", new KeyTrigger(KeyInput.KEY_LEFT));

		
        ActionListener acl = new ActionListener() {
        	
            public void onAction(String name, boolean keyPressed, float tpf) {
            	
                if (name.equals("play_stop") && keyPressed) {
                	if (cinematic.getPlayState().equals(PlayState.Playing)) {
                		cinematic.pause();
                	} else {
                		cinematic.play();
                	}
                }
                
                if (name.equals("forwards") && keyPressed) {
                	backwards = false;
                	cinematic.clear();
                	routeEvents();
                }
                
                if (name.equals("backwards") && keyPressed) {
                	backwards = true;
                	cinematic.clear();
                	routeEvents();
                }
                
            }
            
        };
        
        inputManager.addListener(acl, "play_stop", "forwards", "backwards");

        
		System.out.println("initKeys: Keys initialized");
	}
	
	void startCinematicSequence() { 
		
		cinematic.play();
						
		stateManager.attach(cinematic);
		
		System.out.println("startCinematicSequence: Cinematic sequence started");
		
	} 
	
	MotionEvent[] createEvents(Spatial[] spatials) {
			
		System.out.println("createEvents: Creating events");
		
		MotionEvent[] events = new MotionEvent[spatials.length];
		
		int i = 0;
		
		for (Spatial spatial : spatials) {
			
			MotionPath path = new MotionPath();
			
			path.addWayPoint(spatial.getLocalTranslation());
			path.addWayPoint(spatial.getLocalTranslation().add(0, 0, -5));
			path.addWayPoint(spatial.getLocalTranslation().add(0, 0, -10));
			
			path.addWayPoint(spatial.getLocalTranslation().add(0, 0, -15));
			
			path.addWayPoint(spatial.getLocalTranslation().add(0, 0, -10));
			path.addWayPoint(spatial.getLocalTranslation().add(0, 0, -5));
			path.addWayPoint(spatial.getLocalTranslation());
			
			MotionEvent sequence = new MotionEvent(spatial, path);
												
			events[i] = sequence;
			
			i++;
			
		}
		
		return events;
		
	}
		
	Cinematic createCinematicSequence() {
		
		System.out.println("createCinematicSequence: Creating sequence");
							
		Cinematic scene = new Cinematic(rootNode, 1000000000); // Reset after the specified number of seconds
				
		scene.setLoopMode(LoopMode.Loop);
				
		return scene;
		
	}
	
	void addEvent(MotionEvent motionEvent) {
		System.out.println("addEvent: Playing event");
		
		cinematic.addCinematicEvent(cinematic.getTime(), motionEvent);
	}
	
	MotionEvent getOtherMotionEvent(MotionEvent event) {
		MotionEvent otherEvent = null;
		
		for (MotionEvent someEvent : motionEvents) {
			if (!someEvent.equals(event)) {
				otherEvent = someEvent;
			}
		}
		
		return otherEvent;
	}
	
	void setupPathListeners() {
		System.out.println("setupPathListeners: Setting up path listeners");
		
		for (MotionEvent motionEvent : motionEvents) {
			if (motionEvent.getPath() != null) {
				MotionPath path = motionEvent.getPath();
				path.addListener(new MotionPathListener() {

					@Override
					public void onWayPointReach(MotionEvent arg0, int arg1) {
						System.out.println("setupPathListeners: MotionEvent" + (motionEvents.indexOf(arg0) + 1) + " way point " + arg1 + " reached");
												
						if (!arg0.equals(firstEvent)) {
							System.out.println();
						}
						
						arg0.pause();
						getOtherMotionEvent(arg0).play();
					}
					
				}); 
			}
		}
	}
	
	void addEventsToList(MotionEvent[] motionEvents) {
		System.out.println("addEventsToList: Adding events to list");
		
		this.motionEvents = new ArrayList<MotionEvent>();
		
		for (MotionEvent motionEvent : motionEvents) {
			System.out.println("	addEventsToList: Adding event to list");

			this.motionEvents.add(motionEvent);
		}
	}
	
	void addBoxSpatials(Spatial[] boxSpatials) {
		
		System.out.println("addBoxSpatials: Adding spatials to root");
		
		for (Spatial boxSpatial : boxSpatials) {
			rootNode.attachChild(boxSpatial);
		}
		
	}
	
	Spatial[] createBoxSpatials() {
		
		System.out.println("createBoxSpatials: Creating box spatials");
		
		Spatial box1Geo = new Geometry("box1", box1);
		Material mat = new Material(assetManager, "Common/MatDefs/Misc/Unshaded.j3md");
		mat.setColor("Color", ColorRGBA.Green);
		box1Geo.setMaterial(mat);
		box1Geo.setLocalTranslation(-5, 0, -10);
		
		Spatial box2Geo = new Geometry("box2", box2);
		Material mat2 = new Material(assetManager, "Common/MatDefs/Misc/Unshaded.j3md");
		mat2.setColor("Color", ColorRGBA.Red);
		box2Geo.setMaterial(mat2);
		box2Geo.setLocalTranslation(5, 0, -10); 
				
		return new Spatial[] { box1Geo, box2Geo };
	}
		
//	public static void main(String[] args) {
//		System.out.println("main: Entry point");
//		
//		TestSizeComparison app = new TestSizeComparison();
//		app.start();
//	}

	
}
