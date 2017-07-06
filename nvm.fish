function nvm-fast
	set -l brigand_nvm_fish_path ~/.nvm/versions/node
	if test (count $argv[1]) -lt 1
		echo 'nvm-fast: at least one argument is required'
	end

	set -l command $argv[1]

	if test $command = 'use'
		set -l target_version $argv[2]
		set -l matched_version (bash -c "source ~/.nvm/nvm.sh --no-use; nvm_version $target_version")

		if test -z $matched_version
			echo "No version installed for $target_version, run nvm install $target_version"
			echo "Installed versions: "
			for file in $brigand_nvm_fish_path/v*
				echo ' -' $file
			end
		else
			set -l new_path
			for path_segment in $fish_user_paths
				if not echo "$path_segment" | grep -q "$brigand_nvm_fish_path"
					set new_path $new_path "$path_segment"
				end
			end
			set new_path $brigand_nvm_fish_path/v$matched_version/bin $new_path
			set fish_user_paths $new_path
		end
	else
		bash -c "source ~/.nvm/nvm.sh; nvm $argv"
	end
end

function nvm
	nvm-fast $argv
end

