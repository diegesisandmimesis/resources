#charset "us-ascii"
//
// resourceSummary.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

class ResourceSenseSummary: ReportSummary
	_summarizeDesc(data, txt, prop) {
		local o;

		if((data == nil) || (data.vec == nil) || data.vec.length < 1)
			return;

		o = data.dobj;

		o._resourceSummary = true;
		txt.append(langMessageBuilder.generateMessage(
			mainOutputStream.captureOutput({: "<<o.(prop)>>" })));
		o._resourceSummary = nil;
	}
;

class ResourceExamineSummary: ResourceSenseSummary
	action = ExamineAction
	summarize(data, txt) { _summarizeDesc(data, txt, &desc); }
;

class ResourceSmellSummary: ResourceSenseSummary
	action = SmellAction
	summarize(data, txt) { _summarizeDesc(data, txt, &smellDesc); }
;

class ResourceSoundSummary: ResourceSenseSummary
	action = ListenToAction
	summarize(data, txt) { _summarizeDesc(data, txt, &soundDesc); }
;

class ResourceFeelSummary: ResourceSenseSummary
	action = FeelAction
	summarize(data, txt) { _summarizeDesc(data, txt, &feelDesc); }
;

class ResourceTasteSummary: ResourceSenseSummary
	action = TasteAction
	summarize(data, txt) { _summarizeDesc(data, txt, &tasteDesc); }
;
