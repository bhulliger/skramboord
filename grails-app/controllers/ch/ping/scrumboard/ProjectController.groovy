package ch.ping.scrumboard


class ProjectController {
	
	def index = { redirect(controller:'project', action:'list')
	}
	
	def list = {
		session.projectList = Project.withCriteria {
			order('name','asc')
		}
	}
	
	/**
	 * Add new project
	 */
	def addProject = {
		def projectName = params.projectName
		
		Project project = new Project(name: projectName)
		if (!project.save()) {
			flash.project=project
		}

		redirect(controller:'project', action:'list')
	}
}
