package jMonkeyStuff;

import java.util.ArrayList;
import com.jme3.animation.LoopMode;
import com.jme3.app.SimpleApplication;
import com.jme3.cinematic.Cinematic;
import com.jme3.cinematic.MotionPath;
import com.jme3.cinematic.MotionPathListener;
import com.jme3.cinematic.PlayState;
import com.jme3.cinematic.events.MotionEvent;
import com.jme3.input.KeyInput;
import com.jme3.input.controls.ActionListener;
import com.jme3.input.controls.KeyTrigger;
import com.jme3.material.Material;
import com.jme3.math.ColorRGBA;
import com.jme3.scene.Geometry;
import com.jme3.scene.Spatial;
import com.jme3.scene.shape.Box;

/* Author: Marko Ranković
 * Testing a system where a motion event may be stopped for the other one play, both events switch mid-play. 
 *  On success this should make the design of the animation sequence for the size comparison easier and more reliable. */

public class TestAnimationControl extends SimpleApplication {

	Box box1 = new Box(3, 4, 2);
	Box box2 = new Box(5, 2, 3);
	
	ArrayList<MotionEvent> motionEvents;
	
	MotionEvent firstEvent;
	
	Cinematic cinematic;
		
	@Override
	public void simpleInitApp() {

		System.out.println("simpleInitApp: Application Started");
		
		flyCam.setEnabled(false);
		
		Spatial[] boxSpatials = createBoxSpatials();
		
		addBoxSpatials(boxSpatials);
		
		MotionEvent[] motionEvents = createEvents(boxSpatials);
		
		cinematic = createCinematicSequence(motionEvents);
		
		addEventsToList(motionEvents);
		
		setupPathListeners();
		
		startCinematicSequence(); 
		
		firstEvent = this.motionEvents.get(0);
		
		addEvent(firstEvent);
				
		initKeys();
		
	} 
	
	@Override
	public void simpleUpdate(float tpf) {
		
//		System.out.println("simpleUpdate: Cinematic time: " + cinematic.getTime()); 
//		System.out.println("simpleUpdate: MotionEvent1 time: " + motionEvents.get(0).getTime()); 
//		System.out.println("simpleUpdate: MotionEvent2 time: " + motionEvents.get(1).getTime()); 
//		System.out.println();

	}
	
	void initKeys() {
		
        inputManager.addMapping("play_stop", new KeyTrigger(KeyInput.KEY_SPACE));
		
        ActionListener acl = new ActionListener() {
        	
            public void onAction(String name, boolean keyPressed, float tpf) {
            	
                if (name.equals("play_stop") && keyPressed) {
                	if (cinematic.getPlayState().equals(PlayState.Playing)) {
                		cinematic.pause();
                	} else {
                		cinematic.play();
                	}
                }
                
            }
            
        };
        
        inputManager.addListener(acl, "play_stop");

        
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
		
	Cinematic createCinematicSequence(MotionEvent[] events) {
		
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
//		TestAnimationControl app = new TestAnimationControl();
//		app.start();
//	}

	
}
