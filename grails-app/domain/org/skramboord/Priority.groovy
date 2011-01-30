/******************************************************************************* 
 * Copyright (c) 2010 Pablo Hess. All rights reserved.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/

package org.skramboord

import java.awt.Color;

class Priority {
	static String LOW = "low"
	static String NORMAL = "normal"
	static String HIGH = "high"
	static String URGENT = "urgent"
	static String IMMEDIATE = "immediate"
	
	String name
	Color color
	
	Priority () {
	}
	
	Priority (String name, Color color) {
		this.name = name
		this.color = color
	}
	
	Priority (String name) {
		this.name = name
	}
	
	String toString() {
		return name
	}
	
	String colorAsString() {
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
	
	static namedQueries = {
		byName { name ->
			eq('name', name)
		}
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((color == null) ? 0 : color.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this.is(obj))
			return true;
		if (!obj)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Priority other = (Priority) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}
}
