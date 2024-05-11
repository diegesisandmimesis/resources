#charset "us-ascii"
//
// resourceMsg.t
//
#include <adv3.h>
#include <en_us.h>

#include "resource.h"

modify libMessages
	// Should never happen, but eh.
	resourceSummaryFailed = '{You/He} notice{s} nothing unusual. '

	//
	resourceSummarizeExamine(n, obj) {
		return('It\'s <<spellInt(n)>> <<obj.pluralName>>. ');
	}
;
