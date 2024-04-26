module noor

import os
import net.http
import json

fn parse_env_and_get_value(key_to_find string) string {
	wd := os.getwd()
	entries := os.ls(wd) or { [] }

	mut env_map := map[string]string{}

	for entry in entries {
		if entry == '.env' {
			lines := os.read_lines(entry) or { [''] }
			for line in lines {
				parts := line.split('=')
				if parts.len == 2 {
					key := parts[0].trim('')
					value := parts[1].trim('')
					env_map[key] = value
				}
			}
		}
	}

	return env_map[key_to_find] or { panic('Key not found: ${key_to_find}') }
}

fn get_api_token_runtime(key_to_find string) string {
	mut api_token := os.getenv(key_to_find)

	if api_token.len <= 0 {
		api_token = parse_env_and_get_value(key_to_find)
	}

	return api_token
}

pub fn get_api_token() string {
	mut api_token := $env('NOOR_API_TOKEN')

	if api_token.len <= 0 {
		api_token = get_api_token_runtime('NOOR_API_TOKEN')
	}

	return api_token
}

pub fn get_space_members(api_token string, space_id string) !http.Response {
	data := json.encode({
		'spaceId': space_id
	})

	mut request := http.Request{
		data: data
		url: 'https://sun.noor.to/api/v0/getSpaceMembers'
		method: .post
	}

	request.add_header(.authorization, 'Bearer ${api_token}')
	request.add_header(.content_type, 'application/json')

	response := request.do()!

	// Check if the response status is OK
	if response.status_code == 200 {
		println('Space members retrieved successfully')
	} else {
		// HTTP request failed
		println('HTTP request failed with status code: ${response.status_code}')
	}

	return response
}

pub fn send_message(api_token string, space_id string, thread_name string, text string) !http.Response {
	data := json.encode({
		'spaceId': space_id
		'thread':  thread_name
		'text':    text
	})

	mut request := http.Request{
		data: data
		url: 'https://sun.noor.to/api/v0/sendMessage'
		method: .post
	}

	request.add_header(.authorization, 'Bearer ${api_token}')
	request.add_header(.content_type, 'application/json')

	response := request.do()!

	// Check if the response status is OK
	if response.status_code == 200 {
		// Decode the response body
		body := json.decode(map[string]bool, response.body) or {
			return error('Failed to parse response body')
		}

		// Check if the 'ok' field is true
		if body['ok'] == true {
			println('Message sent successfully')
		} else {
			println('Failed to send message')
		}
	} else {
		// HTTP request failed
		println('HTTP request failed with status code: ${response.status_code}')
	}

	return response
}