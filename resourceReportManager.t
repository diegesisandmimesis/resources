#charset "us-ascii"
//
// resourceReportManager.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceReportManager: ReportManager
	resourceFactory = nil

	reportManagerActions = static [ ExamineAction ]

	checkReport(x) {
		return((x.dobj_ != nil) && (x.dobj_.ofKind(
			resourceFactory.resourceClass)));
	}

	summarizeReport(act, vec, txt) {
		summarizeExamines(txt);
	}

	summarizeExamines(txt) { resourceFactory.summarizeExamines(txt); }
;
