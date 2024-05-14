#charset "us-ascii"
//
// resourceReportManager.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceReportManager: ReportManager
	resourceFactory = nil
;

modify ReportSummary
	initializeSummary() {
		if(inherited() == true)
			return(true);
		if(location.ofKind(ResourceFactory)) {
			if(location.resourceReportManager != nil) {
				location.resourceReportManager
					.addReportManagerSummary(self);
				return(true);
			}
		}

		return(nil);
	}

	_summarize(vec, txt) {
		local resource;

		if((resource = getReportObjects(vec)) == nil)
			return;
		if(resource.length < 1)
			return;
		resource = resource[1];

		gMessageParams(resource);

		inherited(vec, txt);
	}
;
