function fix -d "Correct your previous console command"
	# created using: thefuck --alias fix > ~/.config/fish/functions/fix.fish
  set -l fucked_up_command $history[1]
  env TF_ALIAS=fix PYTHONIOENCODING=utf-8 thefuck $fucked_up_command | read -l unfucked_command
  if [ "$unfucked_command" != "" ]
    eval $unfucked_command
    builtin history delete --exact --case-sensitive -- $fucked_up_command
    builtin history merge ^ /dev/null
  end
end
