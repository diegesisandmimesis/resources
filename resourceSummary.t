#charset "us-ascii"
//
// resourceSummary.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceSenseSummary: ReportSummary
	_summarizeDesc(data, prop) {
		local o, r;

		if((data == nil) || (data.vec == nil) || data.vec.length < 1)
			return('');

		o = data.dobj;

		o._resourceSummary = true;
		r = langMessageBuilder.generateMessage(
			mainOutputStream.captureOutput({: "<<o.(prop)>>" }));
		o._resourceSummary = nil;

		return(r);
	}
;

class ResourceExamineSummary: ResourceSenseSummary
	action = ExamineAction
	summarize(data) { return(_summarizeDesc(data, &desc)); }
;

class ResourceSmellSummary: ResourceSenseSummary
	action = SmellAction
	summarize(data) { return(_summarizeDesc(data, &smellDesc)); }
;

class ResourceSoundSummary: ResourceSenseSummary
	action = ListenToAction
	summarize(data) { return(_summarizeDesc(data, &soundDesc)); }
;

class ResourceFeelSummary: ResourceSenseSummary
	action = FeelAction
	summarize(data) { return(_summarizeDesc(data, &feelDesc)); }
;

class ResourceTasteSummary: ResourceSenseSummary
	action = TasteAction
	summarize(data) { return(_summarizeDesc(data, &tasteDesc)); }
;
