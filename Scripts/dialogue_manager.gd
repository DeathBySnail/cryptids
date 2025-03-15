extends Node


var dialogueBox : DialogueBox = null

func set_data(data: DialogueBox):
	dialogueBox = data

func show_text(text: String) -> Tween:
	if dialogueBox != null:
		dialogueBox.show_text(text)
		return dialogueBox.current_tween
	return null
