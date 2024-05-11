#charset "us-ascii"
//
// resourcesObject.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourcesObject: Thing
	isEquivalent = true

	resources = nil

	initializeThing() {
		inherited();
		initResourcesObject();
	}

	getResources() {
		if(resources == nil)
			findResources();
		return(resources);
	}

	findResources() {
		forEachInstance(Resources, function(o) {
			if(self.ofKind(o.resourcesObjectClass))
				resources = o;
		});
	}

	initResourcesObject() {
		local d;

		if((d = getResources()) == nil)
			return;

		if(collectiveGroups.length == 0)
			collectiveGroups += d.getResourcesCollective();
		if(listWith.length == 0)
			listWith += d.getResourcesList();

		if(reportManager == nil)
			reportManager = d.getResourcesReportManager();
	}
;
