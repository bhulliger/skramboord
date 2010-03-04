package ch.ping.scrumboard

import java.awt.Color;

class Priority {
	String name
	Color color
	
	String toString() {
		String hex = Integer.toHexString(color.getRGB() & 0x00ffffff)
		// add leading zeros if necessary
		while(hex.length() < 6) {
			hex = "0" + hex
		}
		return hex
	}
	
    static constraints = {
		name(nullable:false)
		color(nullable:false)
    }
}
