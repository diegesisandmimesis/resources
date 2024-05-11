#charset "us-ascii"
//
// resourceObject.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceObject: Thing
	isEquivalent = true

	resource = nil

	initializeThing() {
		inherited();
		initResourceObject();
	}

	getResource() {
		if(resource == nil)
			findResource();
		return(resource);
	}

	findResource() {
		forEachInstance(Resource, function(o) {
			if(self.ofKind(o.resourceObjectClass))
				resource = o;
		});
	}

	initResourceObject() {
		local d;

		if((d = getResource()) == nil)
			return;

		if(collectiveGroups.length == 0)
			collectiveGroups += d.getResourceCollective();
		if(listWith.length == 0)
			listWith += d.getResourceList();

		if(reportManager == nil)
			reportManager = d.getResourceReportManager();
	}
;
