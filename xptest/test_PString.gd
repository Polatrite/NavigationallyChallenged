extends GutTest

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

func test_to_proper_case():
	var terms = [
		"the slim jim",
		"arpigotti",
		"THE SLIM JIM",
		"FaNtAsTiC fAiRiEs",
	]
	var correct_terms = [
		"The Slim Jim",
		"Arpigotti",
		"The Slim Jim",
		"Fa Nt As Ti C F Ai Ri Es",
#		"Fantastic Fairies",
	]
	var i = 0
	pending() # need better to_proper_case()
	for term in terms:
		var correct_term = correct_terms[i]
		assert_eq(correct_term, PString.to_proper_case(term))
		i += 1
