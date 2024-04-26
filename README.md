# noor

A module to facilitate interacting with the [Noor](https://noor.to) API.

## Installation

Clone the repository.

```bash
v install --git https://github.com/enclave/noor
```

## Usage

```v
import noor

fn main() {
	api_token := noor.get_api_token()

	if api_token != '' {
		println('API token was found')

		space_id := '<SPACE_ID>'
		thread_name := '<THREAD>'
		message := 'Hello, World!'

		println(noor.get_space_members(api_token, space_id)!)
		println(noor.send_message(api_token, space_id, thread_name, message)!)
	} else {
		println('API token could not be found')
	}
}
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)