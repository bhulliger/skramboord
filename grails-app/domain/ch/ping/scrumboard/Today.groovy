package ch.ping.scrumboard

abstract class Today {
	/**
	 * @return today as date.
	 */
	static Date getInstance() {
		Calendar calendar = Calendar.getInstance()
		Date today = Date.parse("dd.MM.yyyy", "${calendar.get(Calendar.DATE)}.${calendar.get(Calendar.MONTH)+1}.${calendar.get(Calendar.YEAR)}")
	}
}
