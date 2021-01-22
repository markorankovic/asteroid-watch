package nasa_api_stuff;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Comparator;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jMonkeyStuff.TestSizeComparison;

public class Driver {
	
	
	
	
	static String API_KEY = "uxickliHQnKSJqa7sl3gfdWt6Fw1Oct7rzzxDzHB";
	
	
	
	
	static String START_DATE = "2012-01-31";
	static String END_DATE = "2012-01-31";
	
	
	
	
	static String urlBaseString = "https://api.nasa.gov/neo/rest/v1/feed?";
	
	
	
	static ObjectMapper mapper = new ObjectMapper();

	public static String getAsteroidsRootJSON(String start_date, String end_date) {
		String urlString = urlBaseString + "start_date=" + start_date + "&" + "end_date=" + end_date + "&" + "api_key=" + API_KEY;
		try {
			URL url = new URL(urlString);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoOutput(true);
			con.setUseCaches(false);
			BufferedReader rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
			String inputLine = "";
			StringBuffer response = new StringBuffer();
			while ((inputLine = rd.readLine()) != null) {
				response.append(inputLine);
			}
			rd.close();
			return response.toString();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static JsonNode getDateFields(String jsonAsteroidObjectHierarchy) {
		try {
			return mapper.readTree(jsonAsteroidObjectHierarchy).get("near_earth_objects");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static ArrayList<JsonNode> getAsteroidsJSON(JsonNode nearEarthObjectsJSON) {
		ArrayList<JsonNode> jsonNodes = new ArrayList<JsonNode>();
		for (JsonNode dateField : nearEarthObjectsJSON) {
			for (JsonNode asteroidField : dateField) {
				jsonNodes.add(asteroidField);
			}
		}
		return jsonNodes;
	}
	
	public static ArrayList<Asteroid> getAsteroids(ArrayList<JsonNode> jsonNodes) {
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
		for (JsonNode jsonNode : jsonNodes) {
			try {
				asteroids.add(mapper.readValue(jsonNode.toString(), Asteroid.class));
			} catch (JsonParseException e) {
				e.printStackTrace();
			} catch (JsonMappingException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return asteroids;
	}
		
	public static void main(String[] args) {
		ArrayList<Asteroid> asteroids = getAsteroids(getAsteroidsJSON(getDateFields(getAsteroidsRootJSON(START_DATE, END_DATE))));
		//Asteroid[] asteroidArr = asteroids.toArray(new Asteroid[asteroids.size()]);
		//Arrays.sort(asteroidArr, new SortBySize());
		
//		System.out.println("A list of info of near-Earth Asteroids (NEAs) between " +  START_DATE + " and " + END_DATE);
//		System.out.println();
		
//		for (Asteroid asteroid : asteroidArr) {
//			System.out.println(asteroid); 
//		}
		
		asteroids.sort(new SortBySize());
		
		TestSizeComparison sizeComparisonApp = new TestSizeComparison(asteroids);
		sizeComparisonApp.start(); 
	} 

}

class SortBySize implements Comparator<Asteroid> {
	
	public int compare(Asteroid a, Asteroid b) {
		return Math.round(a.estimatedDiameter) - Math.round(b.estimatedDiameter);
	}
	
}
