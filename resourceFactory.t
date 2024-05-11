#charset "us-ascii"
//
// resourceFactory.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceFactory: object
	// Object class for the kind of resource we manage.
	resourceClass = Resource

	// The collective group for this resource.
	resourceCollectiveClass = ResourceCollective

	// The lister class for this resource.
	resourceListClass = ResourceList

	// The report manager class for this resource.
	resourceReportManagerClass = ResourceReportManager

	// Instances of the above classes for this particular Resource
	// instance.
	resourceCollective = nil
	resourceList = nil
	resourceReportManager = nil

	// When we're asked to dispense a resource, this is where
	// it'll go by default.
	dispenseTo = nil

	getResourceCollective() {
		if(resourceCollective == nil) {
			resourceCollective = resourceCollectiveClass
				.createInstance();

			resourceCollective.resourceFactory = self;
			resourceCollective.initResourceCollective();
		}
		return(resourceCollective);
	}

	getResourceList() {
		if(resourceList == nil)
			resourceList = resourceListClass.createInstance();
		return(resourceList);
	}

	getResourceReportManager() {
		if(resourceReportManagerClass == nil)
			return(nil);
		if(resourceReportManager == nil) {
			resourceReportManager = resourceReportManagerClass
				.createInstance();
			resourceReportManager.resourceFactory = self;
		}
		return(resourceReportManager);
	}

	dispenseResource() {
		local obj;

		obj = resourceClass.createInstance();
		obj.resourceFactory = self;
		obj.initResource();

		if(dispenseTo != nil)
			obj.moveInto(dispenseTo);

		return(obj);
	}

	// Get all the objects being summarized in a report.
	getReportObjects() {
		local m;

		if((m = getResourceReportManager()) == nil)
			return(nil);
		return(m.getReportObjects());
	}

	// Summarize >EXAMINE for multiple instances of our resource.
	summarizeExamines(txt) {
		local o;

		if(((o = getReportObjects()) == nil)
			|| (o.length < 1)) {
			txt.append(libMessages.resourceSummaryFailed());
			return;
		}
		txt.append(libMessages.resourceSummarizeExamine(o.length,
			o[1]));
	}
;
