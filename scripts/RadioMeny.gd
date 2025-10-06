extends Control
var temp = 0
var cureentAudio 
func _on_fuel_the_dead_pressed():
	%FuelTheDeadAudio.play()
	%AcidTexAudio.stop()
	%tempotantrumAudio.stop()
	%TemporumPic.visible = false
	%Acidtekpic.visible = false
	%FilthyFrequencysPic.visible = true
	cureentAudio = %FuelTheDeadAudio
	


func _on_puase_button_pressed():
	temp = cureentAudio.get_playback_position( )
	cureentAudio.stop()
	%TemporumPic.visible = false
	%Acidtekpic.visible = false
	%FilthyFrequencysPic.visible = false

func _on_plat_button_pressed():
	if cureentAudio:
		cureentAudio.play(temp)
		
	if cureentAudio == %FuelTheDeadAudio:
		%TemporumPic.visible = false
		%Acidtekpic.visible = false
		%FilthyFrequencysPic.visible = true
	elif cureentAudio == %tempotantrumAudio:
		%TemporumPic.visible = true
		%Acidtekpic.visible = false
		%FilthyFrequencysPic.visible = false
	elif cureentAudio == %AcidTexAudio:
		%TemporumPic.visible = false
		%Acidtekpic.visible = true
		%FilthyFrequencysPic.visible = false


func _on_acid_tek_pressed():
	%AcidTexAudio.play()
	%FuelTheDeadAudio.stop()
	%tempotantrumAudio.stop()
	%TemporumPic.visible = false
	%Acidtekpic.visible = true
	%FilthyFrequencysPic.visible = false
	cureentAudio = %AcidTexAudio

func _on_tempotantrum_pressed():
	%tempotantrumAudio.play()
	%AcidTexAudio.stop()
	%FuelTheDeadAudio.stop()
	%TemporumPic.visible = true
	%Acidtekpic.visible = false
	%FilthyFrequencysPic.visible = false
	cureentAudio = %tempotantrumAudio
