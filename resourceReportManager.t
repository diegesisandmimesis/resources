#charset "us-ascii"
//
// resourceReportManager.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

// Subclass of ReportManager for resource factory objects.
class ResourceReportManager: ReportManager
	resourceFactory = nil

	//reportManagerAnnounceText = '{single/plural resource}'

	reportManagerDefaultSummaries = static [
		ResourceExamineSummary,
		ResourceSmellSummary,
		ResourceSoundSummary,
		ResourceFeelSummary,
		ResourceTasteSummary
	]
;

modify ReportSummary
	initializeReportSummary() {
		// If the base method figured out the location, we have
		// nothing to do.
		if(inherited() == true)
			return(true);

		// Check to see if the summary is declared on the factory.
		// If so, add it to the factor's report manager.
		if(location.ofKind(ResourceFactory)) {
			if(location.resourceReportManager != nil) {
				location.resourceReportManager
					.addReportManagerSummary(self);
				return(true);
			}
		}

		return(nil);
	}

	// Twiddle the summary wrapper to add a message parameter substitution
	// tag "resource".  It will refer to the dobj of the first report
	// we're summarizing.  Since resources SHOULD be equivalent to each
	// other, the vocab/counting should always work out unless the
	// instance is doing something silly that they'll have to handle for
	// themself.
	reportSummaryMessageParams(obj?) {
		local resource;

		if(obj == nil)
			return;

		resource = obj;
		gMessageParams(resource);
	}
;
