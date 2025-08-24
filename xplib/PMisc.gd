extends Node

# non-null coalesce
func null_coalesce(args: Array):
	for arg in args:
		if arg != null:
			return arg

# truthy coalesce
func coalesce(args: Array):
	for arg in args:
		if arg:
			return arg

# abbreviation for coalesce()
func cq(args: Array):
	return coalesce(args)

