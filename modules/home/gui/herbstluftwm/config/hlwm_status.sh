#!/usr/bin/env bash
# Format the Panel
monitor=$1


activecolor="$(herbstclient attr theme.tiling.active.color)"
#activecolor="#9fbc00"

emphbg="#505050" #emphasized background color

print_taglist() {
	TAGS=( $(herbstclient tag_status $monitor) )
	hintcolor="#0f0f0f"
	echo -n "%{l}%{A4:next:}%{A5:prev:}"
	for i in "${TAGS[@]}" ; do
		occupied=true
		focused=false
		here=false
		urgent=false
		visible=true
		case ${i:0:1} in
			# viewed: grey background
			# focused: colored
			'.') occupied=false ; visible=false
	#				continue # hide them from taglist
				;;
			'#') focused=true ; here=true ;;
			'%') focused=true ;;
			'+') here=true ;;
			'!') urgent=true ;;
			# occupied tags
			':') visible=false ;;
		esac
		tag=""
		$here	 && tag+="%{B$emphbg}" || tag+="%{B-}"
		$visible  && tag+="%{+o}" || tag+="%{-o}"
		$occupied && tag+="%{F-}" || tag+="%{F#909090}"
		$urgent   && tag+="%{B#eeD6156C}%{-o}"
		$focused  && tag+="%{Fwhite}%{u$activecolor}" \
			  || tag+="%{u#454545}"
		tag+="%{A1:herbstclient chain , focus_monitor $monitor , use ${i:1}:} ${i:1} %{A}"
		echo -n "$tag"
	done
	echo -n "%{A}%{A}%{F-}%{B-}%{-o}"
	echo
}

print_taglist

herbstclient -i |
while read line; do
	case $line in
		tag_changed*)
			print_taglist
		;;
		*)
		;;
	esac
done

