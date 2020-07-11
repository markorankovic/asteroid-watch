package testing;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;

import org.junit.jupiter.api.Test;

public class ValidRangeTest {

	@Test
	void test() {
		Entry entry = new Entry();
		
		ArrayList<Integer> numbers = new ArrayList<Integer>();
		
		for (int i = 1; i < 11; i++) {
			numbers.add(i);
		}
		
		boolean valid = entry.isValidRange(numbers, 1, 9);
				
		assertEquals(true, valid);
	}

}
