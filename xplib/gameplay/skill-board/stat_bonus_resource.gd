class_name StatBonusResource
extends Resource

enum Operator {
	Sum,
	SumMultiply,
	Multiply,
}

@export_multiline var description: String
@export var stat_type: StringName
@export var operator: Operator
@export var value: float
@export var min_value: float
@export var max_value: float
