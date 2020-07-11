package testing;
import java.util.ArrayList;

import org.junit.jupiter.api.Test;

public class Entry {
	
	static ArrayList<Integer> getNumbers(ArrayList<Integer> numbers) {
		return numbers;
	}
	
	@Test
	public boolean isValidRange(ArrayList<Integer> numbers, int i0, int i1) {
		try {
			return numbers.get(i0) != null && numbers.get(i1) != null; // Both indexes are in range with the array
		} catch (IndexOutOfBoundsException e) {
			return false;
		}
	}
	
}
