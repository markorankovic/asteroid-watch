package nasa_api_stuff;
import java.sql.Date;
import java.util.Formatter;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;

public class Asteroid {

	// Metric measurements 
	
	@JsonProperty("id") String id;
	
	public String getID() {
		return id;
	}
			
	Date getApproachDate() {
		return Date.valueOf(closeApproachData.get(0).get("close_approach_date").asText());
	}
	
	protected @JsonProperty("close_approach_data") JsonNode closeApproachData;
	
	Float getRelativeVelocity() {
		return Float.parseFloat(closeApproachData.get(0).get("relative_velocity").get("kilometers_per_hour").textValue());
	}
	
	@JsonProperty("name") String name;
	
	String getStringBetweenTwoChars(String input, String startChar, String endChar) {
	    try {
	        int start = input.indexOf(startChar);
	        if (start != -1) {
	            int end = input.indexOf(endChar, start + startChar.length());
	            if (end != -1) {
	                return input.substring(start + startChar.length(), end);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return input; // return null; || return "" ;
	}
	
	public String getName() {
		String filteredName = getStringBetweenTwoChars(name, "(", ")");
		return filteredName; 
	}
		
	@JsonProperty("estimated_diameter") Float estimatedDiameter;
	
	public Float getEstimatedDiameter() {
		return estimatedDiameter;
	}
		
	void setEstimatedDiameter(JsonNode json) {
		estimatedDiameter = json.get(("meters")).get("estimated_diameter_max").floatValue();
	}
	
	@JsonProperty("is_potentially_hazardous_asteroid") boolean isPotentiallyHazardous;
	
	boolean getIsPotentiallyHazardous() {
		return isPotentiallyHazardous;
	}
	
	void setIsPotentiallyHazardous(boolean json) {
		isPotentiallyHazardous = json;
	}
		
	Float getMissDistance() {
		return Float.parseFloat(closeApproachData.get(0).get("miss_distance").get("kilometers").textValue());
	}
	
	public String toString() {
		StringBuilder sb = new StringBuilder();
		Formatter fmt = new Formatter(sb);
		fmt.format("Name: %s%n", name);
		fmt.format("ID: %s%n", id);
		fmt.format("Approach Date: %s%n", getApproachDate());
		fmt.format("Potentially Hazardous: %b%n", isPotentiallyHazardous);
		fmt.format("Estimated Diameter: %d meters%n", Math.round(estimatedDiameter));
		fmt.format("Miss Distance: %d km%n", Math.round(getMissDistance()) / 1000);
		fmt.format("Relative Velocity: %d km/h%n", Math.round(getRelativeVelocity()));
		fmt.close();
		return sb.toString();
	}
	
}
