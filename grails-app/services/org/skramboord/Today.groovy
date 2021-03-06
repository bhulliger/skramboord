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

class Today {
	/**
	 * @return today as date.
	 */
	static Date getInstance() {
		Calendar calendar = Calendar.getInstance()
		Date today = Date.parse("dd.MM.yyyy", "${calendar.get(Calendar.DATE)}.${calendar.get(Calendar.MONTH)+1}.${calendar.get(Calendar.YEAR)}")
	}
	
	/**
	 * @param date
	 * @return true, if date is today
	 */
	static boolean isDateToday(Date date)
	{
		Calendar dateToCheck = Calendar.getInstance();
		dateToCheck.setTime(date);
		dateToCheck.clear(Calendar.HOUR);
		dateToCheck.clear(Calendar.MINUTE);
		dateToCheck.clear(Calendar.SECOND);
		dateToCheck.clear(Calendar.MILLISECOND);
		
		Calendar today = Calendar.getInstance();
		today.setTime(Today.getInstance());
		today.clear(Calendar.HOUR);
		today.clear(Calendar.MINUTE);
		today.clear(Calendar.SECOND);
		today.clear(Calendar.MILLISECOND);
		
		return dateToCheck.equals(today);
	}
}
