# API Documentation

In order to import the API into your script include a source
command.

```bash
source <(curl -s "https://raw.githubusercontent.com/NeoSahadeo/bash-scripts/refs/heads/main/src/api.sh")
```

## Colors

All colors are available in the api.sh file.

## User Input

### replace_default

Used to read user input in an interactive prompt.
It will replace the variable passed into the function.

If no text is provided the default option will be used

```bash
default_name="hello"
replace_default "Set Default Name:" default_name
echo $default_name
```

### get_option

Used to prompt the user for yes or no questions.
It will replace the default option with the user input.

```bash
update_system=false
get_option "Do full upgrade?" update_system
echo $update_system
```
