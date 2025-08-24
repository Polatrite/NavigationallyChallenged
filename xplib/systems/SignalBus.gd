extends Node


# define new signals here
signal generic_signal(param)
signal show_floating_text(position: Vector2, destination: Vector2, text: String, duration: float, spread: float, animation_style: int)
signal help_requested(meta_tag: String)
signal help_requested_with_existing(control: Control, meta_tag: String)
