#!/usr/bin/env bash
# Format the Panel
monitor=$1

source ~/.config/colors.sh
activecolor="$(herbstclient attr theme.tiling.active.color)"
visiblecolor=$color5
emphbg="$bg0_s"
fadefg="$color8"
urgentbg="$color1"

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
		$visible  && tag+="%{o$visiblecolor}" || tag+="%{-o}"
		$occupied && tag+="%{F-}" || tag+="%{F$fadefg}"
		$urgent   && tag+="%{B$urgentbg}%{-o}"
		$focused  && tag+="%{Fwhite}%{u$activecolor}" \
			  || tag+="%{-u}"
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

