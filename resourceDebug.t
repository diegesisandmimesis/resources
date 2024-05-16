#charset "us-ascii"
//
// resourceDebug.t
//
#include <adv3.h>
#include <en_us.h>

#include "resources.h"

#ifdef SYSLOG

modify ResourceMessageParams
	getReportCount() {
		local r;

		r = inherited();
		_debug('reportCount = <<toString(r)>>');
		return(r);
	}
;

modify ResourceSenseSummary
	_summarizeDesc(data, txt, prop) {
		_debug('data count = <<toString(data.count)>>');
		inherited(data, txt, prop);
	}
;

#endif // DEBUG
