function nvm-fast
	set -q NVM_DIR ; or set -l NVM_DIR ~/.nvm
	set -l brigand_nvm_fish_path $NVM_DIR/versions/node
	if test (count $argv[1]) -lt 1
		echo 'nvm-fast: at least one argument is required'
	end

	set -l command $argv[1]
	if test $command = 'use'
		set -l target_version $argv[2]
		set -l matched_version (bash -c "source $NVM_DIR/nvm.sh --no-use; nvm_version $target_version")
		if test -z $matched_version -o $matched_version = 'N/A'
			echo "No version installed for $target_version, run nvm install $target_version"
			echo "Installed versions: "
			for file in $brigand_nvm_fish_path/v*
				echo ' -' $file
			end
		else
			set -l new_path (string match -ev "$brigand_nvm_fish_path" $PATH)
			if test $matched_version != 'system'
				set new_path $brigand_nvm_fish_path/$matched_version/bin $new_path
			end
			set -gx PATH $new_path
		end
	else
		bash -c "source $NVM_DIR/nvm.sh --no-use; nvm $argv"
	end
end

function nvm
	nvm-fast $argv
end

