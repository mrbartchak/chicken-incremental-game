extends Node

const MAJOR = 0
const MINOR = 3
const PATCH = 0

const VERSION_STRING = "0.3.0"

func get_version() -> String:
	return VERSION_STRING

func get_full_version() -> String:
	return "v" + VERSION_STRING
